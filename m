Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774345;
	b=r5w0KFVGRd+o+Nlu+IWZBZiJH+UR6W7Wx6l1D5q5HCWCFz3r+x30jSTTlmhrJ8SN+crz
	 g53G2GMZGxIFPqfdp1UIv+daOWZjlDIhTsrUiogRyI+P6YRcEV21t/7g4GkU9zKD2yF7u
	 2Psn0lLTxttGjk5iHEdyTZ6YeV1yoaKCRWwExJfKbefuQvaK34R7lztLfdxB3FMkAT7jD
	 2rCNcENoGViYGwaUGwWquSn+02sMZK/NhMHTYU68WHoeI422k5iYOJygFzh+SL/noek2k
	 9ELYeJsyUbk8+87LY7FYTqeI1OmqV4KWGKoBEdI8BNckly+1fzjOvo/WYSSoP4XdQWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SNo/8NL/DP7sUqstKtqzqyblTH24/lmSKIZHiPKlmbI=;
	b=PODpWISBfh7s9NDjihyC/fXAhjX4ZbzIeOm1zvATzb8cxwE7zKc/ykozW/cM6X7ckpQV
	 O58QsbOUw2yoyGNDwjViWWsWMC5FPL5otdUuh2yrSxTqVEA3O7TACptBB/HJgwOrVG0m0
	 5u5xHdlpdWrJfsom8V/3nHP5U2qsYztftM+x/CkM9WHHfdW2ifGOJbqcLZcl7qymJjSBw
	 2mJQldqwN4PmqLLgqyJe+lZaYJwfWLDym2Be18M9GffR0Enu/g7gZHZ+jb28qm6wXRa73
	 s2e5X1vBDuzprAKBihigw6LlguGUWo5aHh2XcgEKii+tedPyKdNfKaG0lU71dykFK9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLUlH4qk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D28606A31E;
	Fri, 23 Oct 2026 16:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLUlH4qk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E30E1F01825;
	Fri, 23 Oct 2026 16:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774344;
	bh=SNo/8NL/DP7sUqstKtqzqyblTH24/lmSKIZHiPKlmbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLUlH4qkdBmd3fd7u4BYNb9bZvdoFTKT6gckKedJvFvN3POMbC9NeVpKUp2oqktHp
	 W8LQiIzEgJOVm7+09WCxL39CIEvda5OyxsRQxllNvsdNGIchwPhnCHcx+rSfYKpC/o
	 JpZbgLsDD8v6Z6d6NCAljMcxDHlRFvtaGl8du5Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Hasty Heat <hastyheat@gmail.com>,
	Mitchell Augustin <mitchell.augustin@canonical.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 002/242] i2c: qcom-geni: Restore the source-clock selection policy
Date: Fri, 23 Oct 2026 18:37:24 +0200
Message-ID: <20261023163713.871199448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index de5bc4b8a3a52..4c9a8f8f127aa 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -188,28 +188,31 @@ static const struct geni_i2c_clk_fld geni_i2c_clk_map_32mhz[] = {
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



