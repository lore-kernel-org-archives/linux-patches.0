Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47C2198A01;
	Thu,  5 Sep 2024 09:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529744; cv=none; b=XTqjXtz3jP+Omf+J8VOszuOAoWJBp4qepBDxutBtmaOC8Oe7IvCNbwV9VRXb6sZXdvwLd7JxNoNf+ORYcLr6rT6mlm27yfWbU9IthjpiD+2n201SDIA3VduWD9EnarQyNfEPSw8LDg9Okmtronhjjnw5e/y3L+G6glbu6XRwLSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529744; c=relaxed/simple;
	bh=P00HO1a5fA5HXZIOqfdALydF2Cr9/ND/sw+yG7AcEDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjr7f2E2iQAEYvekurg9iJFtU6ZVqb//jfAtDEhocQFf8UsfEQjjb0XeeNF0+Ga4SNe9kPhB+5Xc6Ij/qPy7Frwdla1kbwLrpgrW/hHHzX67sCHGpSfwOMsef8wemc3tbH14SJ+IugzMHzVK1aYjh5VwMySyuoGyS0Tq5FAMIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nOQBAPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nOQBAPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369E7C4CEC3;
	Thu,  5 Sep 2024 09:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529744;
	bh=P00HO1a5fA5HXZIOqfdALydF2Cr9/ND/sw+yG7AcEDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1nOQBAPDijVg3nUAxwL5E2dYoMpu6OShValDAY0V3zxONssHoWXnqDGb01XkYIVNx
	 rrty5E6XKpKqsMYk9N7mJ2j/piVeVzS5IBa8JyLAZxKVmmDxz/3GwTr36+ia34paAc
	 R5GqNJ9mHjdKyJI8EjGfcjvW1tNxZ+QtCDRImhbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 099/184] wifi: ath12k: initialize ret in ath12k_dp_rxdma_ring_sel_config_wcn7850()
Date: Thu,  5 Sep 2024 11:40:12 +0200
Message-ID: <20240905093736.104643553@linuxfoundation.org>
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

[ Upstream commit 3b9344740843d965e9e37fba30620b3b1c0afa4f ]

smatch flagged the following issue:

drivers/net/wireless/ath/ath12k/dp_rx.c:4065 ath12k_dp_rxdma_ring_sel_config_wcn7850() error: uninitialized symbol 'ret'.

In ath12k_dp_rxdma_ring_sel_config_wcn7850() if it were ever the case
that ab->hw_params->num_rxdma_per_pdev was 0 then 'ret' would be
uninitialized when it is returned. This should never be the case, but
to be safe and to quiet smatch, add an initializer to the declaration
of 'ret'.

No functional changes, compile tested only.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240504-ath12k_dp_rxdma_ring_sel_config_wcn7850-ret-v1-2-44d2843a2857@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 1d287ed25a94..3cdc4c51d6df 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -4058,7 +4058,7 @@ int ath12k_dp_rxdma_ring_sel_config_wcn7850(struct ath12k_base *ab)
 	struct ath12k_dp *dp = &ab->dp;
 	struct htt_rx_ring_tlv_filter tlv_filter = {0};
 	u32 ring_id;
-	int ret;
+	int ret = 0;
 	u32 hal_rx_desc_sz = ab->hal.hal_desc_sz;
 	int i;
 
-- 
2.43.0



