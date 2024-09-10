Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680B9143880;
	Tue, 10 Sep 2024 10:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963506; cv=none; b=hEF3W7a0/+RzDRO8OXYlWcri+DZO8P0vlOr2dCCqql1DC3nQ2/P0QNiWk8ut5N1+lRSfGbml8vmZtp4ERPIRgW0o0nyUvQHJ2ElBh0oAaGF+J1NIYpRbZKD4zGvKGeWtw0Rc/xyTq8rSlrrfR0MH4HOV2veb2Z4mhqppoM/5w5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963506; c=relaxed/simple;
	bh=g1AfPQYu020euDHmNjZsgKSSqtEQOCx4wMBrnvJPJ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRw9leL/WNgBHpeXu5lKhGHr7ms6ofsNGPCZE2TbHOGwCVzfThWjIV4zvEpSnSUg4ZTf53ZK3rQWxudFlaTW9JFeQ9KDN3Wiz+QpLSLrrep5c2AxDR1EDIpuTtj587QXO9h6IE8XJohc3nMOBUf5mZhgVqgCgXGxa44ZH00hrts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxmafKBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxmafKBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC10C4CEC3;
	Tue, 10 Sep 2024 10:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963506;
	bh=g1AfPQYu020euDHmNjZsgKSSqtEQOCx4wMBrnvJPJ4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxmafKBuEkvrydqiy6sc913WtTiH0YeMAntEHauLEm4YFbZO50XF8KNaT2NF2Q4Yx
	 5SdWQ1c65tLVpoWef/DqodPPtrZdzntakuRl6PCFr1v8tiqenEFzJ6R/3v5daBwsJ7
	 tTYLJEjyBAtXjQIepGGQ6BeWD+YdmFwURtgzWhys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 080/214] clk: qcom: clk-alpha-pll: Fix the pll post div mask
Date: Tue, 10 Sep 2024 11:31:42 +0200
Message-ID: <20240910092601.999717226@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,7 +38,7 @@
 
 #define PLL_USER_CTL(p)		((p)->offset + (p)->regs[PLL_OFF_USER_CTL])
 # define PLL_POST_DIV_SHIFT	8
-# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width, 0)
+# define PLL_POST_DIV_MASK(p)	GENMASK((p)->width - 1, 0)
 # define PLL_ALPHA_EN		BIT(24)
 # define PLL_ALPHA_MODE		BIT(25)
 # define PLL_VCO_SHIFT		20


