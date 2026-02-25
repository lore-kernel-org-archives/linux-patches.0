Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1DE2D4805;
	Wed, 25 Feb 2026 06:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002682; cv=none; b=fQyg1QDqeNKpgV54uq+peyoiC+CzLmK7utFF0HuZC/5lFgdVnNNkohR8h/jq2M3sfl0GPQzqEt47vF+a6C54fImqShYW/09GI0Rs1tkFtEKdWp4JlElAuC5encAJanHdHQkSESjDJ1T8rQ57jH8QIKrDfRZO4n0fhG2Sf3eMyRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002682; c=relaxed/simple;
	bh=wKN+na3p8YjSgAXDP5YIsZukRdlbR71wB5lJIqRXStM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxKAuQmWWhoEDTpyrfRC/OYiKkGe0Hs9Yv5G9TmGOsky+5cvIwIxqRX4Hcuywnl+zFDnimSAOuGhP1ZOBDSYdtZnaE0ypGmsRoiitA1upCz84kkhbFTK6HTeQapxT3HGNV34fxoeWifwz1dtJBtjg6iJSrEZzuu4YO1ZCRRO040=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w16gGhkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w16gGhkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AEBC19425;
	Wed, 25 Feb 2026 06:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002682;
	bh=wKN+na3p8YjSgAXDP5YIsZukRdlbR71wB5lJIqRXStM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w16gGhkNOidamBsJUVuMcH5+CJutAj0vq8d98xgdzi9MjX+er1JysV+DkrOhWfb5c
	 cX9rcseF5zxFoOLbhwPBCGKraaPGY+ukR1e9a45IE15Y7D1kDxXL21TPHoi3f5WnTC
	 kl6zRNjekfY9dvFJ33T2pyq+DoQvVYlXpCp127QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 418/641] clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
Date: Tue, 24 Feb 2026 17:22:24 -0800
Message-ID: <20260225012358.684941287@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit e4eb42f290aecac0ba355b1f8d7243be6de11f32 ]

cpp_gdsc should not be always on, ALWAYS_ON flag was set accidentally.

Fixes: 33cc27a47d3a ("clk: qcom: Add global clock controller driver for MSM8917")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251117-fix-gdsc-cpp-msm8917-msm8953-v1-2-db33adcff28a@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8917.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8917.c b/drivers/clk/qcom/gcc-msm8917.c
index 0a1aa623cd49a..9d1c5a9953e2c 100644
--- a/drivers/clk/qcom/gcc-msm8917.c
+++ b/drivers/clk/qcom/gcc-msm8917.c
@@ -3409,7 +3409,6 @@ static struct gdsc cpp_gdsc = {
 	.pd = {
 		.name = "cpp_gdsc",
 	},
-	.flags = ALWAYS_ON,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.51.0



