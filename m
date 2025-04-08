Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C4F27F4F3;
	Tue,  8 Apr 2025 12:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116551; cv=none; b=CYYe3+9SH7q8GV6WyBzqEs6gCLKMBY3wsOvOOKuArLP3z3Eau6ldpilnFw5ojqLgekgTIr66U/vtxE3UDhCjxpd9v4XCL3NrIdYvzGleZ20THA/aNrUwt5P+KvbcNlER3WwTeeTZBieWJy4Z7hWb/LbIYfUw1dgsOLsrQGKeqPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116551; c=relaxed/simple;
	bh=mN0Pkx0OFxDs7oa0NXJLtkEMa8LkBdkOt4rR8qd7bCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1RuM6fCYd+uc2dtv4KR+8+qXWLqQt7Ex6EnlkmYCXO8+YZlT2Aa0GoIkg8YI/yQzy0kw2wwMiHHabzZOEM7niWAjnzaFSimUhOV61bcSyaITr0N6+ThW7iSz/7MoEinfHcWJMWfFCnasn0maFIO5LJ1DCheKEhfhhlZVe93mjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkd8vJB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkd8vJB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED9CC4CEE7;
	Tue,  8 Apr 2025 12:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116551;
	bh=mN0Pkx0OFxDs7oa0NXJLtkEMa8LkBdkOt4rR8qd7bCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkd8vJB8nc9JIt6OO5Dc3u6k4NekA8w2FwebP7PnpL5b5EB+glH6jP8MPUp2oAIbS
	 fNt3znb4uiUSUCJPkT6ooZFemOjHMpTRXYd/NItga6ScM9iwfTZZ8QTEf6lP/eQwUY
	 Pa0LDcY0WRV48pe2CGzwl7uRo6Ws+b774HWcPFjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Geis <pgwipeout@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/423] clk: rockchip: rk3328: fix wrong clk_ref_usb3otg parent
Date: Tue,  8 Apr 2025 12:47:37 +0200
Message-ID: <20250408104848.777916157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Peter Geis <pgwipeout@gmail.com>

[ Upstream commit a9e60f1ffe1ca57d6af6a2573e2f950e76efbf5b ]

Correct the clk_ref_usb3otg parent to fix clock control for the usb3
controller on rk3328. Verified against the rk3328 trm, the rk3228h trm,
and the rk3328 usb3 phy clock map.

Fixes: fe3511ad8a1c ("clk: rockchip: add clock controller for rk3328")
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250115012628.1035928-2-pgwipeout@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3328.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3328.c b/drivers/clk/rockchip/clk-rk3328.c
index 3bb87b27b662d..cf60fcf2fa5cd 100644
--- a/drivers/clk/rockchip/clk-rk3328.c
+++ b/drivers/clk/rockchip/clk-rk3328.c
@@ -201,7 +201,7 @@ PNAME(mux_aclk_peri_pre_p)	= { "cpll_peri",
 				    "gpll_peri",
 				    "hdmiphy_peri" };
 PNAME(mux_ref_usb3otg_src_p)	= { "xin24m",
-				    "clk_usb3otg_ref" };
+				    "clk_ref_usb3otg_src" };
 PNAME(mux_xin24m_32k_p)		= { "xin24m",
 				    "clk_rtc32k" };
 PNAME(mux_mac2io_src_p)		= { "clk_mac2io_src",
-- 
2.39.5



