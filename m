Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060636;
	b=QsBVVmxrvu6qEetTzZhSFCvPb8DWZyYpaTFcOZBnK8JJ1Iuv4bC5g5qQHIoDk+yIBtVR
	 oeLjtmzoVHCaccIR1UZyo8xsXpdZ4tLru37MFUEsCap6EduIfbV80Yn7kGenXMKbymzSV
	 2BXzzuEg6BtzxjydPI8LO+vdrqVBaSsexKKJWsESGV4gL+GyR+1CsQBZuoCd56Gox2Kxs
	 vpHThjWw3ExHopbXStIzj3vn8zBbvya0l0egeyd4lY7tQaLmKoj0L/Yw6bKtnixpaQ6Df
	 uQemO/lw0Luipw5otbAr2KLOQIVzhELKgvQ0XUvYtq3dha7A3uG+KdHj8HVR0tQDcmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dCTaZ9cI5gMkDQjwtl2kS8UEcQhoFzF8cbYmlQdCFoY=;
	b=AkQziM0UGRq7V2bdFGFB2P6xArNJaNsxN5r8QG0+aJYbn76g3PAg8wdJSXjKIQ3p1RVz
	 TU1TIE1kqOOyH1UPeW/sMX9J2df7IHi1zMd4qo66I1/ZRE/K6SgmXOIM30h5f5BGhHNqT
	 d9z3Is+4Sxc4TiYLCWW0T2ORDA+rPrk29dyLad0jG58/LbbJDLz87hiyRjAljCwBGYsUS
	 x4Hl0wIETrLQn4OWSg3cxzdGH1zMP88siqDsYgkkiEbgiJBNIUdvi7hIkM5D5CRl7kQ8f
	 AUKdYgg+LctD66uueSSCY5GpORK7RGxO+5ASiHny3Zui8Z3aXkCXWRCf2zkNMnZIilA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmTl63nd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52E6606A326;
	Thu, 19 Nov 2026 03:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmTl63nd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0672F1F000C4;
	Thu, 19 Nov 2026 03:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060636;
	bh=dCTaZ9cI5gMkDQjwtl2kS8UEcQhoFzF8cbYmlQdCFoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmTl63ndKDT7IYBUrsVh4/ZWTdiVDKetwGN6m3r3CCmuiB+zEFCSYvfabw2KBNm0W
	 66c/JlMBJCEKWe21P+/0of4Z7xeHHvSfxqevzK7TZK0CIIchfFSd8t6Oc1Nzg7snz1
	 Kh3n4qifJmML58kwMo4rOTWX40SIquFkdaHUecwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1269/1848] clk: milbeaut: Return divider update timeouts
Date: Wed, 18 Nov 2026 15:55:07 +0100
Message-ID: <20261118150012.786413941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



