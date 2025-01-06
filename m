Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F6DF71;
	Mon,  6 Jan 2025 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177975; cv=none; b=JxHsB1U/5b2e/AoyU78DtOVC/mR01mRTuM4yX0qKtnyIOXL46/HGlGatzI+9GGlnhP+43DtnYvvAD9Oma1ce9HelfhiD1fdA+QYGvExeVExUH23Euysqjyev5EFerzlc/JXDkjbKUUrWwg04yOSBD+d19dVOCSZQ/i5ZQz0M+5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177975; c=relaxed/simple;
	bh=ZQulslPJP9C/e23RRWDPh8ruK/KZdNO7v8VDEyRqf0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7K9m5oKMheCXq9zUTWsYyyznI6bQASwjs1qK0dNYX2yMJXP1NU1fIRJYQHA9pcGJMaPbnNBPf4Ztf4lXUDHO/D6YhR2S6iktnmjuQogEABzpjMe0QeTERGGuWgHtTjlnv6+7MO4Kbz8+mk+oxH7aBZi3WXLz5+eGl5JgzMTzX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xInWnNDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xInWnNDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07763C4CED2;
	Mon,  6 Jan 2025 15:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177974;
	bh=ZQulslPJP9C/e23RRWDPh8ruK/KZdNO7v8VDEyRqf0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xInWnNDZ2k/1e0I+Y/Y9Hlqvxz+RuxtiPAYOKkRViuG4xHOYOj2MBNYBAvRS/v/YN
	 DGsJHkmZsSMfiHWn6hMmN/C593bvhZ2SeLAGke4V9hIum6hvB/4kfZflujLM7xBory
	 hqfT1Z+XZSWAUtz2/TE8JQDkPCFZUJR+QpwQptek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/156] ALSA: hda/realtek: Add new alc2xx-fixup-headset-mic model
Date: Mon,  6 Jan 2025 16:16:14 +0100
Message-ID: <20250106151145.044632382@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e9ec5f79bd45..92fbfcd9ad31 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11184,6 +11184,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC255_FIXUP_ACER_HEADPHONE_AND_MIC, .name = "alc255-acer-headphone-and-mic"},
 	{.id = ALC285_FIXUP_HP_GPIO_AMP_INIT, .name = "alc285-hp-amp-init"},
 	{.id = ALC236_FIXUP_LENOVO_INV_DMIC, .name = "alc236-fixup-lenovo-inv-mic"},
+	{.id = ALC2XX_FIXUP_HEADSET_MIC, .name = "alc2xx-fixup-headset-mic"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.39.5



