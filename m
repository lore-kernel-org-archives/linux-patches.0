Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064707;
	b=R2SiqjjGf75aXGO8hymZRd64UbrTeXksmSozfzlndPpRK4uRa4FSewtQDtL5TP+OQKLh
	 anC0ajMw2FisuKahjrL29PcLO+9klgTtDvdP74gNA1DIkawitoFkzRh9S72oj5WgJdaxo
	 ZE9c3afKZwDMShNGsRedq3L0UIUEhI4UyTl1gCV9zqkXKASDksj5OBPN9XT3EM8QtS5es
	 IiBRKczlOLjxaO3X5uthYAIjj2OD/BGmTf2xCWT5MTX30/kUIKZOXCdYvfdRrK6s2kUnk
	 YUUZkVZVoIkIn0vZlrOZA6EFmcCh05BBoFtylPGWk5ZpI+gy3JIMhEiDHRWjAvbJqrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lnAwsYc+Y4nqU7fYS+tH0BnFQbRVHyOLhWhitI7iTjc=;
	b=3Gt2YNasUsNGPSYARH32zlneHnil1GmldE3FRfFKffo8eL+d1/hnvD7cjHum7UBt6NW5
	 IR0pVPbtiNbfKuOqcJoj0Xz4zNiHbCixrm6UBz9UFkSwfbO9OAFWRz3+nfldJStLEoqqT
	 QlEU9tXq8MwDn812GRc+MGl8ba6QHPcenaqGjFolhYMhdGnX7bZB9ZefDnLiovdtMNgs8
	 kh/1x+KVjUcQ0IrOnvHA0hS3RrF117ixY5HxvBR96CDZV0LHaqUpWqeWnJqx0AOh7KQEZ
	 cJTQfiqY2cvcRLra+0Y7gkAWNfeJA1jJ1Tn/5M8uwHvg91nboN1wgXvAop4NB5pWF+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGGWv7y+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91870606A335;
	Sat,  7 Nov 2026 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGGWv7y+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7BB1F0089F;
	Sat,  7 Nov 2026 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064707;
	bh=lnAwsYc+Y4nqU7fYS+tH0BnFQbRVHyOLhWhitI7iTjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGGWv7y+A/jboNXjZc7qoFBRYg1SAr01qS5XZKM3M31M8LiV9kEsnqNxK89ZkNRzp
	 8pemXCdfRSMEaHqMj40lYk0G7m8YUxr1HMWOFU/6ATiwfH/CcfECUoNg+L8vHr3//7
	 PfztFik8rZwDG9dV6B6bnqz/wNRC3IdHnlJN4EtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0693/1257] serial: sc16is7xx: declare MCR and IER as volatile registers
Date: Sat,  7 Nov 2026 08:49:49 -0500
Message-ID: <20261107134958.401491445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7ddc8a38adab4..fba5885595957 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -501,7 +501,9 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
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



