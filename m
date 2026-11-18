Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042916;
	b=WNrL59lVjye2PdbKI63vvfK+ogyz3fxXEOuTKXT0jYF2XmWQTk7DMPP/ve5AzR3WETYZ
	 bSUV0KvfDB4F/snTga2XIof0nQxD2DAgRhqQTLmVg6VHI/clpk//fVq9wvdmLcCJOd4Zn
	 qSFBW+wMGad7rKipg16ufifBVXWE8O5kEsHrAQMmea5VoQF4jxfCDp5Gr+PTQs7gXOWpv
	 hj6iwL72D6rMrzhTOfDYhXoMZGFxbdtoKCl1yC1n3vP6xdHK1Efs9ghOEql0WVMtlAoQ4
	 uzABRqhz7ZQLgnWigT8aroXHVwhMxCIWRDGNF3PNVyptqYUDDWNclYWeR9obgmIHPZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QXv/maN3lqRh49AVLKE4HQrBfloh6x9RaizxM/uBS8Q=;
	b=WWXNipuRCwuzNT9+9uyz99d9O+Y1ecKGSSBlrinTYRJuqwapCQkfjDog/ksY584eo3qg
	 q3gc40UQ9A7t/jr3TU7KBk2AaE1IAwjRihpWjQEEW/gL8nzNWyWpMl4K2QgWFbkIOtHlo
	 +xYj2rqYW4REOGDMDpAL2usbsJ+nhJ8E2kb0xzToQZRdnxgx/Svx54Wnyn0aaxYlUH0kN
	 PuM3T0czTcE7AxGJ4AaGu43WO4pqEabJ98EM4ccY0r0xZeaPDvIouPyLZZMUe/GrbvzI9
	 Z2sJk/IoTZoXpMqkSkTv27P3LMjCXkoOWUtz0+y6dnDxd5RJG5OSw7hudGF+GrdPrCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD26QiJz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A313606A31C;
	Wed, 18 Nov 2026 23:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eD26QiJz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EEE1F000C4;
	Wed, 18 Nov 2026 23:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042916;
	bh=QXv/maN3lqRh49AVLKE4HQrBfloh6x9RaizxM/uBS8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eD26QiJz8TsWwZM43CSttIkdqlyBixu7dA/K8hCbuxjGKo+vpy8vNMvYwDCrIW3+w
	 CVbe0PRUX/gXyz5hDoo5njSMzbS9NW1DA0j9Z35BWIoU8MlLeEfaVHy660l7mg8dAS
	 b1C96/fBQ0rI/rhIhZxAML1oGnpk525s7779ChBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Theesfeld <william@theesfeld.net>,
	Brian Masney <bmasney@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0026/2857] clk: zynq: handle kasprintf() failure in periph_clk registration
Date: Wed, 18 Nov 2026 15:17:40 +0100
Message-ID: <20261118150202.301364956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



