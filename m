Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043315;
	b=bEi+eZj2MgY+rhSwE5RLjI00IYcCh9NUfuf/jTF2NDqNfxl0DO50hUpGNfJsRzdrAvbF
	 ZoXQfQYPKoYSYM+z0RCYEgrpO44wztoDoFrqJX2f0eVhlaHDs4N4lJUOmBK+KMT/ALHsm
	 MGe34tgpvN/7E0BdtglN8jcUq7m/QSZ6dVVSgUorouWBTrqwEKkQb1KazSFFODltCzLE6
	 yS8bB371hR6BVjQfe7WL1x+yuQ1ATUVNFB+wpVJA4KJ+UIRS/NMvwm5rXy9+o5JuYlFDY
	 Ey0K8dYBQupkFFkwvaNuLRikfZ2Si2bPBmzH08JiGScLm9WW2VSc3D1G5WcM8SMBXbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jB982b6rynLcX3Bj6HX1GG3lXIfLC267jRqKpWvqVV0=;
	b=Kk4KRlL2CQNQyQOzbOYN/rSkEzS/uP0Clm6nWXHL75ZDYctDKoqqI8VWdUZqgk/1kTJ6
	 H1uh0wZfNnZVC8Ay8T7H5CYfrjTnaI6kFa+L2M5MYxahKOL29Ke2tI78h9MKy43tE/Uig
	 noGLyeJD82ieOiiZt0cZ4r7/if4sJu3iajGHPz1P0NP+1xQTWIfZcjoPTqBbUDDFGmPpn
	 aH/SVYDDMyQea+P7DIJr8AXJ/ls/LE6yX5i/hwQevHCvdaxf8SG5mDi6XAvsTRc1XVX68
	 JdLredfNn72wBhUKCNHkcvNsDbYJKJATOOIn40w6rETLKpkPPIAylvUwRpxhbWIQH6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGZ8qb2v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513F1606A32C;
	Wed, 18 Nov 2026 23:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGZ8qb2v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE841F000C7;
	Wed, 18 Nov 2026 23:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043315;
	bh=jB982b6rynLcX3Bj6HX1GG3lXIfLC267jRqKpWvqVV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGZ8qb2vN/lFetC/O+ui2+f4emxeiXTOLsomvz7TpDm4AZBXQCNmtFxFmPAENjhOL
	 nhKwXJi8lxlqDT9q5ycl7MOCT4JcPj0LRqhIywCRsi3jeJRB8PPpTkgqGGFUN8ctbL
	 h/xIbeB3OMyvMOPXSub72vPWF/wgmeVNKHXxhn2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0167/2857] ALSA: hda/realtek: add missing NULL check for codec->bus->pci
Date: Wed, 18 Nov 2026 15:20:01 +0100
Message-ID: <20261118150207.367366450@linuxfoundation.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 3b36ac93739e7b119a30affaee9c2dd41f24efbb ]

In alc269_probe(), codec->bus->pci is dereferenced without a NULL check
for the ALC236 vendor ID case. Add the missing check, consistent with
the existing pattern used elsewhere in the same function.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-2-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4b4e85d83af36..ce737b84729ca 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11284,6 +11284,7 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
 		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci &&
 		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
 			spec->en_3kpull_low = false;
 		break;
-- 
2.53.0



