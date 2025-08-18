Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F2B340D9A;
	Mon, 18 Aug 2025 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525961; cv=none; b=GgtM2L97gJR2Ke92lUkTnIlbZKlChFEMwpu0ccbFobvGqCyPv4FK9Y8oLRApuFCr9fEuCa3Ugh9ygYlxywwfz2NpyXv2srt+Yu0qH8lm0g9eBXsjGWq0J6NCAhtPSxXR4EYxVJWyExPO0voJu6AFnDoJXiSHwFn8HqM4ZntKcj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525961; c=relaxed/simple;
	bh=8eeXLC7lINlWHSQJa9IrCnXAF2TwYnlLCVVljYV1bPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYU0vg5HXbdWrKAVkqa//BpSP70raxQD9GpWcHF3ZWSaXuWfCvjw+r3hd1TRS70769OVaIR+W65IpvMlX9lcFTc3jn99QLTaWhyEEjrO5smuFe6H7Alvm9I/ybQP1poTEZJqExdZ5dTPvfXgqV3bLxPJQzvNyvM49Wiltcacvbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmzNURd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmzNURd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EDBC4CEEB;
	Mon, 18 Aug 2025 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525961;
	bh=8eeXLC7lINlWHSQJa9IrCnXAF2TwYnlLCVVljYV1bPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmzNURd8I0/zi0oNIoYP/QJNdm1UnN4BZGxzKFT7ibBfYkU0+EKdWo6Cv2Hq4yWgc
	 tDnj+DZ2Q27RYXTsBZVB/0Xcc8BMxe5ZRXqeqNjfB/GADH76UE5Opo8bnMB24ejXTT
	 yg1n8gIUW/sotf96U2++u/KL/shQMqHSWj6WP6b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Moussalem <george.moussalem@outlook.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 374/570] clk: qcom: ipq5018: keep XO clock always on
Date: Mon, 18 Aug 2025 14:46:01 +0200
Message-ID: <20250818124520.256819570@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



