Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670CA1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBDDC433EF;
	Wed, 28 Dec 2022 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246057;
	bh=WeuD6eZ7Mp1ShsdYfaFc7Pentz89s4TFU41dw5g4hho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPM4TovAie3TwtjBPFfPRTvoJkO2tCX+9pF3tPTEhro+We6BiOOhTDf3OebvVJN0z
	 vbmTsUCbApe8yx95k8dVnCrHfWCB+javBLK8zU6NAffpp1D8aQVeVzmHGuhiNUhwXk
	 pZfyXlACHlyZzCLsDgr5JN46QG7r/Cq9A+4jsmc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1005/1073] ALSA: hda/hdmi: set default audio parameters for KAE silent-stream
Date: Wed, 28 Dec 2022 15:43:13 +0100
Message-Id: <20221228144355.445781312@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit b17e7ea041d8b565063632501ca4597afd105102 ]

If the stream-id is zero, the keep-alive (KAE) will only ensure clock is
generated, but no audio samples are sent over display link. This happens
before first real audio stream is played out to a newly connected
receiver.

Reuse the code in silent_stream_enable() to set up stream parameters
to sane defaults values, also when using the newer keep-alive flow.

Fixes: 15175a4f2bbb ("ALSA: hda/hdmi: add keep-alive support for ADL-P and DG2")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Tested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20221209101822.3893675-3-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 3655584fc37b..da5276e7eab1 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1788,6 +1788,7 @@ static void silent_stream_enable(struct hda_codec *codec,
 
 	switch (spec->silent_stream_type) {
 	case SILENT_STREAM_KAE:
+		silent_stream_enable_i915(codec, per_pin);
 		silent_stream_set_kae(codec, per_pin, true);
 		break;
 	case SILENT_STREAM_I915:
-- 
2.35.1



