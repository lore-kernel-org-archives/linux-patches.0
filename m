Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031680;
	b=nqw1CGf4CGTnhhzrJshWYheqj7b9/PCzcIMD5P7SmEyXSGXGzU2gGhyF2T022vuJ/bHZ
	 6KSZ4jFVeWPKZKPOTZsMiuHKGOtfgUbFgyuvKoiFs/HvLuywJZlLdNYZxGJkRaDKuwKAV
	 6Ux3rqre681GPhASfVaitaiZqFWjEPC6wzzz720k8NncPqwjyLVnP63XZPoVQJVF/XfmL
	 Bq3PF1FbNKwRr2A7/nBSmdtnqNiaf3cZh2XoOYYXm88NILAdK9DppQqWZf2JmQkwPMWrr
	 Xgy5EX0cD/+hTTEgI8CXh9PqCqyqfg+mKE/JAD1oHZvLDAKaPpD7QXLW8c2RecEf83w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RoBy18at/J+fAESv3KmrYkV/Lu5y4ZNJEtTt+vm+AME=;
	b=5hhtfMoChpnVVZsKcjKZdp1X73SHU1Ykhg358rcOxW/JLADxGDb8JT9J+xX8fstj+4d+
	 OmP/r+3e6YjY8MtO4Ictl10r9DPuzyF5SKRmUBTViWMzb6avfOmvL32MBxk/3OA+TsjzT
	 rFrz5EP1TQt9mMsTI3U6H5dJ5wi6GbmfCvjeVtNjhb+6NV4wHAgRLznn7KoJ+NXqW/4/u
	 RLKWKe/aeXpV0DSb+Q+IQLA+N1jlvkWZgf2dORXiYIvtJsWEfvNmZw5vjLqfq1Wz99c4d
	 BShPENvzgIHwox7Vg/hsSjbvoDlkYKxOCLgKlLkJBJjBy5cjbVdaT98TqqviWtRVmuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyjo3xGC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32C5606A32A;
	Wed, 18 Nov 2026 19:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyjo3xGC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5811E1F000C4;
	Wed, 18 Nov 2026 19:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031679;
	bh=RoBy18at/J+fAESv3KmrYkV/Lu5y4ZNJEtTt+vm+AME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyjo3xGCt6zy016/Qi0t1aUOSXa2escgZhGyuZtvF8CBOsECVnzCnbmRL3SIq1ZrE
	 ELtNCf9H9+JOBmVFCWwuoTjT4yByAj5f2dLFDClEHFplkLYRjnMsfRzpC4tzPsyDyR
	 ISnDjtIcBygf0V/Juz8QTqq/96VIgRNmvnIX083Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1141/1756] clk: qcom: rcg2: Clear force enable after rate failure
Date: Wed, 18 Nov 2026 15:54:28 +0100
Message-ID: <20261118150055.464445049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8c6be8963c2b9..0b4a638693ed5 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1182,8 +1182,10 @@ clk_rcg2_shared_force_enable_clear(struct clk_hw *hw, const struct freq_tbl *f)
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



