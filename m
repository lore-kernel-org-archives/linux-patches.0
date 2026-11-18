Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047001;
	b=qsQK4B5EQtff47ZclMoaQpBza0bqJF2GesmtaUSMw7Gaabu1Qn2dL/MJscfAzomRBIFK
	 Q9FqJ7FROSWpv/TQdzmq4al71UDsE912Jbq61qLQhI9EZB5k5Jk2U3Cz6x+5tOotZ13G1
	 THuvMJAFZ1g2doJnzQHSlpf0tM2/SSjV6KZ72mnaimmLjuSQtCFMEn2A/YMH24HyAv0Uy
	 dQWCLILqrfvDa3UIQ2WNUda9ICWDu31rLwV/1ztA+tcVDycSzoyhic+KrLo5Vp+lNp9B+
	 9oljybmdc4wuGZ1sqeWDMLz49rlgybqH/tylFHqDm8yBzcbOalm9fbr+nS44ibu5vng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UUi8W4R2eW+gCc+ODIw1W2v3VMzFnW+UICURuryro4U=;
	b=PosGEThT1LpUiAwwonZwhLTOnXmOHfb2D+y1L1+EaH7Zq4P+kDEmpXZGxBImGtkXrztl
	 gc8pg7R8A3pe7FXzVWWUfyLAxQ45rW3BBdF2jirlQysR/P/aUs3GgG1xNnspKpZFmh+eI
	 Sct59/e4Jn6S4TMmRAOk1gHuDSb1SuO2erOWyPkUI+6Pc+qE4Ent8125g1PMHgRyUjR1l
	 AyZ6SRg4jyyhztSkc9Ie4q2W27qmCvMgSB3fcpydonkpimu5hy3n4MUzgKlLmHmLZtomE
	 P5ZeJkr39p6y56ZFQ/NhmOr1AW1mTPY/BLV0OpKeAwVmSzo4+PWZC9Is/ip7Zs+Bhaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qn9yfqIO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254AF60A260B;
	Thu, 19 Nov 2026 00:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qn9yfqIO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6468F1F000C4;
	Thu, 19 Nov 2026 00:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047001;
	bh=UUi8W4R2eW+gCc+ODIw1W2v3VMzFnW+UICURuryro4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qn9yfqIOsePl7IYBGttSxfQzJdaf7NNtfFGoJFXAJWcNSwD7TFC+ju6/VNJceQC9X
	 2n2s2iRlE5hLfyAKaNWenH22VCFZMcXuiclmIJCeQSqwBE2ThrJd5vQ11RFjL1GP7/
	 ogb5b5Vwq1TugCZvaTOXkzyKe/WZFk51+OmH6/Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1465/2857] serial: sc16is7xx: declare MCR and IER as volatile registers
Date: Wed, 18 Nov 2026 15:41:39 +0100
Message-ID: <20261118150254.060193729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c55cad61ff0bd..a5b5f879b0e98 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -531,7 +531,9 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
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



