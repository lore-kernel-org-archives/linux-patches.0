Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A9818595E;
	Tue, 10 Sep 2024 10:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962526; cv=none; b=bSrJuMLckbsWyS37lG8F9o5j8zxHruZYkxCnAOdorKhbnS4Ze3C3oV2pZ8WUw9vTo+O0D6rzY/tg72LIOn+6Ai0Ak8aM6aYBJZbkqbF6JjZjE1RZYMFXCmHSQw1E5Tgtn2l+xqA2rl1XwyE1RpwlQJODmsk4eG35ur0F/KMtG4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962526; c=relaxed/simple;
	bh=xjmmxg5//wFj/ENC2qBnKlKDXKdklL3AW6L9ygHIE6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4W4dA9pTRwsmqH+Gikl33gMTLFaEX7syXpce0X99k0Ufcs8iGoTRCZ58aUoGmQdSlrSymH2v+8sWsbM/GxkdXHWXl4VPjF2hHjRlVpAc67cJekULT4lQDaKK6a5ZNar/IKHOu1uMx0M7jVJ9h7m5PSi1kBtNPyU32mP+qIxLR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQK4Sd1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQK4Sd1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F093BC4CEC3;
	Tue, 10 Sep 2024 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962526;
	bh=xjmmxg5//wFj/ENC2qBnKlKDXKdklL3AW6L9ygHIE6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQK4Sd1BRUONPzz5PqteeZk7EIB5HaG7Nw+wqtr3JHgfBeDAhWEXRDo5vlBwpN6u3
	 3STs8YPNHXDfFQ39CMAc1KWmAX1p3oNVDY3URLcYWPtk1v9avIeO7sLIgjK1woC9j1
	 MN7/1NhMfQsxAgFQgBtp4KvLUyYo1kWlcbpj5n0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.4 037/121] clk: qcom: clk-alpha-pll: Fix the pll post div mask
Date: Tue, 10 Sep 2024 11:31:52 +0200
Message-ID: <20240910092547.480621399@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


