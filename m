Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3DE491597;
	Sat, 12 Sep 2026 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237565; cv=none; b=P36lNTr58vec5eEe0RbXu2ruzkBjgCiw4y8XwNF8d0sUL9MIA6QFlAB19GUJgTpI5m4+lx6eU0X2LycLWCEXj2c8+/HFM6xuZyBtJ12QXUt6RFGjpt+KAYJA+i1HO4M4uTlgH5rS/zDodJIMGeMCnemTpv+nOY1knjv3mbsV16c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237565; c=relaxed/simple;
	bh=TZrouG78nY0zybcKGZIuX+mHVwuIBero2FcOVS3rkcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQSFF/eVr6AuKaWdimsts/Lkvvde55TRerMk6KsV5bn9f3/wYebm171GuSilnZmHXj9Jt/x2Wohx5kDTGkZSL+fIR6W25ET7yawJfII9ou7nHzSt28eyY4rodgSXxqzCVtnmbs1CKXEXrgoxUh5pQ4OE+EwOdjXD0Faq1DGSxqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6ynCnrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6ynCnrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56651F000FF;
	Sat, 12 Sep 2026 18:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237559;
	bh=HAorpNrcqgPCkOcSc82wwDDh7Snu+f+sGcspNuRcSSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6ynCnrHNf37mXMhK7zeGe2rvbInGrJ0gd0Y6cX4tUV3jeMNQ/c+I4oitAotUy2gn
	 3EO+rHez9nj3rqegM7irRmRWEgpmNiwWSX8R4CuQ/YAwsFS15dBkt1ecn9hlXQ301W
	 6eN1i6IemvxFU78U0mssR2oUjCD56w5Bcam0z6SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 283/935] clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk
Date: Sat, 12 Sep 2026 08:55:13 +0200
Message-ID: <20260912065533.307601944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


