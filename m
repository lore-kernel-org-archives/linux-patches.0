Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE13811706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602B1C433C8;
	Mon, 11 Sep 2023 14:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443542;
	bh=p/ZZzTGgpFZd/30Nh/WAPmetnBWxKVefuf4JlfmQbWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gX0g0oRdY5kM4sXDFVgRUJ/c4iwaKakZpkg+EZigW6HzmSXkyp9AD26Dh/Tl9pYck
	 b3wYNbqw5rFtycKvqGMTiFg5RWxx6sig4iy7jBJkMV53QJD9EegCjAegn5mdC6yoKZ
	 iC1a0mifn+LSXnJ8HZZr/oyrQsMtaWYhNQak7QZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Tikhonov <danila@jiaxyga.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 414/737] clk: qcom: gcc-sm7150: Add CLK_OPS_PARENT_ENABLE to sdcc2 rcg
Date: Mon, 11 Sep 2023 15:44:33 +0200
Message-ID: <20230911134702.180574315@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Tikhonov <danila@jiaxyga.com>

[ Upstream commit ff19022b9112d6bbd7c117c83e944cb21b438e91 ]

Set .flags = CLK_OPS_PARENT_ENABLE to fix "gcc_sdcc2_apps_clk_src: rcg
didn't update its configuration" error.

Fixes: a808d58ddf29 ("clk: qcom: Add Global Clock Controller (GCC) driver for SM7150")
Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230630191944.20282-1-danila@jiaxyga.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm7150.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sm7150.c b/drivers/clk/qcom/gcc-sm7150.c
index 6b628178f62c4..6da87f0436d0c 100644
--- a/drivers/clk/qcom/gcc-sm7150.c
+++ b/drivers/clk/qcom/gcc-sm7150.c
@@ -739,6 +739,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_6,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_6),
 		.ops = &clk_rcg2_floor_ops,
+		.flags = CLK_OPS_PARENT_ENABLE,
 	},
 };
 
-- 
2.40.1



