Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2657F724;
	Wed,  9 Sep 2026 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963663; cv=none; b=Nln/peptNHA8jE/zRMXnjxyIMlBvNh7S7o94rzwJZMBQhyimkLmA6k5wz7+Uc/vrB9XevRzDsob9WdpLtK4ohxFlXy9xLnUhm4GeDFpkMi6QQ661/G5pBvcrsSJYqMKRm4jjWeBTaSOND8uuCEmyIUdezpgP0Epp/CT7XjF0TV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963663; c=relaxed/simple;
	bh=QhGm6tMCO14yUNtuZDSX1qJBQiH9HHvWoh6Guw1S/pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uezvj2WlBiYvpZym06HsoHwtsY5vsoNmZQN12zsPiD9uhVGM3pbhg3mE6pVkGDX8JIorqsfHZNuUAcmo4lbHyV3wS74uULDW7xqiHxllIQW/tOkU8zh/7Js/W+EvrNUjhC9Cz+SU/VBXyfNAV2hmqXNTlA79r53Xzl+PT7jXuXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goNXX4nO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goNXX4nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2A11F00A3A;
	Wed,  9 Sep 2026 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963661;
	bh=JJ1wbr5QWSm0H9tLGXLdvCY1/LH7ewQNqphVOwRjN5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goNXX4nOsFOtEmFMoDzkRL5Dtk8EIc2mZvsSzMp0ond4ZNZzTxtSZ6epUtwMB5OED
	 +HUCQOzZqlyNhIl2QFjTOjGXQWp1iyVHvKoiHkb+0+V4aWW8X0JGzzqrdV3dcZqfRB
	 4NMPqIjBRvnz6bKcBhD5f+K6QHX4cyWPFmEJs0pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 155/583] clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk
Date: Wed,  9 Sep 2026 15:37:20 +0200
Message-ID: <20260909134243.568511178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


