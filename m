Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060644;
	b=K1oOqDj/tt+LCwByCrWwRjp83Zy+CpAuMLKA+VQcGymEf2lv510JUK4lPcJY/onsKjJn
	 ZfECEgBfKQj00lpDCy6SUUMNi5XV+Ryyjc4iKXgvhgeVgfP8TbZUeajv1vY2RPz6AyF1A
	 I0veujbeDHXVidiku4DchdgKbiXdOGDeIl6whoD6i4ruznHZ6HijkwsZ6GvO5ts5yPile
	 Ax58MuF5obyECpIFVXPqYX1yrjvpAzGGVeYgzEK0r3qUmAJOjkKQqgkOyVP7Zcbwht6mC
	 kfYab0HB1LoxZVQ+kbp0g0FoXZKJXvvaug8x1SYYTPygW02/96YRAXyA2JaaKvZGZLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4kwAPLk7muMpPrr/d7bSBavleRq4VozvMwgCbZf2e4=;
	b=QJTPeN9PExOMpAtdECd/9l83zHKple+LFljwD24TBClHkCVnVLQrd7kx+RKEPOBJC/+N
	 oK6vHjuks3PdFvlnFw1L9wjbxRGPyLMvKH+JKppQTmKdkAAzz45aVRtAE4OV1KsHSdO65
	 iXn5aCyOLL+iPZ8Pj3nOtoYL/D/YUyzL4BS7YW7zvwL1GzJ15cVDoCpbnWEHrgQEKj+T/
	 R2cG9TJiORhSFwdNCd7pR9U2+KADfn0Frbtpgb+ZXb5RX01ZWYoAAVUDpiXMH2Ry1GAbu
	 JV8vc9UgSokKRNHpHMaR6g9T3QCKnru4FcA9vQxgdebQXJEwIxjsz22PVTM6dqphKvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzGzGkoJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F000E606A326;
	Sat,  7 Nov 2026 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzGzGkoJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415E31F0089F;
	Sat,  7 Nov 2026 14:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060643;
	bh=N4kwAPLk7muMpPrr/d7bSBavleRq4VozvMwgCbZf2e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzGzGkoJHWe/SpJhShw/r8mw3eGDBnvC8XrpJgTFw6t4GADHfNCL+Di/lqyTm7CSa
	 z9/ogaq8V3QlWsfZRflMMnP7KsVByolUgLsbvbBO6OhNMVdFHTz6DLlvtuRJg7pSMj
	 S7T/37cM+eZr04lW9pTYXxfnAJ3kmnjdDN0lFsdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Theesfeld <william@theesfeld.net>,
	Brian Masney <bmasney@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0036/1536] clk: zynq: handle kasprintf() failure in periph_clk registration
Date: Sat,  7 Nov 2026 08:34:12 -0500
Message-ID: <20261107134958.678077867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



