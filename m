Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049649;
	b=kfljgPtDTvHrTcceoXcJ1yQjlzPwA7r7ZXk7Pjwvey9p7d2Ht9SL/D7LWOb/joYu9Ptm
	 Pt6/OkdTqxVdTIlmtIAT/sl8PclWjcfVph+PoSIZSZJclktbX4pHpzvTBtR9xsKIG06yN
	 iwq4joso5cwbE2C9LvA8T9Yv6gwrmdm03egIavavjTcBTxAYx0HNJMLWA97SS0nZJS3Mj
	 2hRjFBKimVSsCy7eRn8H8x12n89lS0tyoCWXtq0LWDV9rYxybIwrCOnOb5j71MOjKwOFD
	 rsMbaGithgnK681EHitJK4lJfz1hpW+MyArOLo1+ecAwCr6KDVfJ7UOjaDbXBS6GGrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKWoIftLcmh6ilyyC3hrlwyzZBjajt+L2PqXkB/Utxk=;
	b=yVggi8WG5qp0mZuAaQqY6KQAXdcyxyrDel787Y4JALymAvRuW8KW3P+r3RrsgywEUTKo
	 YPTPlZBIWq1o/Tzq9KsZCWTXI9U0g6HqV+a8NziSfRLEl3OQaQIl5YxyDJEqrZ4wHBssJ
	 Yu3nwS8Yto7rvtpBsZenYfXEYDu4ltReofpECxmfO2OYFMGYheISM8zapNRtAtncVjLBB
	 /yAmWb7ntBNIkZFcgYmi/ujAvXh5Zc0DjkmUpFO0QJsah3h9ZgPujUE6Zh8FGtKtgnbcc
	 BGANH/OxeXFaBYaJt865HIsuI8CwlB/u6Wmqa+ODxmPHHahkdx1344DfqtyCZZ9SnjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=abQlbODO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B27606A31C;
	Thu, 19 Nov 2026 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=abQlbODO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72B91F000C4;
	Thu, 19 Nov 2026 00:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049649;
	bh=EKWoIftLcmh6ilyyC3hrlwyzZBjajt+L2PqXkB/Utxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abQlbODOdsUjjD8eXPafDHmLa5g7WekXEEgs1vX1nNUpEWvfrvIyZW6SECQYSEaEH
	 Z7RtwMk4GS47/PloJA9V7Ygvwi4d8FKAO4fb5iS26mt5j8i/SBv3FULAXnXyFKZpdb
	 ZKQYR1r4wRTEhc8KNNGV07xm11mvuUfQEEmdjjmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2427/2857] clk: qcom: rcg2: Clear force enable after rate failure
Date: Wed, 18 Nov 2026 15:57:41 +0100
Message-ID: <20261118150328.945386526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b74f5e65265b1..dd41f3e3ea913 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1014,8 +1014,10 @@ clk_rcg2_shared_force_enable_clear(struct clk_hw *hw, const struct freq_tbl *f)
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



