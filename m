Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C84192D73;
	Thu,  5 Sep 2024 09:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530170; cv=none; b=sN/cExBj1V7jKubxfA068imzr8duyCI4ECunw9B+Lfd1nw01RIMjngb1wsC9am3J587UaN5eCU9YTpr2yuUREwGyiiqLvYkkVChsuMYAplTG4dp6rVtlaMo10lK9J/QT5pWHn9baMzSpExv/5wka1750X49fIJ9nmSG9iFTilo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530170; c=relaxed/simple;
	bh=sIPPMlh/xcte5P4/AfW6OPpXo2pNbvEDomxNuRZv5uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+LpK3MfNR1Ipu1RJEhJ3Lv39tiMeGbV7qZUcAVZgnsFIfaDAh6uzt572/8i82Cl8SUcBdQmmLnVxdGq/3kq2+p4wdCl9R2OILSmyj1EIiVIG5dvg+es+bxY7njQqWyNzSlXhMU/Qe+pHfj1hFGNsDTsUK8k7mj0kDunBB54W+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0szsettg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0szsettg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE3DC4CEC3;
	Thu,  5 Sep 2024 09:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530170;
	bh=sIPPMlh/xcte5P4/AfW6OPpXo2pNbvEDomxNuRZv5uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0szsettg/cj7oSg0Cx5EDum2PAqxeF0nLilNPwgJddKKIBAIAsUudE4sJcIRQ2N8u
	 rQ6uQETB1/T0aQYvU8NMwZbQj0eA8k0UqtHCVR7zc2Zl3DA6v4socISbiRLXasVmMM
	 OwPEK5UBhZW70BgKCJps/LJos1oBVgwcEwx1XPcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/132] wifi: ath12k: initialize ret in ath12k_qmi_load_file_target_mem()
Date: Thu,  5 Sep 2024 11:41:03 +0200
Message-ID: <20240905093725.207518582@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit bb0b0a6b96e6de854cb1e349e17bd0e8bf421a59 ]

smatch flagged the following issue:

drivers/net/wireless/ath/ath12k/qmi.c:2619 ath12k_qmi_load_file_target_mem() error: uninitialized symbol 'ret'.

The reality is that 'ret' is initialized in every path through
ath12k_qmi_load_file_target_mem() except one, the case where the input
'len' is 0, and hence the "while (remaining)" loop is never entered.
But to make sure this case is also handled, add an initializer to the
declaration of 'ret'.

No functional changes, compile tested only.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240504-qmi_load_file_target_mem-v1-1-069fc44c45eb@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index f1379a5e60cd..c49f585cc396 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2312,7 +2312,7 @@ static int ath12k_qmi_load_file_target_mem(struct ath12k_base *ab,
 	struct qmi_wlanfw_bdf_download_resp_msg_v01 resp;
 	struct qmi_txn txn = {};
 	const u8 *temp = data;
-	int ret;
+	int ret = 0;
 	u32 remaining = len;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-- 
2.43.0



