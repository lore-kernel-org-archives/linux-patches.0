Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040057;
	b=p6nhIEyrlWJG3BeLMq39eD2UZPN9cfQkNsnIBK4MPaRuVC1528onjiGtuyIgjUk7MkfJ
	 HjiaFZfBc4WmIS5hrDkrmlDzVVo2z7vbzXPfx1Jj4xJVV0PiwFatNjidCYMUbbDlFk7Fm
	 +3xS8kIje2bCWvnb/PLoWutmaBtwdx+lklbGaL/8U31ryyWQEXm4/yx1rdl1+qumhtFQJ
	 FGMxxn2j6F6n0Bd08SdKFXc7f41YYb6kQC4HZoJqoq+xKYDo61Wfr7p3NeErbFRK59WgO
	 rjLxknd+thoYxfZfQpXhTK9Oc810o/TdAgQUV/4Ig4nSjcMvcHDGRAvxBddZfDh44VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yo4nWdmtJvSTZw/WVHOeHWZjflrilSNYhHdKZtyz88k=;
	b=aDTF/bvtvuhJ7s3k9KMfZbySGoljv+MJj7IrxsnlTYoG6YqCIHnYM+E+jp/5Ei8TFYj7
	 p9ql+JhOnH0pg3MEOcssLIciq8Yokg9O7CktwovIu91C5oyRZ+f3xLWNPEQShCdW/kFV2
	 Tb2CGJ97NDiqi+4M/iemUf+hDXsCP1ATpz63haVJ3iiKVMFZ5C/tqIiqeIDvNaDcJLIP8
	 tuRCcoSqu5OGmz7Jcsf84LO9gcgvEp4MH/5mTekXYtb6r63et0+JPhfo+byJNdalDlTpW
	 l3BsQn073dL5RVaA9TTH+8aUoEWqjjXdo5rDP1DcEotw6v1q24bXtGiydqJB+nEFDwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyLBGye8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AF3606A31C;
	Wed, 18 Nov 2026 22:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyLBGye8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FCB1F000C4;
	Wed, 18 Nov 2026 22:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040056;
	bh=Yo4nWdmtJvSTZw/WVHOeHWZjflrilSNYhHdKZtyz88k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyLBGye8/E1TWoThUP0Waa+hcjG+aJMztZlhaVHsuc09+wLtoFCCnoqilhJ3uTeXI
	 /gjlMP3biu4fGkzSgb7TTXJYn2WDrrVjUuZDr3TyObrsPvzBTvRhjTmEdASNHOV9ZL
	 MivqSYkS6iJlAGLtQ2xf0+lOH6bqdo+M1wofCwdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2271/3318] clk: starfive: jh7110: reject oscillator lookup errors
Date: Wed, 18 Nov 2026 15:48:13 +0100
Message-ID: <20261118150429.926647349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 54d0b6903921d121fa750546f2b38cc3f5c7e64f ]

Clock lookup may fail while allocating a consumer reference. Return
a notifier error rather than passing ERR_PTR as the new clock parent.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 538d5477b252 ("clk: starfive: jh7110-sys: Add notifier for PLL0 clock")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7110-sys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-sys.c b/drivers/clk/starfive/clk-starfive-jh7110-sys.c
index 58ef7c6d69cce..8a232164e2596 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-sys.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-sys.c
@@ -401,6 +401,9 @@ static int jh7110_pll0_clk_notifier_cb(struct notifier_block *nb,
 	if (action == PRE_RATE_CHANGE) {
 		struct clk *osc = clk_get(priv->dev, "osc");
 
+		if (IS_ERR(osc))
+			return notifier_from_errno(PTR_ERR(osc));
+
 		priv->original_clk = clk_get_parent(cpu_root);
 		ret = clk_set_parent(cpu_root, osc);
 		clk_put(osc);
-- 
2.53.0



