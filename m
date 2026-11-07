Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064616;
	b=UToVRFmlMsvZ0lUOjrF0tBfe6RUKDUjqvIMFqwsJpETOItIMgk0g5Segm/h7CFFK08j5
	 NFMnFWf9KLLd/h3kO8bf1C7+re6qau1Hfvcj1il3Zr1lQeGWeONvp/s20R/SehDEA8haA
	 zf57ab6hRf5qTr/EJPfuFSKssjk3q9zaOXA3wfMmmT878XtPS9Hljh2vE10jWuzhtf14H
	 9mCENK2cqFDKYf18SoVQhJViaupZdc/h3scalbPbThEv+qsRfd8J0NLUTG/LqULWz/4is
	 OpRQzRZNaQ81xmGxh+I+buCZ9zVeqT7JBmYP8x6V0kESmgHh4hhUE527wEbltZYk1/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g6TvQ9nzv/Uxkr2Eh1TGKzNET3+TXaM5FrGBAdlpsYs=;
	b=IdmwAutEyUaMwSZ9B4x6zpgdawyq6gCFD9JYngJnUSJphGXIXF2TuTPZaDwW+JuBSgOv
	 iTST/FBrFfm3X5rTsRSVKCDQOIoxS1UcuTyqzPTXN3wDBZ9YxgFStkraHpZr9obO0Zulh
	 0OOVt3OX7cseEVFTnNxhNQgVsjVqk0mlr5mjLNSOku4+BIIThM11U4wkObsRkfeFRdrq8
	 We7NVgOSWenH7Jt34CNyITLMj98gqjrx4uoPWwBA/OxlIGneImIJ1dOm+KgAA8Cvg14nm
	 24S+9XZKNVjGZyzHyH4L8w5nRucMRBJQUFikC+VVEFmm4xrm+hYFbAbTAR5LjS6aEsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whhERd13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3C3606EE82;
	Sat,  7 Nov 2026 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whhERd13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C791F0089F;
	Sat,  7 Nov 2026 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064616;
	bh=g6TvQ9nzv/Uxkr2Eh1TGKzNET3+TXaM5FrGBAdlpsYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whhERd13yMOCpSSgB/JUp9qusDRNW7K/Y3FCcvgdvsxaT7tutuZvQBZYEGpxMohAs
	 O7eLwFYl2BqEbFBSKi2AO7MG/Ao20tiKsmw+1i6/6Ja6qEZ64n9HCqhs4m/F6u1PL4
	 eSNtabg1ARntcH3bvUFmpQwBqjt9mGU2qcX1PSSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0588/1257] clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()
Date: Sat,  7 Nov 2026 08:48:04 -0500
Message-ID: <20261107134955.580572339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 52d4d1b26a5bc64de95099d0a3dd8b90dba1f3a3 ]

imx_obtain_fixed_clock_hw() obtains the clock through
imx_obtain_fixed_clock_from_dt(), which creates a consumer reference
via of_clk_get_from_provider(). The reference is discarded right after
__clk_get_hw() returns the hardware pointer, leaking it.

Keep the imx_clk_fixed() fallback unchanged and drop the DT-obtained
consumer reference with clk_put() once the hardware pointer has been
extracted.

Fixes: a4a4069f4523 ("clk: imx: Add imx_obtain_fixed_clock clk_hw based variant")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260915055631.1730231-1-vulab@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index e113e30514fa2..49e51e949f71d 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -95,11 +95,16 @@ struct clk_hw *imx_obtain_fixed_clock_hw(
 			const char *name, unsigned long rate)
 {
 	struct clk *clk;
+	struct clk_hw *hw;
 
 	clk = imx_obtain_fixed_clock_from_dt(name);
 	if (IS_ERR(clk))
-		clk = imx_clk_fixed(name, rate);
-	return __clk_get_hw(clk);
+		return __clk_get_hw(imx_clk_fixed(name, rate));
+
+	hw = __clk_get_hw(clk);
+	clk_put(clk);
+
+	return hw;
 }
 
 struct clk_hw *imx_obtain_fixed_of_clock(struct device_node *np,
-- 
2.53.0



