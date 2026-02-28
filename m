Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07526333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301883; cv=none; b=kyrI10AKuUseYqbIBtksaJ47LFKFCU/WOR6WVupLfdT8fhvPE0gEO2SDhkHc3p1Gp6I/UAEhlBaYcsq2o376TJbuK8eVYbxWEfiKt8P+qCKYlYm979oJ/bxP5xoyMEZOM1uvXzFUIMEmq7bRjr0OEGARKvlP/6xNH6nYZTyFTdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301883; c=relaxed/simple;
	bh=jmzlbyX50dzOBXESCK5YQGS0tVtfPX4rGSRQk7bH3x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ea9CQGByPUikHTrIS95Zec0Zo6u3U6T3ghA+haktfQ54hsWCb64mnIPDDbYam7O+bWlpP7pyiKg9gh2wmsajy0H97OwbrUa2ilM2xQWFSpcW0TW0P4SZ5GWKOfJEbAvQnfdECr4iUU1ihgpdgG6nXJzlE4LXm7m88V/zUlD7mKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gcT0aEfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gcT0aEfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54668C2BC87;
	Sat, 28 Feb 2026 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301882;
	bh=jmzlbyX50dzOBXESCK5YQGS0tVtfPX4rGSRQk7bH3x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcT0aEfra0XJOhR0lwLdoOqkdF/RjaXosK18dfIDLLqUbO33wtHcF6xzkugd02ikB
	 WHA6aGXm0U4ge11LKMp9Xq6ZQKH2NBXvGOtVAe8cR0UGrfQh/1ZrE2/12xCvaLoY0f
	 NmVg060GnyIxroeWxpVUfTZ0rrJP3gxcLORRMlDyywrn2iSIse8NDBgSSQyNhAED9q
	 rNajZEG881Auho3CcPz5QlzMrfpTDOLKK87H8mq+/I1y1P0TKlKyED85tx2WTUCk0V
	 7Jzu4JUwMegedoQgJbuVXTRLY/6oT3M/Wyl4SfCR4OLf/yKsrp3U7mYtwfhC7AldK/
	 1qUdDBJ69CrDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/385] clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
Date: Sat, 28 Feb 2026 12:58:50 -0500
Message-ID: <20260228180011.1568201-308-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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

