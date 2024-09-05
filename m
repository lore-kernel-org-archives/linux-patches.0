Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB507198822;
	Thu,  5 Sep 2024 09:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529741; cv=none; b=Xn9LPHm+Hgli5Nsor0uRHUKsEFl1bdHLV0qHZ4xIUDqqDyI1sTmz96++cNxkUHDmJditybYSybVYTh0AxPEdDuJMJZl1ns9lNei2WHjr6UHVoEFZT1N+y/V7NaeaH8Q0AYEQA1jCj9qxVuf+MCbdDuOYLRiWb0niRwCFlD58xc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529741; c=relaxed/simple;
	bh=IH1CJm1HNVQ5Rz6dc7+DuRyEgqjNqMO1+AT+7T6NUY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mxg0R/nRit9nTh4WunvQCK2GbNKwj8aqmUYJdPJE579ye75zKxa6BCLSfu+en0P5UUVEzR9gHoxlIjrlfHNAIRbQ6D2y2knjyciRfBBModmUN9oYNIotHKDRLzIWqeL/db/aPcL7dUDPhoVCNjx4ZGh1hwJMrf78vg98yEk5tqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGS0ON8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGS0ON8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11106C4CEC3;
	Thu,  5 Sep 2024 09:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529741;
	bh=IH1CJm1HNVQ5Rz6dc7+DuRyEgqjNqMO1+AT+7T6NUY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGS0ON8VOxpTGFWAhvZLRVtFMJDf8u5b0OV8JQXixa+s5alQHNimgSIWzUR/3OWw+
	 GNAvjXD8VXQsU0CiaUBI71Fu9wXkEbng87Q1O7jkpO34Gq9peArL9t1NHm089AlXnz
	 BnAvDhF49KH8qrkwVAWDyhmNwMYGh1I3Et1XE+2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 098/184] wifi: ath11k: initialize ret in ath11k_qmi_load_file_target_mem()
Date: Thu,  5 Sep 2024 11:40:11 +0200
Message-ID: <20240905093736.066695831@linuxfoundation.org>
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

[ Upstream commit 199f149e97dc7be80e5eed4b232529c1d1aa8055 ]

smatch flagged the following issue:

drivers/net/wireless/ath/ath11k/qmi.c:2401 ath11k_qmi_load_file_target_mem() error: uninitialized symbol 'ret'.

The reality is that 'ret' is initialized in every path through
ath11k_qmi_load_file_target_mem() except one, the case where the input
'len' is 0, and hence the "while (remaining)" loop is never entered.
But to make sure this case is also handled, add an initializer to the
declaration of 'ret'.

No functional changes, compile tested only.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240504-qmi_load_file_target_mem-v1-2-069fc44c45eb@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index d4a243b64f6c..aa160e6fe24f 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2293,7 +2293,7 @@ static int ath11k_qmi_load_file_target_mem(struct ath11k_base *ab,
 	struct qmi_txn txn;
 	const u8 *temp = data;
 	void __iomem *bdf_addr = NULL;
-	int ret;
+	int ret = 0;
 	u32 remaining = len;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-- 
2.43.0



