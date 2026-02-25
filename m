Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113502C17A0;
	Wed, 25 Feb 2026 06:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002646; cv=none; b=Z3CITIdAyVPhDOhPledbngmQcPsbUMllZ/2vn/1V36HiTuzLXS/dGAvwGarUVoke8w0iN0miS8gv+uBBrwUc8pGm7tgoUETemmlv2+41HTnBvx4ddXwMsjc0i550aaabeC0ru4Uhbp3vpmA9aEr/PmTb8bMiPkF6PftMnCDUaJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002646; c=relaxed/simple;
	bh=OZHklfR8Kwz4AlHPoEPcQf9cCESdcKXbkiZPMkzbCGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9RBIfvKBMZXEp5z/1qdask9eSYdX1BRroSM+dwYG4z2fncSnm3yWBoG9mJDJgums1+EGCjnI3LDlraukhSEqct9EQtL/+FZvMGfXqnsmcEQwJEkf7c/eBunRdrI84KnC3E+Ct27HqUe1kCY/TyJhmEnpu5pFOzbzoThBxgCLLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0daf4CAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0daf4CAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF3AC116D0;
	Wed, 25 Feb 2026 06:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002646;
	bh=OZHklfR8Kwz4AlHPoEPcQf9cCESdcKXbkiZPMkzbCGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0daf4CAebvU+lUVIDHZGoUyjaDAH2Jn0GAPjt10z2KlUVwubbWh9bYNBIJEtn61t0
	 2yMZ+QHfIHeO3P4OxyG4mgYm8/1v2Kbys4s0mPJCzf8OrozJRPwjOJQdYdIhe2himi
	 4aP6CC7IeDQYHYQy7iOsz9J9imnEz0FzJZeeX3A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 414/641] clk: qcom: gcc-x1e80100: Update the SDCC RCGs to use shared_floor_ops
Date: Tue, 24 Feb 2026 17:22:20 -0800
Message-ID: <20260225012358.590820247@linuxfoundation.org>
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

[ Upstream commit a468047c4e1c56783204a3ac551b843b4277c8fc ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-6-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 301fc9fc32d8e..ef8d2df188d3b 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -1123,7 +1123,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1145,7 +1145,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



