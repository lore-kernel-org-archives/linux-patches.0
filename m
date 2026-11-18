Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038370;
	b=bhM4/ncKlawZvHzp4KmVelslgxlMPaWsF3Nlm3mdyiCojFHndDjBxU+vugpoACOvqpf/
	 SXQc3yNQO/F9w9DX09yxdsRY1hzk6WebHEsCrmRIob+vI0qwC1te2nuLhBh6DwO37La8d
	 kAuFU2K4930tFHW0/cKge45yt58aI7vjlwAMZBBXy+UPVM3bXtx5ozF9Ii47Zk5vTbfSm
	 dnbCTXLLMvWKRKtXO4LcWFRlYiVzIYIa1IemHAdUiqgMIH2BmTI9k3oAxiby+mNYmRXyL
	 KprB9tK2+w7yfIVh8i8bcnHnE+FR3gqyWTrdzsL5Bt6ty0wDJrnudgfLS8u2fdAHVvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nkhSMSZThVkvcXv80gb365WvQELNoLg0LRHZDZvvYwQ=;
	b=N8RJUiDxc1/Yp2jfcIVUpbZhn3vDZhro6m7yiEFJrCds0/JmV/WnU3i/KPQf2zYbYP2x
	 7kVpsp7KcpcRfLiKXrdMZcTantgaINPLL8lXPe0IddDKGHZrk2dtuZ5jtS1KEH7r51y8C
	 /inK+cFn7wjTwY31z+dAqygmWPiv60Pb7vta3KDHLfltgb19n9hsiXR1JgyaOXdjqC0h/
	 cQivnkQiUJ7M1Ig5EYPpuc39ohS+XVBmVTZ1cXK4d09lZ8WojwTXY34XNtlYWxnQBOu8q
	 reryvazsJrxTdpG3imXkLtf+/1uVpKpB/aq5CEcvHVrZ4wV8OtkwNcRhvvrh+JuN0sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBZwYOC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD6A606A31C;
	Wed, 18 Nov 2026 21:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBZwYOC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DA71F000C5;
	Wed, 18 Nov 2026 21:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038370;
	bh=nkhSMSZThVkvcXv80gb365WvQELNoLg0LRHZDZvvYwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBZwYOC+z/23j2lE2pEVTBHTFVPkAmNiEj0CzXJc9soIOoADw9oLW7XYCJJvzExZR
	 Z2IC/KcUJ3c7lSP1eUtwvCQ0zfIrzFqGXNujFE7qtnIpBCCNFt9wVrYlbib2fNVUPO
	 XDU2gv7W8USMB/O8kcdhXNW8whHanSnOQhFR61Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1720/3318] serial: sc16is7xx: declare MCR and IER as volatile registers
Date: Wed, 18 Nov 2026 15:39:02 +0100
Message-ID: <20261118150413.466043636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a11bd9230555..34260d06b114b 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -533,7 +533,9 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
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



