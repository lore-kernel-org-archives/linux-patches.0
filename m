Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49412D787;
	Fri, 24 Nov 2023 18:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htt7zGwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8073C433C7;
	Fri, 24 Nov 2023 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851758;
	bh=b+dQZZh/fj8bxXwaZd2IQAup9JeU93qd3DK2S2T92BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htt7zGwQOdinnB7oGnXKoXSsgfa3oMq8lDsyjD4hmQd/C3UhNbIb0OFraGesq9j+s
	 WN9fcIr122rXFTAnIqw83tup/3K1n8P3Mjmqt6jssMUSQMIgkLTWC7fny4GjBLmUGK
	 UfGNSUGnvtKCBdxCGe+fxc6Sk3SUPXZMd6uAmwgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rander Wang <rander.wang@intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/372] ASoC: SOF: ipc4: handle EXCEPTION_CAUGHT notification from firmware
Date: Fri, 24 Nov 2023 17:47:26 +0000
Message-ID: <20231124172012.450025743@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit c1c48fd6bbe788458e3685fea74bdb3cb148ff93 ]

Driver will receive exception IPC message and process it by
snd_sof_dsp_panic.

Signed-off-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230919092416.4137-10-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/ipc4.c b/sound/soc/sof/ipc4.c
index c08f3960ddd96..06e1872abfee7 100644
--- a/sound/soc/sof/ipc4.c
+++ b/sound/soc/sof/ipc4.c
@@ -601,6 +601,9 @@ static void sof_ipc4_rx_msg(struct snd_sof_dev *sdev)
 	case SOF_IPC4_NOTIFY_LOG_BUFFER_STATUS:
 		sof_ipc4_mtrace_update_pos(sdev, SOF_IPC4_LOG_CORE_GET(ipc4_msg->primary));
 		break;
+	case SOF_IPC4_NOTIFY_EXCEPTION_CAUGHT:
+		snd_sof_dsp_panic(sdev, 0, true);
+		break;
 	default:
 		dev_dbg(sdev->dev, "Unhandled DSP message: %#x|%#x\n",
 			ipc4_msg->primary, ipc4_msg->extension);
-- 
2.42.0



