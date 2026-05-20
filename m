Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA0039C00B;
	Wed, 20 May 2026 16:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296277; cv=none; b=QPKE8EvrOoD/W0pn24udKbwXYfAOVwjajMz+s3KIz6+2G9Q8vPVFi7w9L/lr2mxsQZs4n5BSyX9t1hfMX5QIO323AnfLcxYKQLbrEk3JCMBy0GhupRpDZmx3BL+q7Dpv7y1MOOBkvItx0PBErN+gVaAKTEeLlzjDu1tVlf7EWHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296277; c=relaxed/simple;
	bh=vREqp6ovQxr9ixYdC0HjiQGV4Xhtx9iJ7g12ajEGncI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5Crvdw/eCr/cU9sJ3IbYGJQTezFnkIw/Ao0t4IpiABnNtC9v2Vi/9UYKiCOqL6aNh8YGExQHFUpa8F/bfRd24BPaG0+48dH42FNlfXVriFNqDTi0U9miTcHiAOnWQNeHnvF25XhP+1kmknLSkcUrcdTzdKXEmo8FVN7EZmjc/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHdLpWs2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHdLpWs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCD11F000E9;
	Wed, 20 May 2026 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296276;
	bh=3kBdsDTg7rNiIYHtZzxI1PQyolnz5ZtMJg0Y1lXU4tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHdLpWs2EUvH4F/fBejrdWATsUwYqF6pUG8L3RwzH6jLzNwQwA297N7GHDiFzDe1Z
	 gYaXssBbjb64qMoGGDqNX5IvtuxIq/vM7KD6/WxBknXc9/grOSyNqtcDtdOX9Oh8Nz
	 Opsi5SRpdr5n7foEsMd3j1BLmrdeEH/gNvpImKfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0697/1146] clk: qcom: dispcc-glymur: use RCG2 ops for DPTX1 AUX clock source
Date: Wed, 20 May 2026 18:15:47 +0200
Message-ID: <20260520162203.964599725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e7c8eb1646db5d967d77ee67793dd95a2c5ff451 ]

The clk_dp_ops are supposed to be used for DP-related clocks with a
proper MND divier. Use shared RCG2 ops for dptx1_aux_clk_src, the same
as all other DPTX AUX clocks in this driver.

Fixes: b4d15211c408 ("clk: qcom: dispcc-glymur: Add support for Display Clock Controller")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260112-dp-aux-clks-v1-1-456b0c11b069@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-glymur.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-glymur.c b/drivers/clk/qcom/dispcc-glymur.c
index 5203fa6383f6a..f352165bf56fc 100644
--- a/drivers/clk/qcom/dispcc-glymur.c
+++ b/drivers/clk/qcom/dispcc-glymur.c
@@ -417,7 +417,7 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_aux_clk_src = {
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_dp_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.53.0



