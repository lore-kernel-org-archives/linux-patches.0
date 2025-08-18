Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D2221507C;
	Mon, 18 Aug 2025 13:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523009; cv=none; b=SA58mUbvpCKSIYsYn2potcWEXrDw7TdCqDtMKXFSvKUd2iK8TviFiArpn8acLMSEIuvtwJGpLnYFDfIxNT4bOh5aMQNKsrNDY2BzTO8xSUdByUa3Qk7zxvs0WedVS4pDTE1dQmBxVBfii/mFprd4xhoEq4y5icBLKZKPoGHRKZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523009; c=relaxed/simple;
	bh=dOZfL15U59E8KVITkrA6oZt6xgxV5mRmAAgHiGzqIOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PpudGMFpltIRHiuXGQ1bV/jtFl0KayMddFVobW6Wk0T+NHtFT8g7T+YtWOjqkXg3hkOid3UFsQ2j4AbHXOI/1kMNZaPRHeCmkVYkJtVs8c32ylRGUGV3+B/au+j2SP+xhHLV/odfBn7L429mhGhaBfma5S2x6KstFUoYm6TPCG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+Y1NViq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+Y1NViq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0EFC4CEEB;
	Mon, 18 Aug 2025 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523009;
	bh=dOZfL15U59E8KVITkrA6oZt6xgxV5mRmAAgHiGzqIOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+Y1NViq054xX9T/8WhgdUCtEiyapDatk7m1z26QUOmqqE0ju9fdjKOpFV7UIZ3d7
	 XtFPp7jVrb7sSgK8/+9NEj6LQsaY2FIxw/Q3kfJ712+5HOuJT2u3okneo/6pQwhNFT
	 a+dSZRmF0Tor4QnFFCVyx6WRHn5dhFdZDT7x+Pnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.15 041/515] clk: samsung: gs101: fix CLK_DOUT_CMU_G3D_BUSD
Date: Mon, 18 Aug 2025 14:40:27 +0200
Message-ID: <20250818124500.016999666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 29a9361f0b50be2b16d308695e30ee030fedea2c upstream.

Use the correct Linux clock ID when instantiating the G3D_BUSD
div_clock.

Fixes: 2c597bb7d66a ("clk: samsung: clk-gs101: Add cmu_top, cmu_misc and cmu_apm support")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250603-samsung-clk-fixes-v1-1-49daf1ff4592@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-gs101.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-gs101.c
+++ b/drivers/clk/samsung/clk-gs101.c
@@ -1154,7 +1154,7 @@ static const struct samsung_div_clock cm
 	    CLK_CON_DIV_CLKCMU_G2D_MSCL, 0, 4),
 	DIV(CLK_DOUT_CMU_G3AA_G3AA, "dout_cmu_g3aa_g3aa", "gout_cmu_g3aa_g3aa",
 	    CLK_CON_DIV_CLKCMU_G3AA_G3AA, 0, 4),
-	DIV(CLK_DOUT_CMU_G3D_SWITCH, "dout_cmu_g3d_busd", "gout_cmu_g3d_busd",
+	DIV(CLK_DOUT_CMU_G3D_BUSD, "dout_cmu_g3d_busd", "gout_cmu_g3d_busd",
 	    CLK_CON_DIV_CLKCMU_G3D_BUSD, 0, 4),
 	DIV(CLK_DOUT_CMU_G3D_GLB, "dout_cmu_g3d_glb", "gout_cmu_g3d_glb",
 	    CLK_CON_DIV_CLKCMU_G3D_GLB, 0, 4),


