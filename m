Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CF61F55FA;
	Tue, 26 Aug 2025 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213124; cv=none; b=B+ruTQ1knTwQbz1OGO39iX49iXh6FFmgwr3J57XMZRv0Qe44RDlJxpGqs6RIdhQGEvAnR1cntQjDTUs72GySypOyLKrfNPWyyggjkDAqBSG8HCjyprdaZR+7puNCw0Zj+TlMsaQVowllNLpNwLd0Se0TDYLsHU/xeqW5oOhM9NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213124; c=relaxed/simple;
	bh=tbiWIhYQlp+UzAeobvV5mGK+RMhXkYw6+UpRktlziA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VW41tlPh2NReB77+fBaoi94ZPkIoxu/PjSELXNRBe7eNBhz4menertKVNjqj3tXI6O6tfk9/10IMFoCKq4rf3ms/pFvgEJTD7Ps3sPBKf8flu5z6uKUatAHBxIcMbPzGS/QLNwtVZjViNC89/w1W11FsLdc8eNMMpWAkmCwecxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icnrbs1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icnrbs1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25903C4CEF1;
	Tue, 26 Aug 2025 12:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213124;
	bh=tbiWIhYQlp+UzAeobvV5mGK+RMhXkYw6+UpRktlziA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icnrbs1KPe1fV35XNKJfOGcUU87i1t/RPItatEhMETDUFdoBjVer14pbO4Dxvx88J
	 VCzzO02IMQ5UWJ+Jor7cOPbDiI0kXmlY/TKTvhqdW3F571Mo4WOVG/ZeoXMgsUPp7H
	 DcXaaupGAdLV1jG0/bcPGvAxQzdIEkV/RsYSnqHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/587] clk: qcom: ipq5018: keep XO clock always on
Date: Tue, 26 Aug 2025 13:06:20 +0200
Message-ID: <20250826110958.811537799@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 693a723291d0634eaea24cff2f9d807f3223f204 ]

The XO clock must not be disabled to avoid the kernel trying to disable
the it. As such, keep the XO clock always on by flagging it as critical.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250516-ipq5018-cmn-pll-v4-1-389a6b30e504@outlook.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index 3136ba1c2a59..915e84db3c97 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1370,7 +1370,7 @@ static struct clk_branch gcc_xo_clk = {
 				&gcc_xo_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
+			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.39.5



