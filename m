Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E073156225;
	Thu,  5 Sep 2024 09:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530173; cv=none; b=YyVjpmmVuWIpaz3X7vt0gXYJAA2lZ5RcIsNsdQIKxAeiSsGzSpp6VYCOnrJIFfVHnR28adxiXPRZOJli8p6Y+boGUEORg3FTjpkObQmNQyd87k3sxe0/MBHiyW1NNcG6erwRsqr5hjOyiKl4bDI1JOZ97zMouL/ff5tdsfHQsy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530173; c=relaxed/simple;
	bh=tCx6qtPh3fzR/Cc3oIBXp4tnU3efceZubXnxPj5GuuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgKCmuVW1ODb6fzCKa59aEysf+OmArqTsxvAORJY73ShAnsNL8wI13dr/wIqRemnr7EI+X/XMesKu9DQrbKFmxrDZxg2bk/X8LxP536PocroVNMhbqjjWzngCZQCmfr6QCTn8RsKZ0j3m3pCiQKC5+tVbia7THvM8lHPqgNZLTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGHACqvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGHACqvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB87AC4CEC3;
	Thu,  5 Sep 2024 09:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530173;
	bh=tCx6qtPh3fzR/Cc3oIBXp4tnU3efceZubXnxPj5GuuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGHACqvIwG/S21fbjjNa9A8SXlL8yXl6A5Omcn1NDt0TgyMRmHQKm61OijdkDrnNQ
	 RZGWT8FIdCJuTICshrenmSMkX0C5qbKnia7jnHXID95KGDitJYlFl+GtTbREwSHnRf
	 2tV1Ai9b/DgsTgfrSH1T+cBHCjVMNTJefwI0XHrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/132] wifi: ath11k: initialize ret in ath11k_qmi_load_file_target_mem()
Date: Thu,  5 Sep 2024 11:41:04 +0200
Message-ID: <20240905093725.246647337@linuxfoundation.org>
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
index a831d9474e9e..83dc284392de 100644
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



