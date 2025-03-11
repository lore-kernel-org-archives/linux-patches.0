Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562DD25D8F9;
	Tue, 11 Mar 2025 15:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706041; cv=none; b=OWIAmbGQZM9N8KtmUg0jBvTfjGiukm4Io5HMKV1uP6QopNpyYj5pgbTsVLAPiSwmqtda6bUsed+Nt1CX62qAuybNEshP6ZvYJILaJ9+q6XQ4HN3B2AnOz6tZJEt8w4DL6b7+w81KLjFs8HWHcOIRMrx03st0A5mRYJALgzbyImY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706041; c=relaxed/simple;
	bh=WmNGpJsdJm4bDqxjY15BVdH8rZDLgHnApw7NZ1A0ctU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFEShyzX1X4J9yrk4y51k4PyIkeS8mBp87O1Ekjl8nBvp05J5whSVpWosCeyYJvSURiMxR6stPaabvqxgQ7oh/+sHgZQUhwhVm49ZlT5u60/2fqAFkFYO5sN1JSznLSSWCOd6Ij+SEkYYByWffEX/gQHxNDXlFdPorDv9SPc4L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tg+FHdNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tg+FHdNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3928C4CEE9;
	Tue, 11 Mar 2025 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706041;
	bh=WmNGpJsdJm4bDqxjY15BVdH8rZDLgHnApw7NZ1A0ctU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tg+FHdNvVx6JNQdK3Uj+1ZMC0Qy3rN7xv/TWe3kg1KRPCgCXtDZ7vJV0219iWridw
	 bqcAVFet3W1RvoP8U5vdZcpylMZLXzj6bWYpq6RXbexkvdbhN/vRIOJ5cJOevdW1q4
	 0XxgOdyUNeROv17JjG+OO5PkTCw7101LGzJ0+hKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 242/328] ALSA: hda/realtek - Add type for ALC287
Date: Tue, 11 Mar 2025 16:00:12 +0100
Message-ID: <20250311145724.532213433@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 99cee034c28947fc122799b0b7714e01b047f3f3 ]

Add independent type for ALC287.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/2b7539c3e96f41a4ab458d53ea5f5784@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 174448badb44 ("ALSA: hda/realtek: Fixup ALC225 depop procedure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9b344b80f950a..069515b065386 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3111,6 +3111,7 @@ enum {
 	ALC269_TYPE_ALC257,
 	ALC269_TYPE_ALC215,
 	ALC269_TYPE_ALC225,
+	ALC269_TYPE_ALC287,
 	ALC269_TYPE_ALC294,
 	ALC269_TYPE_ALC300,
 	ALC269_TYPE_ALC623,
@@ -3147,6 +3148,7 @@ static int alc269_parse_auto_config(struct hda_codec *codec)
 	case ALC269_TYPE_ALC257:
 	case ALC269_TYPE_ALC215:
 	case ALC269_TYPE_ALC225:
+	case ALC269_TYPE_ALC287:
 	case ALC269_TYPE_ALC294:
 	case ALC269_TYPE_ALC300:
 	case ALC269_TYPE_ALC623:
@@ -9342,7 +9344,6 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0245:
 	case 0x10ec0285:
-	case 0x10ec0287:
 	case 0x10ec0289:
 		spec->codec_variant = ALC269_TYPE_ALC215;
 		spec->shutup = alc225_shutup;
@@ -9357,6 +9358,12 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->init_hook = alc225_init;
 		spec->gen.mixer_nid = 0; /* no loopback on ALC225, ALC295 and ALC299 */
 		break;
+	case 0x10ec0287:
+		spec->codec_variant = ALC269_TYPE_ALC287;
+		spec->shutup = alc225_shutup;
+		spec->init_hook = alc225_init;
+		spec->gen.mixer_nid = 0; /* no loopback on ALC287 */
+		break;
 	case 0x10ec0234:
 	case 0x10ec0274:
 	case 0x10ec0294:
-- 
2.39.5



