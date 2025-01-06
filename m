Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DBB8634A;
	Mon,  6 Jan 2025 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176948; cv=none; b=M1Fkmz+49J2uQjiGFvZ07ZnE+C9dsYPiVmuoO7Ejk9nSwHCh8+wiCP+zHEJwHm6223+HmP9hvn6j7JTRKwbcbM5OmaAJxWju+ufeAeC8UT2FG5MyT5KvmQ0rOkz22cMdsNZ/oWH8egeDkDkX6r6vdpG/1TM7r+xUJTzCcM2Kiv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176948; c=relaxed/simple;
	bh=g4CHf7A/gPfoOaO295JSuuWx1c/3HioJ76JCPTpXAVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKPuR9vFCS9j8DyaSCzQ1olVnzCr4KGMXOoB7F9jL+kKDy04jixmWs4UkiO7lgVAzeKEsopZSofyyqu7jHyNNB0L/eZFjNn0pLoJXYNBz17Vkvk04jk7tqE9N+9VnjhXJdD0L1qIgpHVgDUElnHRbACG4OhaAkfGStnsC60m+Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+LzkeBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+LzkeBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A7BC4CED2;
	Mon,  6 Jan 2025 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176948;
	bh=g4CHf7A/gPfoOaO295JSuuWx1c/3HioJ76JCPTpXAVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+LzkeBOTTBqQUARd5w/u32b2/kP+5k/+vkMQG1ad9MBSZES0n7CYKi5M2LGHtvzM
	 qf6wy9IcrENbpMj0uk+hP6de84R+Ktkln0gGQIMuV93BINQ7r2ZOrf6at7tykT70cL
	 wzgxE4PYK2kNgdEbje+dK3NmynGzEMEgPI2z8j1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 56/81] ALSA: hda/realtek: Add new alc2xx-fixup-headset-mic model
Date: Mon,  6 Jan 2025 16:16:28 +0100
Message-ID: <20250106151131.551431722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 50db91fccea0da5c669bc68e2429e8de303758d3 ]

Introduces the alc2xx-fixup-headset-mic model to simplify enabling
headset microphones on ALC2XX codecs.

Many recent configurations, as well as older systems that lacked this
fix for a long time, leave headset microphones inactive by default.
This addition provides a flexible workaround using the existing
ALC2XX_FIXUP_HEADSET_MIC quirk.

Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20241207201836.6879-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ef9b0cc339f2..0fd61a165edb 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10443,6 +10443,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC255_FIXUP_ACER_HEADPHONE_AND_MIC, .name = "alc255-acer-headphone-and-mic"},
 	{.id = ALC285_FIXUP_HP_GPIO_AMP_INIT, .name = "alc285-hp-amp-init"},
 	{.id = ALC236_FIXUP_LENOVO_INV_DMIC, .name = "alc236-fixup-lenovo-inv-mic"},
+	{.id = ALC2XX_FIXUP_HEADSET_MIC, .name = "alc2xx-fixup-headset-mic"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.39.5



