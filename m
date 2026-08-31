Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4354A2608;
	Mon, 31 Aug 2026 13:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183729; cv=none; b=R1a2+3kwZEZutQVRnV0+5ZmmN3aNjWCtPhEV7icX1pvLuwJxpVFKMkDKzKj9AlbAb4sWk2NMqUkTNyEBF/Ie+stGgUlrNnRD5+G87Uv9s/S1kMm8PCBJK2cdQ3bBdOEUvk3QzqfdJ0qa5g1K0j0IDrLKGNiRfieLaM93mPMSkfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183729; c=relaxed/simple;
	bh=OSKozJjrhEsRCVhvWDVHhSaB81NG3aZJQ+pM4v53rgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvL8nUEC9UWyKlOAZs1kroevtBiMwcpVkbx9w6f4gmxVC92jdDg3TnGS/HhnyL4hzgUCJCjtkZeqX6o89OvdZ/+uBy73blikvv85Qn85KqZt8XpOBI7lrOGf4oE7daotMtpAHd10I5XMZCebEZRKA3AUK/nuIl7t8VDNwSmO6bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6KTKpIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6KTKpIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D901F000E9;
	Mon, 31 Aug 2026 13:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183727;
	bh=rGddk9GMlUdLNtf4YubZB+mQNgvxnX4bklOJ/NjjwQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6KTKpISlBMtWdEYkc+F0r/Tng+8VoufdXK4Ano0M2qE1OfrkmU43RphdHsJqM1md
	 A4tfUeEiLPQ+J+E1Xm/BXcbZANKjZSPpJASRTUmLug1GiKy09hIrlZ72lyQlXAnrJy
	 5cS/u9Xg2aBMFNtF9F7HCEWpJFkmQppSFfMZAIkKIUECXCY2ayKA69dVUFqAX/igmi
	 4s2sTWHTSKcy+VH4kJwSaBXmTe8D0+bL6qnGDdLtdxoVHybD4fHt/pqU7bVC+1Qr2b
	 ZX1o8KHAdRa+hJyHfSmxuBE2hZxDs2poC2WROsST0i7jJbq+4AH2Ar+CQE+eHEJ6xI
	 2r9RmVZUm4fYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	rubenru09@aol.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] drm/gud: Add RCade Display Adapter VID/PID pair
Date: Mon, 31 Aug 2026 09:24:56 -0400
Message-ID: <20260831133314.4125787-268-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Sophie D <patches@scd31.com>

[ Upstream commit ac5ac0acf11df04295eb1811066097b7022d6c7f ]

The RCade Display Adapter is a hardware device that allows driving an
Arcade CRT display via the GUD protocol. Currently it spoofs an
existing GUD VID/PID pair. However, now that it has its own pair
assigned, it makes sense to add this to the list of pairs that GUD
supports natively.

More information can be found in the project repositories:
https://gitlab.scd31.com/stephen/stm32-usb-vga-adapter-hardware
https://gitlab.scd31.com/stephen/stm32-usb-vga-rcade-adapter

Link: https://pid.codes/1209/4FB3/
Signed-off-by: Sophie D <patches@scd31.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260509025405.4143956-1-patches@scd31.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished:

- **`git log --all --grep='RCade Display'`** found the commit at
  `3eeabc569d3db` (upstream `ac5ac0acf11d`). It is **not** on the
  current 6.18.43 HEAD, which matches the missing `0x1209:0x4fb3` entry
  in `gud_id_table`.
- **`git log -S'0x4fb3'`** only turned up unrelated matches in other
  subsystems; nothing in `drivers/gpu/drm/gud/`.

That confirms the earlier analysis: this is a one-line USB device ID
addition to an existing driver, and it is not yet in this stable tree.
The backport recommendation remains **YES**.

 drivers/gpu/drm/gud/gud_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/gud/gud_drv.c b/drivers/gpu/drm/gud/gud_drv.c
index a2000991ecbe4..4f0906f677b2a 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -684,6 +684,7 @@ static int gud_resume(struct usb_interface *intf)
 static const struct usb_device_id gud_id_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x1d50, 0x614d, USB_CLASS_VENDOR_SPEC) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x16d0, 0x10a9, USB_CLASS_VENDOR_SPEC) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1209, 0x4fb3, USB_CLASS_VENDOR_SPEC) },
 	{ }
 };
 
-- 
2.53.0

