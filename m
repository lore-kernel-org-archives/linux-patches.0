Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053932;
	b=O2yhfl1fq/y4QE8fGQsN+/9ISvxQ49gV9sUyMY6opXQi1/KAfKeu6R9t17y35iIoyeL1
	 6/SeHLi7pAjtTYBIGYNxlMmOQDHZ0Qa9ujPY9wXtPnn3XE0YWK/13NNiOa7dK41DHnCvS
	 OaA1GFqb6Kxc2fpMirOMHGJSTp6e+tqDbeD6/vnVW5QGChcTefHJe8ALkQU2l7hmI6Hg1
	 yCbnO18HVd/tMSaT5fBtVzha3L8DwVikcW8c50i7nfrmxP1CoPP+afjKfpIK4bQBGO3UN
	 rVvuIRB4gVhrhkIWrPBSsPtMz1UcGPlH03X7kvdINry/8tcEPNknMFTT6xfnyeEROoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CbqC4nzayLLhg8PPegOZ+qld0OPixIokrR6Uw/se6Yc=;
	b=Uei/vHsaAUe3EEK+YbRO0lbJpjjlxKB9wV9lyMK517y4MYgXkJeV1d2TUnAZhgAkdmSS
	 MtHwCIDBwHgx9aKMS8P0C50VoaPaSIE00ZI1iw4pZxGZ5kMONRlKPBYK0hK8EReQ42YdW
	 gb7jxAQ4iQgl6pteXqxsPFTceS3f6pnwzOeMXMfqWJDwY/oF3koYxCoSGozNoC790W1lb
	 nwbD7gNdGJduYrCyp+zcHkGDWRMt/DH8hoR6bIpFKfA1YjQ/5whsbzJcSJGOBIIz4eLox
	 kQuXlwmBLMWLc+Ccq6CkMB1SrD0EVGKAOQWPXdGjiOjORwKwqR0+op8643R0OMRDuGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NY6bZi0i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0490606A31C;
	Thu, 19 Nov 2026 02:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NY6bZi0i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDA01F000C4;
	Thu, 19 Nov 2026 02:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053932;
	bh=CbqC4nzayLLhg8PPegOZ+qld0OPixIokrR6Uw/se6Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NY6bZi0iEqL00/eDao2/QY+PxF4Sl0trMyA1N5FV8IEk7R10eEPK4SsHoMVsS6LP+
	 esfR+qLJT0ruYbHXfQpPXWgId8NBzX9T/tW+KwTZYODGUKKp+ZNhfTpjPIlruoztQg
	 qgiW5vrlijWupkP/S8c+knMjmxMV4KpxduVQQTHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1068/2214] serial: sc16is7xx: declare MCR and IER as volatile registers
Date: Wed, 18 Nov 2026 15:45:44 +0100
Message-ID: <20261118150055.003621288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained reg >> SC16IS7XX_REG_SHIFT decoding instead of upstream's unshifted register switch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index e1bb025a700d1..c66798ef91ba9 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -467,7 +467,9 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
 	switch (reg >> SC16IS7XX_REG_SHIFT) {
 	case SC16IS7XX_RHR_REG:
+	case SC16IS7XX_IER_REG: /* Shared address space with DLH */
 	case SC16IS7XX_IIR_REG:
+	case SC16IS7XX_MCR_REG: /* Shared address space with XON1 */
 	case SC16IS7XX_LSR_REG:
 	case SC16IS7XX_MSR_REG:
 	case SC16IS7XX_TXLVL_REG:
-- 
2.53.0



