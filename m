Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041541;
	b=RLTjGcgMLFRVWoydCCo4DX71qtGqQhU3t11etKhWge06BZuH43BtAeHQmkyEdF0DgqHA
	 csZDvrjR7Xkc3Hxint+w3UqlU9tL/bH0Ow2FEMybe4mcAGUrcZeI+nrK2khwaHof6DUm3
	 N979h6H/MNI8btvQNsd+FuS/gYbL5rwolC/iZEaYQobb/CpFTq123a/PTuqEqfExS1ORc
	 LEVBYGUZJcz2KNqv9wxVuw9Czes5uILfuS/VkqhYC3/UY9EDYxOiZw6pWZ4iq8nTtUPjS
	 A5QC+5KHwqSlZaQTdXsYPXuMT0a6fKFgBLARQ04za1t1NkVJwxtqbOoE0xPRPsEAQ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WpWxp+6VluAZRFn+aNSI5+EDDVvjs2YbB7mbFJvQHVQ=;
	b=VIC0SmgCPBPC4BTjqzN9xwm1kYLielmazgAjg6O/BufBNbPGUcxWNVuoOL5npC+fJBba
	 k+YrlLkAkVYVLjdMArzk2nP8DHgzom7OD1g6eYrqXlQyzPYu+89lV/ZiHFdeom7c0nIhR
	 Owm87+1LOWKluM9V+uf66DFliceaZIuqZLeBEGV0XiIQta21ivbMDtoSIEedhlGry/s0l
	 yWa/4//Y6kX9JbBkAd4G4BCk8T3U7iM3FKI3Bf7A5XmISJjzOae0DOlCt8ULXJT4Wb6Tu
	 aMqTFrID/tFpY+NyAWDfjkmOAAhvFb2uz0w67FeAYUKSgJSWqUcXJ6GyF/RK42ixAKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVxAUQtT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29429606A32F;
	Wed, 18 Nov 2026 22:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVxAUQtT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3442A1F000C4;
	Wed, 18 Nov 2026 22:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041540;
	bh=WpWxp+6VluAZRFn+aNSI5+EDDVvjs2YbB7mbFJvQHVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVxAUQtTQLMiwnybYKCxZji9+/EuvVzoYoN+yClto+Gfg8a+1xfqVNhNDliRI9epk
	 ySLTFII2Z97Xhr50eL6GfPzDkUZctnnJdO6I1r5/iAjYfYWR/0O+dP2yHV1DNZnVmv
	 kgh3BgEdn8xilTBBt0WEaK6qnr4nfnjweG4K17SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2809/3318] clk: qcom: rcg2: Clear force enable after rate failure
Date: Wed, 18 Nov 2026 15:57:11 +0100
Message-ID: <20261118150444.937322382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit d4e8c6b9aef42d06cf5755543ad10097b2217990 ]

Shared RCG rate changes assert force-enable before programming the new
configuration. If programming fails, the function returns without
clearing force-enable, leaving the root running while CCF can release
temporary parent and resource references.

Attempt to clear force-enable on the configuration error path before
returning the original programming error. This restores the same cleanup
performed after a successful configuration while preserving the primary
failure for callers.

Fixes: 7ef6f11887bd ("clk: qcom: Configure the RCGs to a safe source as needed")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-qc_clk_fixes-v1-3-5531cb00514b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 2b36df641d6b8..a87bb670a4c0d 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1016,8 +1016,10 @@ clk_rcg2_shared_force_enable_clear(struct clk_hw *hw, const struct freq_tbl *f)
 		return ret;
 
 	ret = clk_rcg2_configure(rcg, f);
-	if (ret)
+	if (ret) {
+		clk_rcg2_clear_force_enable(hw);
 		return ret;
+	}
 
 	return clk_rcg2_clear_force_enable(hw);
 }
-- 
2.53.0



