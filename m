Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B6739B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302613; cv=none; b=WCj1liTBq5yfIMFWPLHIacTnho2/+oXk+SSwP8e8zLVCQlWpt4MPsNYH6rX/z/8Uw5BO8zOLe80wywe+Q5V3PHpWJjZQ9zrgLCeqPjP7U+orO8G4SHyhQf/YqyN12xAP9SyWjDZ6UWwpQbYp3wwxezvf2tfBoDVE4PmQflT64RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302613; c=relaxed/simple;
	bh=n5y23WWqhEThf5yrD0ZaUkRk9OYK3rffUwCCHj8tmo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qM6HoxJX+OdWbIXUHZwsntdbm2g7JebK+/E+/cUv1CgMDFiR0A0rjO35Isggiryyy46wnX0xIPO9WgJC+9MyM8lgEDViMvh10vlK4DYjRAWGNB4aupwHn+kU66Lmiy7EoTY7SvjBlGR3681qc5CLrj1QBFqfBuiO0s/apQLTKAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8iXVqQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8iXVqQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F155C116D0;
	Sat, 28 Feb 2026 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302612;
	bh=n5y23WWqhEThf5yrD0ZaUkRk9OYK3rffUwCCHj8tmo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8iXVqQvHXW7vQ2vKvu2cFAW4HsOYQoptTkJxLZVNN/gUVtiLAvMnz+CkVt7P0TL3
	 sQERLSCTLzzb+auIJkggExQhPXjpqCd/wt4vVVjS7lLZuuVm7NUeZOS7LQiV6RjyKY
	 6uRW8OPsrkAvN5aZICdl+MClPzr+//FTsiAQgR+tydNi8YwIwMbfoWmeblm+qzBimn
	 DmVDPwGeNoZA5ZzpBgxU0tKkElxeC+aw2WPG6si2UeapDUfsH5XrZF/AfXBr2ghR34
	 pi/osuwGvumboj87TfIKpukkW8M/B9USbFf/ZY27aS6iafRvWeL0xlk5QoZoiplzLS
	 r0xlP6vCBQh4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/164] clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
Date: Sat, 28 Feb 2026 13:14:28 -0500
Message-ID: <20260228181505.1600663-129-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 9d11f993843db..0d7235e1fd9e4 100644
--- a/drivers/clk/qcom/gcc-msm8953.c
+++ b/drivers/clk/qcom/gcc-msm8953.c
@@ -3947,7 +3947,6 @@ static struct gdsc cpp_gdsc = {
 	.pd = {
 		.name = "cpp_gdsc",
 	},
-	.flags = ALWAYS_ON,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.51.0

