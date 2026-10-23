Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773784;
	b=KyW4n6wvcYwaXSzKt58HVrQzb7SU/Dvn6+GSsST1uDW5Sfz2BRqNTvKBgUNQJgNyTn2N
	 bzJss0NrVaL4vzdCDqzRAwiVTFOBLbx5+3X81s/27hRO+Xmqw7zozUpNe48z3aEDGW7SO
	 2558A8jagBtYC3WEF/l2OdXzGeqf/JOqj50C8ijeDmTXL0I6KzEdEuLZOYflLe+cos5Ra
	 iiwiow6uIzyCYNLy702EXSbsiuFnjSXcovCeGELxApwm9lARTggG30t0wA6n+7LvQdGOo
	 UNu1YdV1mPWOs/VHO9oQG0nTAPLxBfAdTTHMsK1V8/nQtne7O+QVPWvUvSSz6rNgu7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Mgd4icOK4KzD10Y92Quayb9G9dEUjvHTk4pHsJ0gGs=;
	b=pp0mQSALvFVaO6VQFXqUjwd4XboitGv1PFUpRpUVDfR0jo2/AfdmKNV5FTe/fXj9v6h2
	 DNzO0IE4cc9kHbM3h+sMM/0J+HXwjEVN6zndH12netLJmrGl9T8LGbcDt7ScVXV1bMwIk
	 B0P/UxM3vsSAfyawQU6EiGXJzFsa4x50jJKu6xrr3RUzaNS6Mw62YVfAhd1I59pApXMM5
	 h5KDUFYPTKHFnKGpj+QHwt7SCyMmMG3daJBqFVYc62WpXj1vVnuIggHhP8KE/cLI0adUw
	 sVpVfreMx3oP2LUnubJLxX9HaDUq5A1U1ngrWOgdgLEpmiQs0oMfeTgvBy3wVfU+WYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i6dTP6Ub;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E6C606A31A;
	Fri, 23 Oct 2026 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i6dTP6Ub
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A491F01825;
	Fri, 23 Oct 2026 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773784;
	bh=8Mgd4icOK4KzD10Y92Quayb9G9dEUjvHTk4pHsJ0gGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i6dTP6Ub+zp8XvgyptDuZaj664jnZ2zf8IN6ojCIB7qkq4mZQq/f/UfU1W6AWGZ63
	 uhaMYyG9O0qn6kNcVKYhA+FFovXguApTR4MfJfQ5sLWtlIx+yKotI5V58kU1LwE5XK
	 tBVB78kX7VaSzq7gV6nK6miorDipqT7XMGIpFBv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Hasty Heat <hastyheat@gmail.com>,
	Mitchell Augustin <mitchell.augustin@canonical.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/193] i2c: qcom-geni: Restore the source-clock selection policy
Date: Fri, 23 Oct 2026 18:34:44 +0200
Message-ID: <20261023163714.378050090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 8cb5c17be3a2fadc41075d04ce1c24c831546aaf ]

Currently, the source clock lookup prefers 32 MHz whenever that rate is
available, regardless of the rate configured by the platform. Before the
switch to looking up the clock index, the driver used the 32 MHz timing
table only if the current source clock rate was 32 MHz, and the 19.2 MHz
table otherwise.

On X1E80100 CRD, this results in switching the source clock from 19.2 MHz
to 32 MHz, which causes intermittent failures when probing the I2C HID
keyboard. These range from corrupted HID descriptors to failed resets
and transfer timeouts, which also affect the touchpad on the same bus.

Restore the original selection policy: use 32 MHz if already selected,
otherwise request 19.2 MHz. Look up the index for the selected rate and
keep the check that rejects higher-frequency multiples. This retains
the dynamic clock index lookup without preferring 32 MHz on platforms
that previously used 19.2 MHz. Report the requested rate if the lookup
fails.

Fixes: cb97bf3d4f91 ("i2c: qcom-geni: Fix hardcoded clock index in SE_GENI_CLK_SEL")
Assisted-by: LLM
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Tested-by: Hasty Heat <hastyheat@gmail.com>
Tested-by: Mitchell Augustin <mitchell.augustin@canonical.com>
Reviewed-by: Mitchell Augustin <mitchell.augustin@canonical.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260928-b4-i2c-qcom-geni-preserve-source-clock-v1-1-9aded7552a76@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 37 ++++++++++++++++--------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 307e2e4030af9..fbfffbec05e14 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -169,28 +169,31 @@ static const struct geni_i2c_clk_fld geni_i2c_clk_map_32mhz[] = {
 static int geni_i2c_clk_map_idx(struct geni_i2c_dev *gi2c)
 {
 	const struct geni_i2c_clk_fld *itr;
-	unsigned long res_freq;
+	unsigned long req_freq, res_freq;
+	int ret;
 
 	/*
-	 * Frequency counter tables are calibrated for a specific source
-	 * clock frequency and are not valid for any multiple of it
-	 * (e.g. 64 MHz, 128 MHz).
-	 * Use exact=true and verify res_freq matches req_freq literally
-	 * to reject harmonics: a 64 MHz clock that divides evenly to
-	 * 32 MHz would pass exact matching but produce double the intended
-	 * I2C frequency with these counter values.
+	 * Use 32 MHz only if already selected, otherwise use 19.2 MHz.
+	 * Preferring 32 MHz merely because DFS supports it breaks I2C
+	 * transfers on X1E80100 CRD.
 	 */
-	if (!geni_se_clk_freq_match(&gi2c->se, GENI_SE_CLK_32MHZ,
-				    &gi2c->clk_idx, &res_freq, true) &&
-	    res_freq == GENI_SE_CLK_32MHZ) {
+	if (clk_get_rate(gi2c->se.clk) == GENI_SE_CLK_32MHZ) {
+		req_freq = GENI_SE_CLK_32MHZ;
 		itr = geni_i2c_clk_map_32mhz;
-	} else if (!geni_se_clk_freq_match(&gi2c->se, GENI_SE_CLK_19P2MHZ,
-					   &gi2c->clk_idx, &res_freq, true) &&
-		   res_freq == GENI_SE_CLK_19P2MHZ) {
-		itr = geni_i2c_clk_map_19p2mhz;
 	} else {
-		dev_err(gi2c->se.dev,
-			"Unsupported SE source clock: must be exactly 32 MHz or 19.2 MHz\n");
+		req_freq = GENI_SE_CLK_19P2MHZ;
+		itr = geni_i2c_clk_map_19p2mhz;
+	}
+
+	ret = geni_se_clk_freq_match(&gi2c->se, req_freq, &gi2c->clk_idx,
+				     &res_freq, true);
+	if (ret)
+		return dev_err_probe(gi2c->se.dev, ret,
+				     "Failed to find SE source clock %lu Hz\n",
+				     req_freq);
+	if (res_freq != req_freq) {
+		dev_err(gi2c->se.dev, "Unsupported SE source clock %lu Hz\n",
+			res_freq);
 		return -EINVAL;
 	}
 
-- 
2.53.0



