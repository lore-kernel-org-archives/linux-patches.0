Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC9D2D8396;
	Wed, 25 Feb 2026 06:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002652; cv=none; b=lgd1gxRTHDmn9oXoG5T19ZyUFIAMAMLzEn+G0afLZa8Ww3P8dXwekVROiTByFf+emskAQZcx73ZJ4kFjLtj1xt0RccNCFI71mLax2IZJ4Djvp4uoylO6JPsT0hcu29Qna68hUN355uZheF64lU55i++odL6JcXpMavX1Vuj+sZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002652; c=relaxed/simple;
	bh=UEXtA8qLa5wTIwOBSk3cRyT8tloBHTKnGNo1Z/llNsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiGEjHbzw+x2J/QDWljCXFp7av0fyf+XNwlSocRdz10B2pCQx574+Wjh3g3KLVvrc47y2CKjw/oGwRG4GjBl1MXl3z9lo7EmNOZOEatRTAxblTwJPMwYPevhs91+xs5+Kppis8dFKB04EAq9E2nqWqCOWLIF6GEdz9cNN0S8xWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McKR+Pt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McKR+Pt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C7CC116D0;
	Wed, 25 Feb 2026 06:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002652;
	bh=UEXtA8qLa5wTIwOBSk3cRyT8tloBHTKnGNo1Z/llNsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McKR+Pt2TS19CvS0qhcC+qyUgzKASLVHvAMC0lCcGqivG6MZcG0KiYXZE1fHSDMYw
	 HDNsitP/BqSSw07iLap0NuKxFdgmlYfTN36r5AZYkM6erk5f7khGMaruIoF9wjdMe1
	 7ZQVZiyiFAVungYdMqQPzvxNub9y7+z7KtqIi+2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 419/641] clk: qcom: gcc-ipq5018: flag sleep clock as critical
Date: Tue, 24 Feb 2026 17:22:25 -0800
Message-ID: <20260225012358.707485790@linuxfoundation.org>
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 04c4dc1f541135708d90a9b4632af51136f93ac3 ]

The sleep clock never be disabled. To avoid the kernel trying to disable
it and keep it always on, flag it as critical.

Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251128-ipq5018-sleep-clk-fix-v1-1-6f4b75ec336c@outlook.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index dcda2be8c1a51..64792cda06202 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1340,6 +1340,7 @@ static struct clk_branch gcc_sleep_clk_src = {
 			.name = "gcc_sleep_clk_src",
 			.parent_data = gcc_sleep_clk_data,
 			.num_parents = ARRAY_SIZE(gcc_sleep_clk_data),
+			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.51.0



