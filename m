Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590673;
	b=ivWtsZuRARs/75sQaP0EsEN1auNljn/CbdstavCs4QZErhLrGrLYKij7IlN1KUtxdfgH
	 yGgGlPblnh2kxgxHCnYbhOM5IJNDuuw2u0IJUeOxWrjCoi46kSxfgmtRzeeb32aDR6gxV
	 Ydh3+aIaemJGB9vdv3sbrbtBSJ9luu6me9hVwrQFzeeLg9vLu3RPR1RWDK7DmMJIjh/u6
	 v8VEOyExrQju74fcgYp8iJdOSS/WCFDbsd8ULysWb/xR3uA5Q7TBPNDhV2XckOi0z1YQW
	 riu6DgHuqRBspheVqGVaQyeyxswhbgTpy9OC6R3o/qxP+a+Qwzs9tJdZNo/e3NpY5bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xI/F+SuVIRzPVbIc+slO7QOc1umIckPo7Icbq0b1SEs=;
	b=bKs7QtyNx2SXGZpkdDLzPbQjIkAuDaind9nacDMOeV04gbTb16CqG0SBmjjo1Am3rmNG
	 hTmaJ2n2GQJYCYe3LA/GeVBw7IZz0Jiko6lhIB1du+EHChj4XUZAh76O/DT8iIYf3MqeV
	 bew+WtT9YYaGMUxmQdvtnoojDDmonEUKA0p/SQ0xh6TrN1cwjw9p5JoZTNVBFT/pSximB
	 xXZnpLRNdNpLm2nrY70wVz+7uPCAoqv75/4Ytu1kyf1ivxkYR3zGJRYd2m2FkrMfnPX+U
	 ueYaV65AT0X0SKtKlPSh5YU32GnCl1TJkhnN0NoItvVHCQKa20w6uyk1AWTiT4kYTLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUuXZctM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58936077D7F;
	Fri, 13 Nov 2026 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUuXZctM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F371F000C4;
	Fri, 13 Nov 2026 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590672;
	bh=xI/F+SuVIRzPVbIc+slO7QOc1umIckPo7Icbq0b1SEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUuXZctM5QLtHIsfFOI8/k/I9yPBimGx8acPWSKSyY7VV7x/hEchARBoucXjkR6Kw
	 LOt77zyes1IrnDc20wrkRPDkbqvq8XyutW90wwKcvEJUKAEa7wFNtYbg91pachc/+5
	 mEUWetdQCZzv58I14FF316arMKbCrvRwpmHMSQPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 587/686] serial: sc16is7xx: declare MCR and IER as volatile registers
Date: Fri, 13 Nov 2026 10:52:00 -0500
Message-ID: <20261113153841.701867166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 1c41d09dcd07ee9648e20aa8238e404c2e6a12fb ]

MCR register has the same address as XON1 register.
IER register has the same address as DLH register.

Which register is accessed depends on bits configuration in some
other registers.

To prevent potential access errors, declare MCR and IER as volatile
registers.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20261006192540.234402-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index b2d020a0b20d0..b5e301741b844 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -539,7 +539,9 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case SC16IS7XX_RHR_REG: /* Shared address space with THR & DLL */
+	case SC16IS7XX_IER_REG: /* Shared address space with DLH */
 	case SC16IS7XX_IIR_REG: /* Shared address space with FCR & EFR */
+	case SC16IS7XX_MCR_REG: /* Shared address space with XON1 */
 	case SC16IS7XX_LSR_REG: /* Shared address space with XON2 */
 	case SC16IS7XX_MSR_REG: /* Shared address space with TCR & XOFF1 */
 	case SC16IS7XX_SPR_REG: /* Shared address space with TLR & XOFF2 */
-- 
2.53.0



