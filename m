Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048336;
	b=MThnojDtrMZYtE8yZ3l6zz8ICY6yh+Y4UsVSCCVeohvhJWxXuHQNCWusZCBCyi891BVD
	 EZT+DxyCjr6vq/C7X6teruImq+fgBPv3EvlmkIlIEYfA/CVcsKIdNRPM2ShfGNWdhNf8z
	 4/0l7cX4TPK/gu3HX1wsRcFHhhQcW0w4+MuoHt2N/SANhr3wo6+FYjUdXfERmjrQWClry
	 IbU8K0T8cmLi0fcEUc1eSR70f1IBST7V2Qh3gmj5LwKWc+k2kFUXqJHAc7n1DJYKJuhbu
	 Ja0pqQqvIdly1uJYV77DNAaJMbWZ/1IvP//8wUWpQJhfQrGDQT0y+YlPyBEbkFN1iMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=759jPZo+y3gSOWeQLMFHQfoeMV3u8HXdxIe8jXhvaEk=;
	b=LfshtEFaxfMymxYFkPIYPpiP8PA+Dhxh1yF9cS88EL0lefgYMIvcIjE94FI/aphEl9ge
	 Ck3sWcKG74RZkxcwXSwwaaO5EM6Q41KBTS/+CWjZuI/PXaovNbFJb4Oh1s44HTsdFyCvA
	 ghpkmAguZUb0DaTzNODRshQaGWQLHKUm3+fqHOXo83TZqhY57ePM6m04Mi/0GtItdg3EB
	 B1hWPBVruuITMd6jKWqjVuyx5yIj7RS0wEU0R7wtAzQLXPhEKy2GRGpV8sR+zwUPGZcLl
	 3GZ/5ziO9fbZhX+UAOh4p1ongwHR3UbrrRCKkujtE2Loi9u52axzW27XlvDa2B0mMdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPeQYj1x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92E8606A320;
	Thu, 19 Nov 2026 00:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPeQYj1x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CDC1F000C4;
	Thu, 19 Nov 2026 00:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048336;
	bh=759jPZo+y3gSOWeQLMFHQfoeMV3u8HXdxIe8jXhvaEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPeQYj1x8j7U/JLBTUBpbess/3t3rWBtQXd90Dzn95HKeWSSpbTWxn0eaWeNu28DW
	 AqHBu6wIqAF5O8dtmt1w88xykwd9iDbd0B9EG8hxzC+pUChyBMpLiLtW6GfuXq20yS
	 XiDaDL9Z/t/2L1bmxIrxnwFJpz/YwWQa0UnPAqnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1959/2857] clk: milbeaut: Return divider update timeouts
Date: Wed, 18 Nov 2026 15:49:53 +0100
Message-ID: <20261118150311.940860784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 80b9d78493bcd..eacc37f5b0bbd 100644
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



