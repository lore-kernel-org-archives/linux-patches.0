Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019716;
	b=uTkfrM92hSl4DEGImxoAfAVaVFZSgJCkUnpJdjewjTNctrm3wj7j+nWNDYOkAfvSC03X
	 0r06TTIwz8pOeb3Ka/Bf03XQW4r1qDBV5e7nFSqARwspXkgvE2YKbirr1HR7/JReAwOrn
	 pt6FGc4GahpS6cfxcCpPIdG7BShLqpLe8lykp1S5YjUAAPvhy5s1aQDUkxAqaSV34D6u6
	 6n1TqLBShYRAVX4UTBaxQ2+u9m5Cg2JwuBXlu837Ug0wD9BN8sWLwH0Helpn14w2iJ+/M
	 RuGeqwj3kfziPeAPTEoSF/Qzc49944bGct9a8mC2OK3Q+8Xd59w1Q8GMW3yJ7ojPVEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PJFqxBVGg5KL2PDa+RtOYmmelCZqjNP0+qfbQOJwhdQ=;
	b=WPc+zatidxynQo3D+QhqyYqedpK6Z6bbjBDOJjdE7nPHOAEnUygrS26pF+zCdyz2PB5z
	 tfjROActjqJv2u5umyC/FdMWJdi3YrHjdQeFJPD/dlrv4TaTw6WXsvydsRcShqBS61I7X
	 srxQ3mCdfSmRk1wWqUSo5xqgj4rmCmfZYiYt+ZDzwhytZ2Wbo/mkbbDGGWkb4nRva6tbK
	 bYuuYvZPJUAlMfIMI3HQD6MtfHW5ef9uyH1VYNN7iZ2YapyjoAFEY/5fLAW/6jYFwsNvO
	 mK/DZDtI5UWrR5yjHsg8wKCl0ul8wi2EZim/fMYnsieFq6GhRvymQfvlnNkMRYOL46Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ot4dgSIc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069E606A320;
	Wed, 18 Nov 2026 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ot4dgSIc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C6E1F000C4;
	Wed, 18 Nov 2026 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019716;
	bh=PJFqxBVGg5KL2PDa+RtOYmmelCZqjNP0+qfbQOJwhdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ot4dgSIcV1WOPJTW9IOR9bTe4f4UjfQEYsSt9NZGRijQ5ZNnt+d9/JPBVf2NC7p22
	 xbzUU7ToN2OMaMlS7mzS7020tyBEd4UPl9Zsjz4JlTx+3uQkMbmIMaZAYkfo0Ncvj1
	 frEhkeBuhlB+E+TbE1CaAgnmkRJHWiSf70fiiM3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Pilichowski <pat.pilichowski@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1694/2651] platform/x86: msi-wmi: Fix hotkeys dropped with vendor backlight
Date: Wed, 18 Nov 2026 15:48:54 +0100
Message-ID: <20261118150348.653969257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patryk Pilichowski <pat.pilichowski@gmail.com>

[ Upstream commit 3e0193dc381468589e597c9e5144eb050d36f016 ]

Commit dee82409a883 ("platform/x86: msi-wmi: Reformat
msi_wmi_notify()") turned the condition for reporting a hotkey into
an early return, but only negated the brightness key comparisons,
not the backlight check. As a result, when the driver registers its
own backlight device, all WMI hotkeys are now dropped, instead of all
of them being reported as before.

Restore the original behavior: only drop the brightness keys, and
only when brightness is handled by the ACPI video driver.

This was found by code inspection. It is not tested on hardware that
uses the vendor backlight; on an MSI Katana 15 B13VFK (no vendor
backlight) hotkey handling is unchanged.

Fixes: dee82409a883 ("platform/x86: msi-wmi: Reformat msi_wmi_notify()")
Signed-off-by: Patryk Pilichowski <pat.pilichowski@gmail.com>
Link: https://patch.msgid.link/20260925213333.198058-1-pat.pilichowski@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-wmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index c9db750fe5ae6..05c35133a1b33 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -236,9 +236,9 @@ static void msi_wmi_notify(union acpi_object *obj, void *context)
 	}
 
 	/* Brightness is served via acpi video driver */
-	if (key->type == KE_KEY &&
-	    (backlight || (key->code == MSI_KEY_BRIGHTNESSUP ||
-			   key->code == MSI_KEY_BRIGHTNESSDOWN)))
+	if (key->type == KE_KEY && !backlight &&
+	    (key->code == MSI_KEY_BRIGHTNESSUP ||
+	     key->code == MSI_KEY_BRIGHTNESSDOWN))
 		return;
 
 	pr_debug("Send key: 0x%X - Input layer keycode: %d\n", key->code, key->keycode);
-- 
2.53.0



