Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019993;
	b=alds8vw5cE7Wf73oLQ0NXg4/KMeTTteeGUGQYGEnTCo7asUNv0BUGtQXqD7gkTDvBGf3
	 V8Ae8jBoUw93pe1BujzHgder2hFwBYB60V3bda1obVf5taxMOP4yH8ANb12z0fJKuMbYm
	 7Wv5qXfQqKQipZ2mDRGI00jj6GUsTCiiQzTKycecp8ZJPaVc7wqjT1reNNjcDYrIp2IOM
	 M7QXOo7+M3E0QVNFyLkVuTSEL+hApWp1AxT1E2WrWZajOS0e5X1NGnKseiE8kp8HVfR0O
	 kq5iGIxzTjom2skFlmyzCn9tW21ZDD04ucgD3KjXxCRPQWlGUVcjsRpBvTjBwNsIPYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+zJCI4McDSP1fKVFyj0pqvsUkuTYChLvKsRsGMuGGU=;
	b=WGzwfAe1Q4UFW1lP3TkAyDyqE1qeO/BBsgVVZVQXRrOyzS1+pmqaoOPJMLBAJAeSpaDi
	 EfDNghVs/6s6oR9zeuGc9TSsllY4F//S2NX7bw1lPOgkhZicbZiDznuQQmioJL8ZZDAzf
	 2bJnA6UjGooVzi9S9UPq8D4agfXHErMAp8JOvTmnkL5f7oKzPYvcV4H2eez/tQX+aB6V+
	 rZF3mk9xzA6u72TZUT/MQtoCzQYzDBaSz1m9UJmllFOZTyz7MghwPERdLEUdFSXSDMHbo
	 l0mkX6QidOcE37mY0v22MAnH8cr6lwx1HV47cBKXth2RrUeGXINDhlcbl2ogr4lEczw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNgccWVY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E881606A32A;
	Wed, 18 Nov 2026 16:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNgccWVY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B471F000C5;
	Wed, 18 Nov 2026 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019993;
	bh=p+zJCI4McDSP1fKVFyj0pqvsUkuTYChLvKsRsGMuGGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNgccWVYnlpiX6GHTR9H4Uy0q9ChchnN21li/iB6emEZig7xbbWiSadNQo9J+ZzDp
	 Qb0i8TZ1JTLJIyZaoWFuZaWMNMYDddXg2vwQXmpdWqeeqm7SbZmBy8qXEbmX2O6eB8
	 RGyW1a3qdtzIHnrNxhEF8ZBqMob7QNArF4poHwvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1752/2651] clk: qcom: rcg2: Clear force enable after rate failure
Date: Wed, 18 Nov 2026 15:49:52 +0100
Message-ID: <20261118150350.573060778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 54d122e2e0d60..c44c51d860e1f 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1364,8 +1364,10 @@ clk_rcg2_shared_force_enable_clear(struct clk_hw *hw, const struct freq_tbl *f)
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



