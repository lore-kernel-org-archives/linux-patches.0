Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728CE248881;
	Wed, 25 Feb 2026 01:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983397; cv=none; b=pGh4LQnu/LyiYHOm3edoLIR3OZaOLhpglKhera0O4oaBQ6q0yX8TkVJNsbyI9yRvXniBJFbDTE6KfDNGVRj/uN4FZ+FSMk6uXh+t7bqATltXqk+AcpmgLLKjT8s6O8OvK1gShudodlRQqkd3W2rWX8ruqavy+HNkYpB7n66h3n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983397; c=relaxed/simple;
	bh=xk2Ovicp9LHMWZKfE8kI64+bxhKEcd6aClL+hOAJq2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti0tURYOuW3i6j062Bn1hxuY1DtuHHbSK5aVkp/cHIUzEQkxFJafEfEvBNFD/InsgR0b9CbYaV/QaLxyf7BmDdqOVuusWqO/6rSJ27CaxmldL0YJBq9WTquRSqC1s2RrxzZvmDdduy48xvT//9HSSNfRU1Wq60mfj2aXS/sryho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwaCvrmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwaCvrmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED778C116D0;
	Wed, 25 Feb 2026 01:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983397;
	bh=xk2Ovicp9LHMWZKfE8kI64+bxhKEcd6aClL+hOAJq2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwaCvrmSYgFO/BsWrhPr1RxhEUZh1ArQApFNs5CzJKs24jk5dPXG79lPQxWCxNFto
	 A7DOa2JzylNvGTn1kG8TL/mOwCfTiHq+S+t+PW9hvnNsS7g+wBWFB1ZJIDOh/IR2v8
	 vkUPnZJahA6PMDBcN9wtpzjFXTPPdukR4eeFnfQE=
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
Subject: [PATCH 6.19 519/781] clk: qcom: gcc-sm8750: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:20:28 -0800
Message-ID: <20260225012412.532222600@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit a7231d4aa084e485394f9214ec9bcb2d1f65dde9 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: 3267c774f3ff ("clk: qcom: Add support for GCC on SM8750")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-2-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8750.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8750.c b/drivers/clk/qcom/gcc-sm8750.c
index def86b71a3da5..db81569dd4b17 100644
--- a/drivers/clk/qcom/gcc-sm8750.c
+++ b/drivers/clk/qcom/gcc-sm8750.c
@@ -1030,7 +1030,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_8,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_8),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1052,7 +1052,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



