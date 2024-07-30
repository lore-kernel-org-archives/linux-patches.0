Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DAA18A6DC;
	Tue, 30 Jul 2024 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359200; cv=none; b=Bwe7JxCqJdgYJLqJ1d+U2O3RCyc+oCVpHmMwsOzg3r/1pXKQz8bZBpM44OPaxvptnJzdzH8jhBT1OU55DSSWly7EUDdSaIUr9iUQ58XI9A5Fs21WB/xW9Fo834/uLXiQgYG2YddSe/SLRen0DcH/Y+ejz0ceI82RBjiYNNrnFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359200; c=relaxed/simple;
	bh=CVzI89euGw5Bg6BbQZHEHEIdFCVMjPkPNSBRVMib3zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIgMlptLtUcTgKKb4bNile0XuCy/tLjU9k96fbMeatVoA0lEZIHjW7vFgZ0sPHXs7DUua5BMp2NutJqbzC7MCChb/BXh5iMAZEbbyzP//cpazW7w5YmCJAAEcz0iLVaogJZ5kF++Jx0dORMTH1LdGbvJ11DysszQLKbZCLCQY/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmA/hJKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmA/hJKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DFFC4AF0A;
	Tue, 30 Jul 2024 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359200;
	bh=CVzI89euGw5Bg6BbQZHEHEIdFCVMjPkPNSBRVMib3zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmA/hJKYELv2u4xEuvXS0hzByHgAKQWDgtDKAtL5btG1IwFa3Uen4oPwmHNX/LxQb
	 87d3seYnfWmjzU7J/EkdhhnRD9ECeoDo/vRWK6Lsnleuyk0PP+QSP1HIrnH9LZvjod
	 MR7/ov0oo95XZb9LLUCYbGsq7IXNdXH1Re1kxMkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 450/809] clk: qcom: gcc-x1e80100: Set parent rate for USB3 sec and tert PHY pipe clks
Date: Tue, 30 Jul 2024 17:45:26 +0200
Message-ID: <20240730151742.480912901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 14539c88972bd984f1f04c9e601c1a2835d3e5d2 ]

Allow the USB3 second and third GCC PHY pipe clocks to propagate the
rate to the pipe clocks provided by the QMP combo PHYs. The first
instance is already doing that.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240530-x1e80100-clk-gcc-usb3-sec-tert-set-parent-rate-v1-1-7b2b04cad545@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 7b6c1eb6a61d4..a263f0c412f5a 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -5269,6 +5269,7 @@ static struct clk_branch gcc_usb3_sec_phy_pipe_clk = {
 				&gcc_usb3_sec_phy_pipe_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -5339,6 +5340,7 @@ static struct clk_branch gcc_usb3_tert_phy_pipe_clk = {
 				&gcc_usb3_tert_phy_pipe_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.43.0



