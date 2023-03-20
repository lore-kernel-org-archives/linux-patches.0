Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533161C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54F8C433D2;
	Mon, 20 Mar 2023 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326088;
	bh=N7eoYudBbjL6k7958QC2rfm95vzjkqFZEI3efbhH/C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjfPk0sHBU4dDcS26Nq52WkKSxXtORpkxc82JPF6Gz3WWDMoJ3aNwmpz6okYh3Rqf
	 A38dl+gGxyh0FScPU0CGWM1Ix2iI6ZCPTSj+Y8kDNIgImy4UEIKzHMLhfkFJ4Uoxue
	 XPxAymYspKkwxE8xPLymXfHFiuxK+A+QkFR3X2/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Gongjun Song <gongjun.song@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 156/211] ALSA: hda: intel-dsp-config: add MTL PCI id
Date: Mon, 20 Mar 2023 15:54:51 +0100
Message-Id: <20230320145519.968681825@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit bbdf904b13a62bb8b1272d92a7dde082dff86fbb upstream.

Use SOF as default audio driver.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230306074101.3906707-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/intel-dsp-config.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -472,6 +472,15 @@ static const struct config_entry config_
 	},
 #endif
 
+/* Meteor Lake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_METEORLAKE)
+	/* Meteorlake-P */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x7e28,
+	},
+#endif
+
 };
 
 static const struct config_entry *snd_intel_dsp_find_config


