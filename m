Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937EE1494DB;
	Thu,  5 Sep 2024 10:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530638; cv=none; b=Lf3wavipcsXg2m7ry8PUq5sUAS2ucgdpB2m8MpJjXvZyG/wv3cU/fq9rTqG8AvPonmq1vTXJF/zHSIEBFng1TYbUlhUx8iw2acsR1JhucsnrGE5i8xeeHtTO6Oi6BaWJQ+qKu6NQjTVwrYkKYDaSNg6gKZ5g+fr6L/15zWMCQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530638; c=relaxed/simple;
	bh=/KOMrjDkkukpJvTj7YBtiOeGX9K3DQZoQHdFK4FIsFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUyvTMrUnB0zBq8WVIrASL9ucRWko191MBh3AyigI7uN0Wk0EXhECxCm+WvWBb/gX0jApZI5EItmuML8ltNuALGGU2L+y7Dr9SYHnp0cWN5h6MbPoXwp8EvnKSPV28FLgyA23vuU2jS6FAdQd6X9YEv83S7e7hoRZf/rSFP7iaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKcUcT1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKcUcT1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B70BC4CEC3;
	Thu,  5 Sep 2024 10:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530638;
	bh=/KOMrjDkkukpJvTj7YBtiOeGX9K3DQZoQHdFK4FIsFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKcUcT1/TTVDxKlVsTpqR/edV+SZNlROL0sqmBWulUyF8I05v7sRlQrLDRot6cQEv
	 Jcp5qbzPZHR/4YdbuVUEDWU06RfH8wkGmeEz1GdDap9/SECnpPS1pwlXpo36Xcvgrd
	 aI1oSM6LFuPWmh+h/GBaX/azyWiMVKPYgjCEuSuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/101] wifi: ath11k: initialize ret in ath11k_qmi_load_file_target_mem()
Date: Thu,  5 Sep 2024 11:41:31 +0200
Message-ID: <20240905093718.447051497@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 01b02c03fa89..764cd320c6c1 100644
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



