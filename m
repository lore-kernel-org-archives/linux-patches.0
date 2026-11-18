Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016646;
	b=xE1W3pCw9+bZ5DVB2E0MzdByQKeEj8SbYIf3kqxZlbQQAjSL51vNTciXlLDKI5XIGHoz
	 nhM/yaTY7BhiqpVv3Xgz1RUt5JUq3iTqVQS1mlDa7inTUz4dZioj/2f8hxK5Y+tMN1TXB
	 0Z0AvJs8i82zOxSgD0vvJYawTWn5qxayuXS8tr5IJvr4wSrrZg4QFnWCuSeuWRG9nsVo7
	 J0Bh8J6wU7uYojbb8HT+8t06KEv9cuJJZuegRwgYCuPJkjvn24vEefDghxnhpV7BpfmQ4
	 taqCXE3nOwqFu5g1HFzDzCMSpOixO/6C6A+NxUi+5dncXwKkY8w6SbSox4JzpmwdUQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8SeyQovBr5zoHc1rS2czx10F+8/KHbm/ZPkjlRUay7g=;
	b=lg0KSAh65gypLwyihKWEzzi61GvlaGk3N/Q6G2yHx4RwSRZlhb1/elL8vFGP+dwWQMQz
	 Dt8/w+UiGBSh9jXJit+kN4yPu4BpdzDuSpcclMMruxNPjsyx1t89X25HDF4c+mE416MfF
	 jUEx3W1G1hPvzDJiEO1wnIu8hiCgmSpBDWFo8/ia9KqV1hL0hYwNrJVEhq0Gh1uqa/CN5
	 WfzlbuSsLt7u3N0elG0JmgKrswkLZnJSVFfpNSLd3PTxO8hfCnt3tpS0wx0/+Sd3tASgn
	 tCIXgDLqB5qtBVrUJlNxtj/25WH6lImGeXZrxvkzKmhAkAGrVTcHR40ZTV1WaUiuwvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4c4QRML;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020BE60A2603;
	Wed, 18 Nov 2026 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4c4QRML
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B5F1F000CA;
	Wed, 18 Nov 2026 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016645;
	bh=8SeyQovBr5zoHc1rS2czx10F+8/KHbm/ZPkjlRUay7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4c4QRMLk6mz50fsRNnso+t4aUCwI4JZ+kvcwAimeQzMrqYTdlLvNk2I0m9NuzzFW
	 ZsUQqKW6ftk23WLtZZHzNybXG3Es4urfTyTpTtCmKNbO/lF8DB1gdZ+7PzKSnHz1Uc
	 Xl5u1FNisnqbGjtYK8+eCup6gCTyJOCMKtnspP8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0600/2651] clk: starfive: jh7110: reject oscillator lookup errors
Date: Wed, 18 Nov 2026 15:30:40 +0100
Message-ID: <20261118150309.325453774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 03c17cd2032f5..847c0a39e5ab5 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-sys.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-sys.c
@@ -390,6 +390,9 @@ static int jh7110_pll0_clk_notifier_cb(struct notifier_block *nb,
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



