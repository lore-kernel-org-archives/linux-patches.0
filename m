Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69137172BA8;
	Tue, 10 Sep 2024 10:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964076; cv=none; b=poQxoZ3wy1CggjY1dDtDCHgge/x1oUQG7w2NDEtJ5ujFAN725i9a0Ns6sIwC8HllllgjrW+Oa9cm/+PLYQphu/A1cOCTRjKqpA0LsT56WL+6wvfsvtt1/63gm0Z6fP6nyD1dGxqxKn2gRFHVXghWTkcsY1uImYq92B2j1VcQusk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964076; c=relaxed/simple;
	bh=Xp2xHTpxPlVMXrl1KmLpDEB+pMx6nEB5+rpIrgxyNBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfqoFORf8OpV4tpHbeg8jCVBlNIk+94AM1XyyVRJRGYUTgoYUR6L+yI/zVF+Tz24okyxk8iX7/GAK+7cy3b9ilg9oezOLMhL2IFxmglQxrx5EsEslXUGDqLuXy6cZzls1GVLBH4FDJGv/mKgg0xhAectQSwEbCpQu/r4YtH8noY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdQX8yT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdQX8yT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA01BC4CEC3;
	Tue, 10 Sep 2024 10:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964076;
	bh=Xp2xHTpxPlVMXrl1KmLpDEB+pMx6nEB5+rpIrgxyNBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdQX8yT6858mom73FY9w27dU7/EmWwEmTnlYK3sy1T+RZH6LlpoGLTgWXm7V6E/kd
	 hRTGwEaVYGVtI+vqG9eTUI+Do/rytJiooayeQ513HxSzk26xatUQBLhe5NWFtg9lcB
	 cVkb1IySTuId7NJAcgW4ECq4Z76EbUTdj/7Q0ce0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 033/269] clk: qcom: clk-alpha-pll: Fix the pll post div mask
Date: Tue, 10 Sep 2024 11:30:20 +0200
Message-ID: <20240910092609.427106846@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit 2c4553e6c485a96b5d86989eb9654bf20e51e6dd upstream.

The PLL_POST_DIV_MASK should be 0 to (width - 1) bits. Fix it.

Fixes: 1c3541145cbf ("clk: qcom: support for 2 bit PLL post divider")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240731062916.2680823-2-quic_skakitap@quicinc.com
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
-# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width, 0)
+# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width - 1, 0)
 # define PLL_ALPHA_EN		BIT(24)
 # define PLL_ALPHA_MODE		BIT(25)
 # define PLL_VCO_SHIFT		20


