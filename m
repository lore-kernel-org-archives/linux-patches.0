Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149641A3029;
	Tue, 12 Aug 2025 19:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025412; cv=none; b=s40008hoybsLzegltl0dOgJ6HYimz1DIBblJDcW+maSgvtTZ3O+NNgAqnzK6oMsD+28ULfAbrTIbrmZUYjkupb44f3124SRAyB4BF1C6nrgOb/VeumfxWj6i253H683gOYTgdiPjXWXbmljYMRUby4JjQgY0S1hAjvorOuQmNks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025412; c=relaxed/simple;
	bh=Z4DC/ehNY3A79vbmUm7viPfoBbzBGZTVWTevpoLZDrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hS231NpNL9FuEx4HmVx0mv+JZwAJ5d1IJni/CX9OVphnD0Ea5ygk1KuJaBZnlqGEKbDlssgHtIC5exe9yE4FU0qX+bLfdehuhk6DqnDS6zJBMN8Lq6GoeQdE0Tzs6E+A0NPjmYPrqYvoSEC/QAsVc1JRRUCMDUxwsgV6bXzNdPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0AiZVbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0AiZVbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779EEC4CEF0;
	Tue, 12 Aug 2025 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025412;
	bh=Z4DC/ehNY3A79vbmUm7viPfoBbzBGZTVWTevpoLZDrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0AiZVbF2qOuwaAMiHC3n53yeR8R2KZ2D4fXcP54rsV2oNmaymd05fLy2qOnbNfe8
	 WdJkUAVAYgoo5HDZdOscUG6F1iPjohDO8tGaSqHgwZobSL7+uYhBamG7+9EkQcwE4K
	 uGws8v7dB2MGFcY4GekYomBBevA45/fWE1+2Ehho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 006/480] ALSA: hda/realtek: Support mute LED for Yoga with ALC287
Date: Tue, 12 Aug 2025 19:43:34 +0200
Message-ID: <20250812174357.570319983@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit 4722727373533b53489b66d3436b50ac156f23bf ]

Support mute LED on keyboard for Lenovo Yoga series products with
Realtek ALC287 chipset.

Tested on Lenovo Slim Pro 7 14APH8.

[ slight comment cleanup by tiwai ]

Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20250714094655.4657-1-xy-jackie@139.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3c93d2135717..bf36e84d260b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7497,6 +7497,9 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	};
 	struct alc_spec *spec = codec->spec;
 
+	/* Support Audio mute LED and Mic mute LED on keyboard */
+	hda_fixup_ideapad_acpi(codec, fix, action);
+
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		snd_hda_apply_pincfgs(codec, pincfgs);
-- 
2.39.5



