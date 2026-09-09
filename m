Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761F566C60;
	Wed,  9 Sep 2026 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962339; cv=none; b=DS3nNbgDW5sY0/f1JvgSDJ5j/wbe0r9sPyod+CWyyvxzOaNvcV9xGlMCv1+MDG8P4PRXlud4xiXa+Gsr/IgxwMhDnTjywJJQKXiFdlUPCgt++sINgIP/ws8PoJjPAWMuCNSNaXVjrCiUy+c29d+6DlDJODzOEFq6Sitah9RkXpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962339; c=relaxed/simple;
	bh=MHnwGvNfnC/iLYc9uGCu5iG9jtVhtXUN768VqlarwuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m29/m0hFPbtsMj3/0jPp7cY3BWZPRVWVjhpW9bDUDNEpZYgX8AZ63iDj+rtc5nK8d/ij/51sM2/aX5oGGUegQaEDnK3KnCCB1QaH3NkPIogxoXUys20FR/eNBWKOE6g9x2pP5bt2Lq+eauo2O5nZL50VUfao4TJGJ98ubVYSFMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h96Xk792; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h96Xk792"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B3A1F00A3A;
	Wed,  9 Sep 2026 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962338;
	bh=Pwp5OGAvyLRGxu9va5HE5YT+uZMS3SNaDtIHPV5f6CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h96Xk792CkV44jSMOHkp7vmo0CJq2RH2NrCf5UTu0ArwGQDSNgDsQKtzPYl6qkwpr
	 fH50bONy5hM+1qyXtetCPsoJG6PLwd9ZRyqhP7+2PZHqfWpISeiw+lxNPUrZbvXSu2
	 qBoT5J2ijom/Bu1DOYeqn8HPrDE6UZ0V97nljZ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 217/556] clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk
Date: Wed,  9 Sep 2026 15:38:17 +0200
Message-ID: <20260909134238.034786925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1414,7 +1414,7 @@ static struct clk_branch gcc_apss_ahb_cl
 };
 
 static struct clk_branch gcc_apss_axi_clk = {
-	.halt_reg = 0x4601c,
+	.halt_reg = 0x46020,
 	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
 		.enable_reg = 0x45004,


