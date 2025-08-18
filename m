Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE723218C2;
	Mon, 18 Aug 2025 13:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522489; cv=none; b=tFHmEFZbi64MHKA8RddMWZudRXjAb6MFwMSzeYXBTZjLun+KN41au9BkP8vlBtKelglOUfMM4YkJISovs2gNSL6pZOws8ScOzxyBS7wP/T0cz6w8sz5mxcjkvReP7PJHN/oy8ejCDpoZEYQ0ufVtTtAeV2WhEKYh7Hjeg8Zkz9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522489; c=relaxed/simple;
	bh=bV5CIWjnumz8LJTiWznnuY6jA2lkRTuSTxxkE9fK2zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSSIx8bQszmXswSVz0OkkChfrPv2N4stcEVlv6fWpW9yxtGEkXmZp+UUcci8TZdYiqmFZxpvZenZfyWUkMwa/+rRM1Unfqm1mgOPkVVmGiy3jLgQ0TXCEluZau9j/f73i7CgVtZavL9t38PResrFozN0Ncoor5tmpOt91eXkhkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rf8o5cUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rf8o5cUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAE8C4CEEB;
	Mon, 18 Aug 2025 13:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522488;
	bh=bV5CIWjnumz8LJTiWznnuY6jA2lkRTuSTxxkE9fK2zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf8o5cURsYw66wIf4m1S7902xPH0wPNCs7HpvW4bSngCsHJsvLjkYQeedXoDdlHYr
	 sAG/MSjYIJLcOv6pdNXUMlotvcmQFpRn/bQ8nWy/fwWSvwL/ADHcW6U6Vx2nBSSw2a
	 1N5/X/2V7yZJ7hCfhVQiDjolWGHkbdPwH/E/6CuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/444] clk: qcom: ipq5018: keep XO clock always on
Date: Mon, 18 Aug 2025 14:45:14 +0200
Message-ID: <20250818124459.760395252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 693a723291d0634eaea24cff2f9d807f3223f204 ]

The XO clock must not be disabled to avoid the kernel trying to disable
the it. As such, keep the XO clock always on by flagging it as critical.

Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250516-ipq5018-cmn-pll-v4-1-389a6b30e504@outlook.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index 70f5dcb96700..24eb4c40da63 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -1371,7 +1371,7 @@ static struct clk_branch gcc_xo_clk = {
 				&gcc_xo_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
+			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.39.5



