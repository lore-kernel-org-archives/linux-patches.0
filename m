Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553D22C17A0;
	Wed, 25 Feb 2026 06:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002645; cv=none; b=DZJAXg5g/x+sWf5AjM3BZqqSIc3JnsZdTSxvUADmYBBUYqlXJDiTFVu9Ki2JDrMkdaiaT5naQqVVg+Xxwr+gET4btBa38a0A+pU7jzuIOndBMKAJPIUeUuk3LfrO+ULLh8q74BYtkIeLd/m3QUv1a2fM3X9ByvVT1/DE+eX8v4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002645; c=relaxed/simple;
	bh=2nCQEctCcRGgAh6BVZOXKzE2JBPpcFyswT1TTS4Qvyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gq21+opCVEgvg4rP0uKx0uw63v4xfF0eYIDezZh8pTAVkk4jlAsclepFXXxTTvha1IkCE/r3a+3yRlgSBKm3thzmJcmNNlH/g9gzGFhyw9pwKN1tiWjdah7QWI/pS1YsidPuDRHrTVcslyVua+cCbVproIiXX5SBCpTjBWRnpj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3YJk0qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3YJk0qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB59C116D0;
	Wed, 25 Feb 2026 06:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002645;
	bh=2nCQEctCcRGgAh6BVZOXKzE2JBPpcFyswT1TTS4Qvyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3YJk0qfrp9EhtVVR4gMJNK8zchckaXBcsrIZ7UAvMrndg15S30Z3VE8XJceQkqcM
	 JVGgMR8IdtGYHYOc/ZLjX/QWSuuyL1lLRv9BaepABHDnhGodI89Tvdhekw32OCh7+V
	 fkgYR+6lT3B/4drx/x4+Ixzy9X8fzbStDOTi8ys0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 413/641] clk: qcom: gcc-milos: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:22:19 -0800
Message-ID: <20260225012358.567175115@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 08da8d7dabb161cea14c6d3ad9b5037aaf6d4b7e ]

Use shared_floor_ops for the SDCC RCGs to avoid any overclocking
issues in SDCC usecases.

Fixes: 88174d5d9422 ("clk: qcom: Add Global Clock controller (GCC) driver for Milos")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-5-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-milos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-milos.c b/drivers/clk/qcom/gcc-milos.c
index c9d61b05bafa1..81fa09ec55d7f 100644
--- a/drivers/clk/qcom/gcc-milos.c
+++ b/drivers/clk/qcom/gcc-milos.c
@@ -917,7 +917,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -938,7 +938,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.name = "gcc_sdcc1_ice_core_clk_src",
 		.parent_data = gcc_parent_data_10,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_10),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -962,7 +962,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_11,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_11),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



