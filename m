Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AF9214416;
	Tue, 12 Nov 2024 10:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408383; cv=none; b=hhH8j6mLAerza7zgFzK+wedk7RdzSmiJdscq5ou5KGNnBw5ymFoK72yF4PaRJFEZyhtko3oqe3gDWoa89+G5htSWmOjSL3p3TZH9uSD8+F/WEXzm185Q2Hpfsljs8i8HRoevuLeCr22vUatsZBeBQlVxloDijfMBHX/6dLlom9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408383; c=relaxed/simple;
	bh=dSvDIJLBQi8+VidcwYBDzrilrovx3pzSeJPrmOre4G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvQpeWPTGB/I2zv1ErV64NDQ45Q+Dcylpaykd4fbajSlw4GJLjR5OMwXdhilfjdVCrFv04kB4j61EjiXs6N7T1sJrGuZBMRDEgV2HfgDVFWKR389bUL7eLEdbe1p4jXbO+ky2EYc3K2dwDvJgK/7AGCiwPMwooRNod9u3kko5eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdG/ZZJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdG/ZZJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162F6C4CECD;
	Tue, 12 Nov 2024 10:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408383;
	bh=dSvDIJLBQi8+VidcwYBDzrilrovx3pzSeJPrmOre4G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdG/ZZJXgIs5IBDOY0zAXuEKTycQat/9FZ/neVrJ0l5nwsBh0HVJDp+A79PuekRWY
	 c2cbbQYsnP+b8w9ibT15oLRp8+DM/22nQCZ6zjRw4M+Tag8gPvZLGRHCiiLWGUm6tv
	 36GE42tt8g4kmOyKbWC51HWKoN5ftTlMJwXSk4Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Christopher Obbard <christopher.obbard@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 146/184] clk: qcom: clk-alpha-pll: Fix pll post div mask when width is not set
Date: Tue, 12 Nov 2024 11:21:44 +0100
Message-ID: <20241112101906.474291985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

commit e02bfea4d7ef587bb285ad5825da4e1973ac8263 upstream.

Many qcom clock drivers do not have .width set. In that case value of
(p)->width - 1 will be negative which breaks clock tree. Fix this
by checking if width is zero, and pass 3 to GENMASK if that's the case.

Fixes: 1c3541145cbf ("clk: qcom: support for 2 bit PLL post divider")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Christopher Obbard <christopher.obbard@linaro.org>
Tested-by: Christopher Obbard <christopher.obbard@linaro.org>
Link: https://lore.kernel.org/r/20241006-fix-postdiv-mask-v3-1-160354980433@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-alpha-pll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -40,7 +40,7 @@
 
 #define PLL_USER_CTL(p)		((p)->offset + (p)->regs[PLL_OFF_USER_CTL])
 # define PLL_POST_DIV_SHIFT	8
-# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width - 1, 0)
+# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width ? (p)->width - 1 : 3, 0)
 # define PLL_ALPHA_MSB		BIT(15)
 # define PLL_ALPHA_EN		BIT(24)
 # define PLL_ALPHA_MODE		BIT(25)


