Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055127;
	b=Ntvr5D1VZjwfTnAH1NWrMgBXShc7k3uWcqFQKbQI96trUPyQ8tagwQpdNzxYpZrK9ew5
	 j6a0L28zPWJG7/2MVzpcIkFtYnz8f4BK/8objCA1sZxejZgl/JqswKLdEvoRnsklcioUs
	 DjmEA+k51EEMb+Z8grCfjNxoQlFF/Cu/CsYR/aI0u1VHEHnZZUsmTnZJbzIHLTazWjMi7
	 /ZU9Q9QEafzA9r9XlI411RLhqiBeJDPYACa944apwJ0mo7YHCO7Esr+wp88tpDZX05vx+
	 CoFXwgtJ26nknjvIAEGhSsoCo12yRBHNl/MAEpS0dJIM8heSlXwsVfgFzLWb62AGGhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SSRWILT4BPdgkLpfZtpggy7HI7/bMEWN7CUfF5/i5yI=;
	b=cVNEu/KRmJproVut/vgUjIT1/RSnZwvhvHGJPOZMoDlJpkrK3Ju6Y6SqFiyvtacbDPRK
	 g5UoxYd+ZRWjstxn3N9+RUA5oli29pGTxX6PJyzJzNDHOsYhzys9tJhbph0twQXutcApA
	 R1tE3HRoFFBFBttUmXY8HKS3Ati1NNXmU4kOFqP3XYGh2S8Q2JeT1jXbjnwKy44q/rUci
	 hmbcFiaqxJwmRC5V18QkvHdQjPRMP5O0+Hhx/Y8CejDmi0we/ZDmSKLd8wXDq47KKpwCG
	 J/dKj60EFJmU/B5ekYevtpM3RSHQC9xF4Qt050CWpTPWnV3qQCwCn7Y17fhn3o9tzcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUNCUIfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3943C606A325;
	Thu, 19 Nov 2026 02:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUNCUIfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5E81F000C4;
	Thu, 19 Nov 2026 02:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055127;
	bh=SSRWILT4BPdgkLpfZtpggy7HI7/bMEWN7CUfF5/i5yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUNCUIfcnnbJbIEgnSo15+UEdjxOsw0ZIx52kY8dlRE9c9OTYtzRkoaXZvSELsjB9
	 glhoQ4HYujgBi+Ns/f9iyyJV+HIN4+ZqTW5J//NkgHUkEz8XPA82c707FX8PouYo1P
	 GRX21T96sb7lbdTu7kpAwXF/ZVVowW5mQR/jVCcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1521/2214] clk: milbeaut: Return divider update timeouts
Date: Wed, 18 Nov 2026 15:53:17 +0100
Message-ID: <20261118150112.988326465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



