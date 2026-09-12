Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A0342885F;
	Sat, 12 Sep 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228396; cv=none; b=GY70I1iLCy3qclehXWIN6ZGMHpvgvQfL4dF1BkYLRq/EIWITdW8ay2jfWQOqaxVSP5oQFCrHpb0pXJZRzIMpcPfWfOebNR50csS1XGIQRCEPTMgVyLB4SP56F+1O/CksQQcL1c+0YPHZOjwgznkby3BOvc2IPRzOtKXkUQA4WcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228396; c=relaxed/simple;
	bh=NwJQziYRWfQF+9fVuBwkuzXXVpOJOp9I17cSP31fHBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAzeU5TpZuMB/1Ft8Vl09mMb83ZAxFcBztfF5OWrr29RL8KRubE7eKWD73a3QjGlpescQN/nxoFe/kyH8ly/tnPtfX4jlHx7DvaUqvzun2PYJbSXfwQq8O5sqK5F7g7hj9kDJ+PdsVLcqMgZau6P0AsTl4WatHVkvRVO7zzuKV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ru+mD6kC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ru+mD6kC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143D31F000FF;
	Sat, 12 Sep 2026 15:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228392;
	bh=ctfXJFJNxaRnpoBrd4YWGbXkayXP2tWGoz5Nk3aizzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ru+mD6kCgPHYg3L1k+PPTNvYnD01u3KMR4DYlipBpLsqcdGMO6aBB9Rnn3Y9/QOj0
	 0gcNzVtFoIyWAYZhAKNV4Mg3mQdRIp3dWGZqsWMBlwYRpqXlTXBqxdW4nENHx9ExIU
	 1g9lfooAd45P4Vb2MVAW9fOJ0wkIJXRVjy45McPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 0334/1191] clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk
Date: Sat, 12 Sep 2026 08:51:02 +0200
Message-ID: <20260912065555.729538078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit ca7e6cc30cde4f0cbeff2e205a84bedf431e9156 upstream.

gcc_apss_axi_clk specifies a halt_reg of 0x4601c, but this is already used
by gcc_apss_ahb_clk. The correct value according to the downstream driver
is 0x46020.

Cc: stable@vger.kernel.org
Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-4-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -1415,7 +1415,7 @@ static struct clk_branch gcc_apss_ahb_cl
 };
 
 static struct clk_branch gcc_apss_axi_clk = {
-	.halt_reg = 0x4601c,
+	.halt_reg = 0x46020,
 	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
 		.enable_reg = 0x45004,


