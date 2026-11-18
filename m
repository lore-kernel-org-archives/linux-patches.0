Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052722;
	b=YUbE0eiZuycXt+VsLBnuC51O+q95H+pISrgXWkKsu5Z7vbvOBSuffo2B86ANS7gtEqhQ
	 QbUr5KI7hV2/lCdfd1MKbbffM3LIiU2kgSra1wMRmlntdlMHcRsnR73554sNvkVzK9jYd
	 6WlxcXY8MDBT+BCMXLOZAK13AcTKBAF2WxUSDpVBvjC3OAi0E9c4oAfoucN2d2vELSSd6
	 qHq7lfpg3ifEkJlvkD5YnTdCLoqFyEBzUKgCIoU9BYJR/O24zQUTtKNcpHsvhkM0rqezz
	 NFsOvGCdDWJJ89nDQRh8qlkA29Zrf/ESlVrlSKk7jPRogNDckLYjA/HXbN/7SUXjo4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y/SSPKQwyIXbpkQuabm3giff0TUHP0cgZIkQzT2jnAs=;
	b=pxDbHuFRA8me7s4x7iLQIcp5swnoFM4AMDqRUCBMwvgE+9B4r+SPcshVU3Yh+V0ydKPQ
	 7g1BrO6zTHdY2SXxL5gwcQIYDG3OwchdJDN03Lg4WsFE3JNiAtbb0E7spzZgyGYCYDw17
	 bGd0o8154gSQNMECiUw4eAXbsz/nwP/SytGy3948/JtpSj4yShQ2ssi9xqN1H8TPuZc4g
	 XX5nunB2VygTgo3TQ+s7k9yHP5IpnboJyCnivozzmHgKTA6X6sX1YBn2lBbavec8yCx0r
	 Z5udw5asDuKNzF/eK2VR4TNdORhUsf+BZVSthZrAXXKDa5kJJomNj2npGZRkpYSgU6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFaSfUEy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C52606A332;
	Thu, 19 Nov 2026 01:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sFaSfUEy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711731F000C4;
	Thu, 19 Nov 2026 01:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052722;
	bh=Y/SSPKQwyIXbpkQuabm3giff0TUHP0cgZIkQzT2jnAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFaSfUEy0brgt1g4V+WV6eVt6gZ1a4gVfYml8cYbexXrAuHwez1vMRZ5lwulfNII8
	 gY7mcaU7b0Dt57zOGRVopT9jcDcxh/7T8+4bwRvecTYsOUHhiqA6lp5A7ok6UxPd1Q
	 tUvrHKGBOgAUCKFkopg8xeqEVoVK6oc7DNWCS7Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0664/2214] ALSA: hda/via: Apply runtime PM workaround for ASUS X55A
Date: Wed, 18 Nov 2026 15:39:00 +0100
Message-ID: <20261118150038.395285746@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit f6e8d5ebde5ceb7d3c0eef6e9e4d82862b503ade ]

ASUS X55A requires the same workaround like other machines with
VT1802, otherwise it loses the codec power on a few nodes and the
sound stays silent.

Link: https://bugzilla.altlinux.org/45606
Cc: <stable@vger.kernel.org>
Tested-by: Nikita Maksimov <nickstogramm@yandex.ru>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20261017101257.215166-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_via.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 29abc96dc146c..99e5b4734aa40 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1046,6 +1046,7 @@ static const struct hda_fixup via_fixups[] = {
 static const struct snd_pci_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x13f7, "Asus B23E", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
+	SND_PCI_QUIRK(0x1043, 0x1c33, "Asus X55A", VIA_FIXUP_POWER_SAVE),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
 	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
-- 
2.53.0



