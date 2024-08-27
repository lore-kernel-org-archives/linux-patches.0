Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259A1C4EDD;
	Tue, 27 Aug 2024 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772234; cv=none; b=Bm3K/uxsFI1IXtga/cbXzGcvtAYZA2rfg9nhYYOpgz5Z6/qc4EtdzZUNsDhem8r+vj/RNvav3CZZjVK3NgXb1gShlOv8untrAhWi9IKvMDuf4CRzknVqfQkJTFrk3PbkNpl48emmCkvn5BZXyrnRtTzcXvdMp6cs6/Lr88qYo/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772234; c=relaxed/simple;
	bh=BufUokUzJL7tfCNUas87FKUzcq67twwpvyKAqLdxrw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lbfl6udF6uSF+PPESgBXUEGpbPUu7wFPRP4XIST+Rtk2I5/U4ejsNW+0irnklD3h4xaCmijch42wMldCjCTfgRkl5hDrm2Ich+aeVgqyJczEruynVMZJR8lAfnmkWv77VXjEFfsnAl4T/lwPfxCS/BTtGtpw7sMbZ8TrMPyj2rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR6AdLYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR6AdLYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A719AC61062;
	Tue, 27 Aug 2024 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772234;
	bh=BufUokUzJL7tfCNUas87FKUzcq67twwpvyKAqLdxrw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR6AdLYLY5uQ8X49z37pOLefApHussp5VZZ0u8rxmZjihkRxk9pA582QoMjzJIRMN
	 wCT7w1uIWm3re/bZTXtTN7LUvsnFpT+ne6lqIv3jFlODwLbOEVBd7jVMBLiwa5iGwY
	 UzIK0CkNNUNOyzeYtGQXE3Qkv1JTrIAZkZID+n4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/321] ASoC: SOF: ipc4: check return value of snd_sof_ipc_msg_data
Date: Tue, 27 Aug 2024 16:37:41 +0200
Message-ID: <20240827143844.058764289@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 2bd512626f8ea3957c981cadd2ebf75feff737dd ]

snd_sof_ipc_msg_data could return error.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20231129122021.679-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc4.c b/sound/soc/sof/ipc4.c
index 06e1872abfee7..1449837b0fb2c 100644
--- a/sound/soc/sof/ipc4.c
+++ b/sound/soc/sof/ipc4.c
@@ -616,7 +616,14 @@ static void sof_ipc4_rx_msg(struct snd_sof_dev *sdev)
 			return;
 
 		ipc4_msg->data_size = data_size;
-		snd_sof_ipc_msg_data(sdev, NULL, ipc4_msg->data_ptr, ipc4_msg->data_size);
+		err = snd_sof_ipc_msg_data(sdev, NULL, ipc4_msg->data_ptr, ipc4_msg->data_size);
+		if (err < 0) {
+			dev_err(sdev->dev, "failed to read IPC notification data: %d\n", err);
+			kfree(ipc4_msg->data_ptr);
+			ipc4_msg->data_ptr = NULL;
+			ipc4_msg->data_size = 0;
+			return;
+		}
 	}
 
 	sof_ipc4_log_header(sdev->dev, "ipc rx done ", ipc4_msg, true);
-- 
2.43.0



