Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023941;
	b=rrqW8pUSRsxW6TJJQHfMtFtfJ+DCqmfHjkx1ndif+jUPRxz1d00pph9tenohUKS84hpW
	 caVrvGWQXfj3DPi3P21b/ziSVvzljNOjT5+9rxqbOiflOTmuj/5+bad+pOWxqpfOn8dkl
	 zRDxGGKZSPcGfaLXki2r1YJOrT4Xon+TMnSdDx3NPTe3jh6XPCxNbmA7rDgUqtH0EhQNq
	 /3CY+PgdkJP9n58QhhDbGz+e9LbRkic39+IsuCe1qDyBLbGfiSTJ6KZ+nCqzFKEj8etui
	 8LZsFPR8zk8tXml7UIjc0dibMXdadxzXAs2drQGJlvL1cVsVN7QzeHxDUUzepuiJbhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ggxffpyhmCx1i39retyy2/RDCZCvF2DNGi8kG+JXWU0=;
	b=ncMzgaHoTeECcd+FX4zkHvPTv6EzbvRC2pL/hUfWC11TkEa26Krgzaq6cji/vGqo7mSR
	 N/Fxjt6dVQAimBr+0uYSpCViJD3QQtaRWox0eVrcRIN32lcFIs7SUf1WKR7ZuK42RoYjj
	 6VTHg0DIXMh7FEBYc6LqH9S538glZCnQ6miX4fwvV8fgEiMqRu6SGkjIub9/G1XFFyv4d
	 zYkGz/FMiYY88W0a3NjlqC9vAKvytK/qO5dfVZ5BiESuzuoVqM3VbQauoZNWk0o4DsoS3
	 q1poAo5Lu+ATzYXBWhn+SYboXZgllvZ62Y0VilvvtBM4hCVCVV1uOKkXH0gx0ry/xiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q/8+Ui56";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC2606A31C;
	Wed, 18 Nov 2026 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q/8+Ui56
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5FC1F000C4;
	Wed, 18 Nov 2026 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023940;
	bh=ggxffpyhmCx1i39retyy2/RDCZCvF2DNGi8kG+JXWU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/8+Ui56S7PHABf+k0euOJCFYJNKKbqzqwq54q80ZYVg8FmE8TbduULxLqfPs2RjI
	 3xIH75urnNvoSBrerS9BTFvG6YC/Je9t7e+X+1GnVxZYu/ufKwUVhcCjXgNvUAquDT
	 KLJBEImtE3JITakWZ1fycKSFh5M6K9x5uSWZLKM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0547/2151] clk: starfive: jh7110: reject oscillator lookup errors
Date: Wed, 18 Nov 2026 15:38:02 +0100
Message-ID: <20261118150141.894623265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 52833d4241c5f..39a95a32e9a02 100644
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



