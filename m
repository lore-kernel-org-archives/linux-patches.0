Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1D231E824;
	Sat, 12 Sep 2026 13:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221546; cv=none; b=AAPXDkt7lUreNMaEBsIv3Xb4bPjMQNcwNB78VCmbvZZYp1IoZ8XRCDeDJ8HCG78TDRC2pU0XylvlEpQZjLTjTsIRkLNSMbKrpnw43BS0DhFqyXMuIPsDDaXu4sfOly6IBil1E/nWBdKX6v5uxJf5ILv+GFKJIXIKZI19CqQK3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221546; c=relaxed/simple;
	bh=tUX+/av76y9BJhN2Ahp/nX4zyVvY1Qdy5rfE/oe2rew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0xiVpoP77uO9fqCfCUK7zZHVVGW9bAgmw+Ll+EOpZdnnsE1fSpN/hRzgcVjzSImalO3PJXS5bks8/QAQTbH6/sRVHPFfRpOaCxtGtpVyC+vKInXu6FosLma6wGtqmQvPNyOx+/Hi7MJR1w2plIsJhJ77/PN6gGqUSWhKUkuK2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSOzYAp8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSOzYAp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D801F000FF;
	Sat, 12 Sep 2026 13:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221544;
	bh=lLYON3Q4MsBiIzM3OvPUrqXGpw3XjUoP/O/nfjsVjc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSOzYAp8p639w1kfYNNiei2gMcBTdQFCVybe+15ZIkIZn5MNkauMbKm+HIf+9KOtD
	 HjVyvUbqqyYyDJL1rAC3PhZ5TLp5OS/c+0VoGYXr9gN3lGBSd2SsS+FoLDU3uXG72f
	 M+NshMgbzeJY01krrXndLjUdhgqYq/iWtEPvWTNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 0405/1424] clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk
Date: Sat, 12 Sep 2026 08:47:17 +0200
Message-ID: <20260912065616.355797698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


