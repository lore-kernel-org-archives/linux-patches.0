Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91423212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453C3C433D2;
	Tue,  7 Feb 2023 13:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775067;
	bh=6pjUSuhAj9MlD6LYSGoLgPVu1Q8/WKJinH8jLawIQSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGrVnL+CEndWRnz0tiyhajk3X5lp+z3dKHxUP2+jHB/046kDNL5Vs6L9v00QrUtvC
	 F0akicXM5rJjR/Fs6xP65H+TKm0iByEvRycDqYpRFpN7jcRKaIyrbdqlK8iiWmzLmw
	 JqE8AghIAnqK2CXnaZcEA7ys5rORwbGlaUQAycd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 127/208] ASoC: SOF: sof-audio: unprepare when swidget->use_count > 0
Date: Tue,  7 Feb 2023 13:56:21 +0100
Message-Id: <20230207125640.163465376@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit 7d2a67e02549c4b1feaac4d8b4151bf46424a047 upstream.

We should unprepare the widget if its use_count = 1.

Fixes: 9862dcf70245 ("ASoC: SOF: don't unprepare widget used other pipelines")
Cc: <stable@vger.kernel.org> # 6.1
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230118101255.29139-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/sof-audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 7306a2649857..e52ef62ce7a3 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -272,7 +272,7 @@ sof_unprepare_widgets_in_path(struct snd_sof_dev *sdev, struct snd_soc_dapm_widg
 	struct snd_soc_dapm_path *p;
 
 	/* return if the widget is in use or if it is already unprepared */
-	if (!swidget->prepared || swidget->use_count > 1)
+	if (!swidget->prepared || swidget->use_count > 0)
 		return;
 
 	if (widget_ops[widget->id].ipc_unprepare)
-- 
2.39.1



