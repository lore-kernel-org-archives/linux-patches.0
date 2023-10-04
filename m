Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE931D559
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v80ltUuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D13C433C7;
	Wed,  4 Oct 2023 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443979;
	bh=5ZaiL8fiBdJUVbeOUtO50b90o4+VuKYQmnvNLDnSa3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v80ltUuSR1WBcyF+EuyEmvNVZspNaVZMQriPhRlbxn4OYvZZIUK5m8jbFPtAnqdt3
	 +b31PHAypwH4KyIuMnfxhvIyVKj2ZjOyM+LFp6aZwIqNJLll0bB8MQBMaFM7W2xTHz
	 mJf31wL0avJ/89QLZoNhhHW6GRtQC5LSn3GrDaeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 059/321] ASoC: SOF: core: Only call sof_ops_free() on remove if the probe was successful
Date: Wed,  4 Oct 2023 19:53:24 +0200
Message-ID: <20231004175231.903994587@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 31bb7bd9ffee50d09ec931998b823a86132ab807 ]

All the fail paths during probe will free up the ops, on remove we should
only free it if the probe was successful.

Fixes: bc433fd76fae ("ASoC: SOF: Add ops_free")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20230915124015.19637-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sof/core.c b/sound/soc/sof/core.c
index 30db685cc5f4b..2d1616b81485c 100644
--- a/sound/soc/sof/core.c
+++ b/sound/soc/sof/core.c
@@ -486,10 +486,9 @@ int snd_sof_device_remove(struct device *dev)
 		snd_sof_ipc_free(sdev);
 		snd_sof_free_debug(sdev);
 		snd_sof_remove(sdev);
+		sof_ops_free(sdev);
 	}
 
-	sof_ops_free(sdev);
-
 	/* release firmware */
 	snd_sof_fw_unload(sdev);
 
-- 
2.40.1



