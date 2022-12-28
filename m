Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273F1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4798FC433EF;
	Wed, 28 Dec 2022 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245606;
	bh=IXzeQCXm8BAgFsTlT7kee4OYsEwHI8bN5Jhh+0BXAQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kh5vQHfwSSsFUPKdyuYC8LK7sdo139SlZudfDUvNzpX2id/AfRK/VqOIUzeKqcVjy
	 8CElzwXoNWnY1mBs3RHQs+chZLZkXoktVMUT4/X15WHYnWAqaHeF0Qni+H7ldgGS2m
	 fX6TCgR4Lld/Nc0V84azR9CaYxF8Iahkce3cfj+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Bhattacharjee <quic_rbhattac@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0922/1073] wifi: ath11k: Fix qmi_msg_handler data structure initialization
Date: Wed, 28 Dec 2022 15:41:50 +0100
Message-Id: <20221228144353.070643203@linuxfoundation.org>
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

From: Rahul Bhattacharjee <quic_rbhattac@quicinc.com>

[ Upstream commit ed3725e15a154ebebf44e0c34806c57525483f92 ]

qmi_msg_handler is required to be null terminated by QMI module.
There might be a case where a handler for a msg id is not present in the
handlers array which can lead to infinite loop while searching the handler
and therefore out of bound access in qmi_invoke_handler().
Hence update the initialization in qmi_msg_handler data structure.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Signed-off-by: Rahul Bhattacharjee <quic_rbhattac@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221021090126.28626-1-quic_rbhattac@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index e6ced8597e1d..539134a6e9d9 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3083,6 +3083,9 @@ static const struct qmi_msg_handler ath11k_qmi_msg_handlers[] = {
 			sizeof(struct qmi_wlfw_fw_init_done_ind_msg_v01),
 		.fn = ath11k_qmi_msg_fw_init_done_cb,
 	},
+
+	/* end of list */
+	{},
 };
 
 static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
-- 
2.35.1



