Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49222479880;
	Sat, 12 Sep 2026 11:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213458; cv=none; b=UZmbl5uc8Qozjevt8jGI2dHaqA6GONqEQ+dckScwN+TRSQET/7zzNSiwEGgNR9TjRE39LwkhroNqrORFcXcJPFWlDSfEq+U45fbCnNLO1ln6TrUt+uIrdY3XLe56jou38BDWakOnLnHliJ+xCN2mRlx0UveOe3lwDymACA2cslE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213458; c=relaxed/simple;
	bh=IwaYWmLEiAk8gsyLaiRWKMc1DjBaUaL55YvJdHX2ZaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3/O37B5lr2XvSZpL36cmb2HINYdIAHA8KP2Q3s4UxuHsY3VUdw9KwJd58eJOvtw0hkpi1B9f6bmKMC8PlTR9Ftx7qM/YGu902JdXymzrERkYwuSpMYibrJI/V9k3nDDayt3bT5t8QJmXINazYHYvSM4l0TSzR1zQsJSzEkfIZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNrVNxzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNrVNxzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08B91F00893;
	Sat, 12 Sep 2026 11:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213455;
	bh=2OMTHiahkUESyjV1qbnYNuxZoLxD83fkAUg1kf4/v6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNrVNxzYNWYY0lX4fvn08/AWDKSsSvRTFGKZXHu80lySar3bJr4OpLJ5NurDGXxtY
	 TwCE0yddL60BKot9BVnZkQTYNb8pR+UwLFLWiazcuofivs0jwieuVOzTmwbqyv4EK/
	 gcOB6+awMrWZrTSwio2Vo2ZkWm9ZbLvRYgmQ3YEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 0124/1376] clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk
Date: Sat, 12 Sep 2026 08:42:30 +0200
Message-ID: <20260912065610.318940332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


