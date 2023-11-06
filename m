Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F5200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oywtv4f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56179C433C7;
	Mon,  6 Nov 2023 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276127;
	bh=ch9FN5y30Y5sb46VrY5daUxmnUQdSy2EMV3TQ9FZwZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oywtv4f8A1qDoPp6iRayNzaIxhjl0nNDMvEW2TBBblXfg3YcItsQe9aXOv5e6R+hO
	 Eb6bLfF8Xx8OFWfny16dqT+PATtkdYAxUbzunAD21bYibGtU1Rb6jl0LiJffiAsrPo
	 kdloHTtrtD6FQdRkYisrHMeLftH2OWQXj3HfIYQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Hasemeyer <markhas@chromium.org>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 29/30] ALSA: hda: intel-dsp-config: Fix JSL Chromebook quirk detection
Date: Mon,  6 Nov 2023 14:03:47 +0100
Message-ID: <20231106130258.906181125@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
References: <20231106130257.903265688@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Hasemeyer <markhas@chromium.org>

commit 7c05b44e1a50d9cbfc4f731dddc436a24ddc129a upstream.

Some Jasperlake Chromebooks overwrite the system vendor DMI value to the
name of the OEM that manufactured the device. This breaks Chromebook
quirk detection as it expects the system vendor to be "Google".

Add another quirk detection entry that looks for "Google" in the BIOS
version.

Cc: stable@vger.kernel.org
Signed-off-by: Mark Hasemeyer <markhas@chromium.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231018235944.1860717-1-markhas@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/intel-dsp-config.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -336,6 +336,12 @@ static const struct config_entry config_
 					DMI_MATCH(DMI_SYS_VENDOR, "Google"),
 				}
 			},
+			{
+				.ident = "Google firmware",
+				.matches = {
+					DMI_MATCH(DMI_BIOS_VERSION, "Google"),
+				}
+			},
 			{}
 		}
 	},


