Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3CF1A01BF;
	Tue, 12 Aug 2025 18:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024332; cv=none; b=mvHqrGutKCoLKnz3CHrNNW+O6iD27owq01p7Qw90aABCMyxWJ708e7l1t4jwckxyEpIgjCNVePWNttDCZUooFEWZW6h5Kzi2hwKp8+KfgD7Ebq+nBGVN+00By1uRcG0hz2zcIFy0gSEuXsCS2ArFjVixTxFPs+OCZYF/8JAQamc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024332; c=relaxed/simple;
	bh=nrRYlKDvx86c760nMQFLmCQZMctpKac1C8VbEwzDfkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFBCmzpGRx/f+Wjocj8dfuQ/NgzUp1HyehaFeEC3sc0y+XLgHvrJzq6PLa2Ji5Yye8p8u1IvqnOtjGzKDOn+cGyWpGyl8vW84fUOhXctM0yvMXgn6uzlXhnPo/LVzy4b0nyjSnYxWVcWGDtLDwS3TBLkCIa4Q6G+Ry5olGcW1AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntQyua18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntQyua18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57601C4CEF0;
	Tue, 12 Aug 2025 18:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024331;
	bh=nrRYlKDvx86c760nMQFLmCQZMctpKac1C8VbEwzDfkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntQyua18oWMWLM5lJYltrONv7AStHQtBGWpCr3PXQtURwmU1MRzlO1YURillAoVg5
	 1w9ykO8T5NTlDZV5p4IStgnKS92l6HnM1toomOQfJQKLRN7yxMUjKokWX7inA3FQY9
	 j59wnjPjzesw6uCTdIwdArNGMzl0EpnWEv0xwh+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 340/627] clk: clk-axi-clkgen: fix fpfd_max frequency for zynq
Date: Tue, 12 Aug 2025 19:30:35 +0200
Message-ID: <20250812173432.219331581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit ce8a9096699500e2c5bca09dde27b16edda5f636 ]

The fpfd_max frequency should be set to 450 MHz instead of 300 MHz.
Well, it actually depends on the platform speed grade but we are being
conservative for ultrascale so let's be consistent. In a following
change we will set these limits at runtime.

Fixes: 0e646c52cf0e ("clk: Add axi-clkgen driver")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20250519-dev-axi-clkgen-limits-v6-1-bc4b3b61d1d4@analog.com
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-axi-clkgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index 934e53a96ddd..00bf799964c6 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -118,7 +118,7 @@ static const struct axi_clkgen_limits axi_clkgen_zynqmp_default_limits = {
 
 static const struct axi_clkgen_limits axi_clkgen_zynq_default_limits = {
 	.fpfd_min = 10000,
-	.fpfd_max = 300000,
+	.fpfd_max = 450000,
 	.fvco_min = 600000,
 	.fvco_max = 1200000,
 };
-- 
2.39.5



