Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC113276026;
	Tue,  8 Apr 2025 12:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115685; cv=none; b=ammjXxzVx2oyGWcNisupqKW0rV+D+U1bX5WgBuLZn2HbWwhEYu8skiypPBeJQ99AnNRrCXaNY58CyHHkM0bEajQvx2alIXwlnp46D7pywgJYrpUUig3/FwKwHO3PnIomdbljqB7MvNLW/ZkiqK4hR7Nh4ydPQXvPtAfnTPfUKkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115685; c=relaxed/simple;
	bh=M8T0pW4NGmBE/5LVCKIrGEylN4UkNIvu4f9QnAXNyXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxo3XvJqj32nRdKpl9Ig24JwovwoUgY83JneBvGQVr0pMEkmIDvYdeapedM8QGK6Kl+DukGyxwzrKjEWHCP8T7E5CmT+xeSQwT30MQrj7znQYJfALWGQcSrcu1F2ypy5FH99oxEAU1+44u4vs9dS9U6f6pZNy42xDxaS5+uAg7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMUa81ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMUa81ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D79BC4CEE5;
	Tue,  8 Apr 2025 12:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115685;
	bh=M8T0pW4NGmBE/5LVCKIrGEylN4UkNIvu4f9QnAXNyXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMUa81ao1lBnkn+mcDZ1CfHgk3GcY+Y4do/bw+mNYeUi4MMnWGtVvtBK9sXhhRYk9
	 mPhNGgL6imrYqS8cA+4NG6t4kWv3tLpQzelDlxkx7PgJ90A0oy75RPmewPd9R9amEi
	 zP8+8iUkAOMFLa1nh/a8Amhpslw2OP+I0NTwSiCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Geis <pgwipeout@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/204] clk: rockchip: rk3328: fix wrong clk_ref_usb3otg parent
Date: Tue,  8 Apr 2025 12:49:55 +0200
Message-ID: <20250408104822.271336131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 267ab54937d3d..a3587c500de28 100644
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



