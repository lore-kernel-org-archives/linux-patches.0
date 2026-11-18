Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033599;
	b=VSGWuEMZIZ5cXYSEp5MCyi2CObkLWf4OhtdtPRV6sykpWjpgOS18YYzd9awKZhla59DE
	 jBKAosw/VCRDY6RAu/XvGoL4uZdgDMIT7jh5W76Q60YkB7K6d0ecat5zjsiPtLjsQc+OM
	 QcHDqsMp95iag2YafHDT83Sx6uRnjxrSrhgV5K+loIa+uRF7sM5nCLbdE2E6hsiB3+/ax
	 uQfEfc0vcdPaDjNiHbz4uUrW8EegpM3OhMXWM7nEiBisCQugBJqBHduRQcMWveUOPZCza
	 /+ae+MqEDBdPN9rghFQjTLbDJPUtlUsV1HelmmRPeX9Fl0V8qJaL3YXLewed7HMBpew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Of7iC3q5Qf77j2labIdrbHi1D+42EI+kmoUQyPw6Liw=;
	b=yEJjAUatshIiOICy6LNPwJkd2qfVhANX+XT9ygeirGiXj8+ax93hmLACLvnjUOtzXG1U
	 2/BummHNzUW479Bq81mko5SaL6OQ6h+KN/qSHgwhulG/kbbCNySigJ1UJz0rZkRMsx3bb
	 zkmQuciLLVb4CKP/10/Brqbhd9QkqaOEu1HLWtx7xsioAwKCOw8Ni5TKB45dyibymgig+
	 0MFtlAABdFKlTh+wcqnankqLZm56bNDfSdi3AxDEuwWEsF6CODAwuwZGMs1EZrA10LVLt
	 ExK+2XzSQTpcK0IpsWJRB5JvJa8JsLBTxnYIDaJbSLo/G65fUE0hl6/mIVw8Wo1ia5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CL3xvH9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17A0606A320;
	Wed, 18 Nov 2026 20:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CL3xvH9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E4A1F000C4;
	Wed, 18 Nov 2026 20:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033599;
	bh=Of7iC3q5Qf77j2labIdrbHi1D+42EI+kmoUQyPw6Liw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CL3xvH93Wbu1Xrbjw2XS+HWHW9Q3NuIu/Q33sdYaZEVD3ST4PqMwmZkJUpvlNaUG
	 hwzbfIUpUI/8IlMD4Uru0y3FuCiv9lGMcc0EcVAnaKUqrMRg0+eZRu8YOKtT4gQbSC
	 U084Qoeu97RegTLqo+M8rUxxFbyoyjEZ67OyAE3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Theesfeld <william@theesfeld.net>,
	Brian Masney <bmasney@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0030/3318] clk: zynq: handle kasprintf() failure in periph_clk registration
Date: Wed, 18 Nov 2026 15:10:52 +0100
Message-ID: <20261118150314.696307002@linuxfoundation.org>
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

From: William Theesfeld <william@theesfeld.net>

[ Upstream commit d4d0d335e8d37c6c7e1c5664c7664288eca5a09b ]

zynq_clk_register_periph_clk() ignores the return value of the two
kasprintf() calls used to build the mux and divider clock names, and
passes the resulting (possibly NULL) pointers straight into
clk_register_mux(), clk_register_divider() and clk_register_gate() as
the clock '"'name'"' argument.  On allocation failure that name later
gets dereferenced by the clock framework (e.g. in debugfs name
formatting), causing a NULL-pointer dereference.

Check both kasprintf() returns.  On failure unwind any allocated name
buffer and the spinlock, then fall through to the existing err label
which sets clks[] to ERR_PTR(-ENOMEM).  Freeing the spinlock on the
error path is correct here because no clk_register_*() call has had
a chance to take ownership of it; the success path intentionally
hands it off to the registered clocks.

The neighbouring zynq_clk_register_fclk() in the same file already
uses this per-allocation goto-label cleanup pattern; this change
brings periph_clk into line with it.

Signed-off-by: William Theesfeld <william@theesfeld.net>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/zynq/clkc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index c28d3dacf0fb2..db40a9e7dd3d9 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -186,7 +186,11 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 	spin_lock_init(lock);
 
 	mux_name = kasprintf(GFP_KERNEL, "%s_mux", clk_name0);
+	if (!mux_name)
+		goto err_mux_name;
 	div_name = kasprintf(GFP_KERNEL, "%s_div", clk_name0);
+	if (!div_name)
+		goto err_div_name;
 
 	clk_register_mux(NULL, mux_name, parents, 4,
 			CLK_SET_RATE_NO_REPARENT, clk_ctrl, 4, 2, 0, lock);
@@ -205,6 +209,10 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 
 	return;
 
+err_div_name:
+	kfree(mux_name);
+err_mux_name:
+	kfree(lock);
 err:
 	clks[clk0] = ERR_PTR(-ENOMEM);
 	if (two_gates)
-- 
2.53.0



