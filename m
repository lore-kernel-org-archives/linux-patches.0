Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A49214A08E;
	Thu,  5 Sep 2024 09:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529738; cv=none; b=OHlzeo+bpraP8qlYU9vshIntuJTZAATTosYK2YmN3m9h2tyztgiXuDYqum5CaxEjSUl/ANR4nizqo/Dx7D/DJriwrD+Gb1esaHCOdI5BUr5KXKXKReoBjXs2mF6wKnTx8HbG/DAKA/7gFbOusvecHNiUqVi6rteuhrwelqBHzlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529738; c=relaxed/simple;
	bh=7MATz7/tGhq9SgqlbhJyI05Xf3SgWChWLX4vrzGW9Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB2VbpE3BrVNEsdJgRFqeTHkvjfTsbeyG051Y3t9u7NgIgDJxXEBhvQFZsNkmwpxtGVchMtNsrbWuhqLg7HH4Fn1UH6n9L1PizV6AvTelfhpJOLjDOyH3dH+9OOW2aQrQzPuwrpPE2h2Zoc+wl2dgbVfgETbDvvZjs5aeLeUfUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XbEeVTN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XbEeVTN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1381C4CEC6;
	Thu,  5 Sep 2024 09:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529738;
	bh=7MATz7/tGhq9SgqlbhJyI05Xf3SgWChWLX4vrzGW9Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XbEeVTN1vNSyLzRwvCdLh2DsJGoX1zO6WUjNeXrWtCM6ALu1n0ZEXwwIXsOR8kdp
	 Fi5crEG5Kb5mDjUp1l6aPXw6dh36nJpz07vYfkHZP428t40DrgfBMutmMvgBRg4o/h
	 DvpdI7ZzbyErimDVlmbWiNZy3WLU8R9CdUIgc1PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 097/184] wifi: ath12k: initialize ret in ath12k_qmi_load_file_target_mem()
Date: Thu,  5 Sep 2024 11:40:10 +0200
Message-ID: <20240905093736.027081179@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5484112859a6..6d1ebbba17d9 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -2538,7 +2538,7 @@ static int ath12k_qmi_load_file_target_mem(struct ath12k_base *ab,
 	struct qmi_wlanfw_bdf_download_resp_msg_v01 resp = {};
 	struct qmi_txn txn;
 	const u8 *temp = data;
-	int ret;
+	int ret = 0;
 	u32 remaining = len;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-- 
2.43.0



