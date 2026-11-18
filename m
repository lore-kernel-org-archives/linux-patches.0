Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039846;
	b=QEO77EjnYJj2rn3l61WPB4wYUyD1pjFqxjgt6LmRr3EpXJmU2q+IPJhPji8pe3A0tnsj
	 uHoOZKwKk9B499xn3KT419Rdu4Xw5teXT7VFReiJT7TnmKaFzITSe7cncm3s6eG+Q6hNc
	 ldPVVHFh1/Teiqmgnojqs7u2vTdhk/+IZHVvM0hWJq0v4XkFbD+0TIHBSWg4wqFz0FWPx
	 1dKIMaEDu6J0nwuPuxBRmRCxjoHEF1R29B2y7trXgRmE3roSOXD516/LXpd83nFHy0WWZ
	 fXg7QSf8tQNM5R0Uta6WMugih3jhF3tFPDHbBjEqs2htU/eFEjItg6fs+F3qeIAhwlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BI7BYNzBzpJnhZZx6gYEluSDRyO79bmrvNd4d5tzY8c=;
	b=eE/FZoUS+wtV6iVc0pM93BgAVwS+8l1kMKM/NRxiZoMm88IeCo5RoaFXYdPhhC4ZQeLe
	 qcDaEh8RGyQ5Os6/Gn3Jc+i/Hcl8Rp65xuxlQ6P3uqxZ27bPNiTM0htaaLjWEITnohUMe
	 KcipoRGeF4tb2Q8GEX/APTypGpAyA5nTIWm73Osy4Cf3LppBXMNZz+uOs9zy+A/pZn4zF
	 WQnuf0WJNTY2LMM1tCSW/B5vDwQiJn48VToVgBwol7moM1DZyHb8GIrHA9nDd/dCHBD9l
	 LzX+C57i5JpPk5hchPTlZEwAbEUoYsKVRKqdZ0H6qCM8+v1qlUK0thVpc8KaCTTRohA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=191F8Ipn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255F606A32C;
	Wed, 18 Nov 2026 22:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=191F8Ipn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429F51F000C5;
	Wed, 18 Nov 2026 22:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039845;
	bh=BI7BYNzBzpJnhZZx6gYEluSDRyO79bmrvNd4d5tzY8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=191F8IpnK5NrzqNNoclBwcgtSlBY5DP7E0LFbTowAmmC/WMwMQLbW3PxIOheXMFeA
	 JGilSGcX82/Oxq7qxhmOlIacUIrn6G6jpwzBeYZmmVBL8LSqAnSBiRy1JmYL7ty5pi
	 Lq5du3g1RA/6pKEnS43TY/u3R4ErKZvJlnjSRlCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2246/3318] clk: milbeaut: Return divider update timeouts
Date: Wed, 18 Nov 2026 15:47:48 +0100
Message-ID: <20261118150429.222622503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 92d0998090d1716ee6b47174c10eb9415a12fca8 ]

m10v_clk_divider_set_rate() logs when the hardware does not clear its
write-valid request, but still returns success to the clock framework. It
also uses the sleeping poll helper while holding the divider spinlock.

Use the atomic poll helper under the lock and return its timeout so the
rate change is not reported as successful before the hardware accepts it.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 6a6ba5b55a72 ("clock: milbeaut: Add Milbeaut M10V clock controller")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-milbeaut.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-milbeaut.c b/drivers/clk/clk-milbeaut.c
index 18c20aff45f76..ef4d8f862f5cb 100644
--- a/drivers/clk/clk-milbeaut.c
+++ b/drivers/clk/clk-milbeaut.c
@@ -411,8 +411,8 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct m10v_clk_divider *divider = to_m10v_div(hw);
-	int value;
 	unsigned long flags = 0;
+	int value, ret = 0;
 	u32 val;
 	u32 write_en = BIT(divider->width - 1);
 
@@ -434,8 +434,10 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (divider->write_valid_reg) {
 		writel(M10V_DCHREQ, divider->write_valid_reg);
-		if (readl_poll_timeout(divider->write_valid_reg, val,
-			!val, M10V_UPOLL_RATE, M10V_UTIMEOUT))
+		ret = readl_poll_timeout_atomic(divider->write_valid_reg, val,
+						!val, M10V_UPOLL_RATE,
+						M10V_UTIMEOUT);
+		if (ret)
 			pr_err("%s:%s couldn't stabilize\n",
 				__func__, clk_hw_get_name(hw));
 	}
@@ -445,7 +447,7 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	else
 		__release(divider->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct clk_ops m10v_clk_divider_ops = {
-- 
2.53.0



