Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AA019EEB4;
	Thu,  6 Jun 2024 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683119; cv=none; b=LvdDiJxDc2Gl6ywyFeocXeEcbGxJDh60ey/U9IIr8WHwRAPDopftwppF6UQoPpFy8C43+KIEddKRbl7rTlunqROjBjUqPbFH1HuNfnD9Sdbv/vCs1MqgfM/c7h9scD/H+f6bHVAUkZpkk5NzYWVihS1XywAHQlfLcuUc1Edd+/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683119; c=relaxed/simple;
	bh=IPDjPMobqEPs8BeR/XoHxSvoblpDQnyL1bRwqsBzmHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c594jqCOhWjyxQ/MC1MsaWCFevZG4Wpm6m+fVFsGgiq4JR5F8Je8x6kneVnKk0GFQWBK5Z0B94SCBe+oX7R+bIZciWaTkX7mRHRygiA/dOxNsL0Gr5BQ0XK0OgSSFWIIqnAzy1bXE/qDKs9hAdrp34tlLq2zwXji6IwbWCLDbuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eA9DDl+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eA9DDl+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22141C32781;
	Thu,  6 Jun 2024 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683119;
	bh=IPDjPMobqEPs8BeR/XoHxSvoblpDQnyL1bRwqsBzmHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eA9DDl+5cBqzbqkK2kSjdaEz8WX6b5bUJ3VDtVt3iUPXm2QhMIcvQ0PUNf5gROPq8
	 dmUFUYDwDPli8oxrAjtd0RJLPdzbJAok54HJxcd/FjuiWrF40Wo9hCOaBmu67Rxnpa
	 YQmVGUhMoAaFMW+6vpHgfRffL9YKdFn7SymcWRzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/744] ASoC: SOF: pcm: Restrict DSP D0i3 during S0ix to IPC3
Date: Thu,  6 Jun 2024 15:55:28 +0200
Message-ID: <20240606131734.228245026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 90a2353080eedec855d63f6aadfda14104ee9b06 ]

Introduce a new field in struct sof_ipc_pcm_ops that can be used to
restrict DSP D0i3 during S0ix suspend to IPC3. With IPC4, all streams
must be stopped before S0ix suspend.

Reviewed-by: Uday M Bhat <uday.m.bhat@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240408194147.28919-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-pcm.c  |  1 +
 sound/soc/sof/pcm.c       | 13 ++++++-------
 sound/soc/sof/sof-audio.h |  2 ++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/soc/sof/ipc3-pcm.c b/sound/soc/sof/ipc3-pcm.c
index cb58ee8c158a5..720bd9bd2667a 100644
--- a/sound/soc/sof/ipc3-pcm.c
+++ b/sound/soc/sof/ipc3-pcm.c
@@ -398,4 +398,5 @@ const struct sof_ipc_pcm_ops ipc3_pcm_ops = {
 	.trigger = sof_ipc3_pcm_trigger,
 	.dai_link_fixup = sof_ipc3_pcm_dai_link_fixup,
 	.reset_hw_params_during_stop = true,
+	.d0i3_supported_in_s0ix = true,
 };
diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index d778717cab10b..8e602e42afee2 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -325,14 +325,13 @@ static int sof_pcm_trigger(struct snd_soc_component *component,
 			ipc_first = true;
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
-		if (sdev->system_suspend_target == SOF_SUSPEND_S0IX &&
+		/*
+		 * If DSP D0I3 is allowed during S0iX, set the suspend_ignored flag for
+		 * D0I3-compatible streams to keep the firmware pipeline running
+		 */
+		if (pcm_ops && pcm_ops->d0i3_supported_in_s0ix &&
+		    sdev->system_suspend_target == SOF_SUSPEND_S0IX &&
 		    spcm->stream[substream->stream].d0i3_compatible) {
-			/*
-			 * trap the event, not sending trigger stop to
-			 * prevent the FW pipelines from being stopped,
-			 * and mark the flag to ignore the upcoming DAPM
-			 * PM events.
-			 */
 			spcm->stream[substream->stream].suspend_ignored = true;
 			return 0;
 		}
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index a6d6bcd00ceec..3606595a7500c 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -113,6 +113,7 @@ struct snd_sof_dai_config_data {
  *				  triggers. The FW keeps the host DMA running in this case and
  *				  therefore the host must do the same and should stop the DMA during
  *				  hw_free.
+ * @d0i3_supported_in_s0ix: Allow DSP D0I3 during S0iX
  */
 struct sof_ipc_pcm_ops {
 	int (*hw_params)(struct snd_soc_component *component, struct snd_pcm_substream *substream,
@@ -129,6 +130,7 @@ struct sof_ipc_pcm_ops {
 	bool reset_hw_params_during_stop;
 	bool ipc_first_on_start;
 	bool platform_stop_during_hw_free;
+	bool d0i3_supported_in_s0ix;
 };
 
 /**
-- 
2.43.0



