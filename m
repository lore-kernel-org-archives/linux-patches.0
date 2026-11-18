Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026387;
	b=g1PxKljXzAsECw2OZtRFMsLrIdWCniHGnH5ee2wkqZOXIKi2Lc8KXFJyUIAP3JzV80TM
	 JLvWWqDYzAg/riOZ4EYSWruyDsDtzvIwcS5eNdUbZNmra7pl0KL6tZZ810EY2j+dZqc83
	 4VqaC+JcVIHHhd9cAyJ8y/bsp1KPsf3+ZcbRim15ohp1RQy5IHq66Fbt3TOcXQH7AWGO3
	 ugVnvJvlIySEdFLuEdaWQwzK5M1kPY3vkC60Up8AeBElowdCTwVIc0Md28llJSb4q3kPH
	 kgX3UUe4GAJl19IGzi9+1jylSgRsO6w0c/hZKIsvIalTX2aPbIwubtORUY4G4B5m0kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FeJK68iZPCWpJ+DkOiPa6HPBtVFOygnK47+bGWhPnrE=;
	b=C+EucciNX12AXLypW05pyRA4gZcx2j9EGvzc+Vzn/o3oAWpHmdKaXARooXCoQ1Ys0p0+
	 SbXsFgqz1vSKf7zYnhdo2Pnb5/mA2gxHV0WW3iwlY177Ae3nhbDcDLoyJWNZpfj0x23nw
	 Zwt4eAVeb2YAYrk1l1bAt7kFzcdX5WdiM1WPuCZuEuWNPmlyBr0Eb29RXcrihjqOSt94+
	 7393YthLWXa8RtQ0KnaYOyC1Q1EGMmfcF57CxrtypPyVIMK/A1eyOZ3djdsSvUjv/SmRV
	 6HW2S9nRmPkzwugkesDsONddZBlJ309ULv5tqXK+2UiU6h0dOShBtJZQ+Yj1eTm9ojg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2WVbdY8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6B7606A31C;
	Wed, 18 Nov 2026 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2WVbdY8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9381F000C5;
	Wed, 18 Nov 2026 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026387;
	bh=FeJK68iZPCWpJ+DkOiPa6HPBtVFOygnK47+bGWhPnrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2WVbdY86CwGtA9vGe9jpP1caisBOEqH76hDg3WLcpJOuPfxz8VEIHvedwxAaA3FS
	 ByvRLDReFgP877zqgCakytjjsHY7lIcUOlvTUuGX2jz09PXT0ucQm48f+IP9R2rwAd
	 DouuLkgOQkvlSCPzZd/cu0bIqHtCES9VW+X8evns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Gaur <yogeshgaur.83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1415/2151] comedi: ni_atmio16d: validate the IRQ supplied by userspace
Date: Wed, 18 Nov 2026 15:52:30 +0100
Message-ID: <20261118150213.512716642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Yogesh Gaur <yogeshgaur.83@gmail.com>

[ Upstream commit 71424db0ebb5f484fa3f386910f8ce9da95b8b2e ]

comedi boards are configured through the COMEDI_DEVCONFIG ioctl, so
it->options[1] is a number chosen by userspace. ni_atmio16d passes it to
request_irq() without checking it first, which lets an interrupt owned by
another irqdomain -- a PCI device's IO-APIC GSI, for instance -- be
claimed for this board. When the owner of that interrupt is later
released the descriptor is freed while this driver's handler is still
installed on it.

The driver already documents which interrupts the board can assert --
"0 == no irq; or 3,4,5,6,7,9,10,11,12,14,15" -- so use exactly that set
rather than the whole ISA range.

Bound the value before requesting it, as das16m1.c already does. An
out-of-range value is ignored rather than rejected, so the board still
attaches without interrupt support, exactly as it does today when
request_irq() fails.

Fixes: 2323b276308a ("Staging: comedi: add ni_at_atmio16d driver")
Assisted-by: LLM
Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Link: https://patch.msgid.link/20260909104848.1763-3-yogeshgaur.83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_atmio16d.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/ni_atmio16d.c b/drivers/comedi/drivers/ni_atmio16d.c
index bf7fb6704710f..54371df0b4301 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -592,7 +592,9 @@ static int atmio16d_attach(struct comedi_device *dev,
 	/* reset the atmio16d hardware */
 	reset_atmio16d(dev);
 
-	if (it->options[1]) {
+	/* only irqs 3, 4, 5, 6, 7, 9, 10, 11, 12, 14, and 15 are valid */
+	if (it->options[1] >= 3 && it->options[1] <= 15 &&
+	    (1 << it->options[1]) & 0xdef8) {
 		ret = request_irq(it->options[1], atmio16d_interrupt, 0,
 				  dev->board_name, dev);
 		if (ret == 0)
-- 
2.53.0



