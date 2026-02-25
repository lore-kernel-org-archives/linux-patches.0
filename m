Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC092550D7;
	Wed, 25 Feb 2026 01:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983407; cv=none; b=oxcvd/7Qds7scmtizJz5YO7L9y91OuYsqnrW+in1ZJ+uucMLNUcmGz/dXnT8ocm5ogBR64LwtQm0iAmDz7PhWfCMwvSKzB+HACr4lzKrWkf+cKIkQoEmBxJl9aNM2tNRPZJ8CaRU2brJr7lIOhjMfGRJKnw1nWrAGwVbdh014QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983407; c=relaxed/simple;
	bh=jPaCXKybXyndeGSShZQX3RyKyLyVxEPKeGSOGjuCImA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FpLKqM+7h5Y0zDXX3Zu0tj6hhSDpdehNDj/22DdKn81IWgUNjC2SbRqBDzgRMOFD1cLB/scaVS5ZtOQlNXFOmPewQoXr5Mmvp+KYeoOBtA8jUvjZ/rB6XW3xZ8b0N0Cc9YQTsVzl1KMuv/YxQC4rQza5VadmERPS6QcFD4x9acI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLPyKxZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLPyKxZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F73C116D0;
	Wed, 25 Feb 2026 01:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983407;
	bh=jPaCXKybXyndeGSShZQX3RyKyLyVxEPKeGSOGjuCImA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLPyKxZppz1EbgSnrKM7lgM/aB5gIwUHQDfuOlKjMFdj9flOlLlOrNUd2XiY5evAI
	 5TLEkqKejqCmLra5SNMvP21EuaNdmQsW5D3/hobB/w+itMkmL/E/iIYgBkJvosCXCF
	 Czr6+3YKpC7txIdnG/JXfRWESVGZf9lCuOg57vF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 526/781] clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
Date: Tue, 24 Feb 2026 17:20:35 -0800
Message-ID: <20260225012412.699266580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 5f613e7034187179a9d088ff5fd02b1089d0cf20 ]

cpp_gdsc should not be always on, ALWAYS_ON flag was set accidentally.

Fixes: 9bb6cfc3c77e ("clk: qcom: Add Global Clock Controller driver for MSM8953")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251117-fix-gdsc-cpp-msm8917-msm8953-v1-1-db33adcff28a@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8953.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8953.c b/drivers/clk/qcom/gcc-msm8953.c
index 8f29ecc74c50b..8fe1d3e421440 100644
--- a/drivers/clk/qcom/gcc-msm8953.c
+++ b/drivers/clk/qcom/gcc-msm8953.c
@@ -3946,7 +3946,6 @@ static struct gdsc cpp_gdsc = {
 	.pd = {
 		.name = "cpp_gdsc",
 	},
-	.flags = ALWAYS_ON,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.51.0



