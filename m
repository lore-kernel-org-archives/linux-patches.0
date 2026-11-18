Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057162;
	b=Bd4Fk0NLvpacfJruy0yEy/zm7qwR9/1Cl3WggxbF4Z/VSbzoqr8cC6A29g6eCeuVo1Gx
	 zwbJf5rhw/aTWFDqj+oO1ziRarNyUU8Kbs88tQ3wnvjB61gDuJkB50c119QawVIT229sR
	 iLf/zkOmKcbXnDql4N6oqHwOgS9vb7QJJUmaFfHSL4KuUwy3QBUbUPEDatGF6JhV1xphZ
	 5dzAC57hF8i3Ou4yqvCnYtJhLC2+/+BgaxL22Dh5Kz9z7Px5saYcJNEW1vTymFJiXMPFc
	 kjK4FxCF3hsAAhke+RzNo9gycW1P3g10N+13fmDBqtW2n0R5uPcK3DUciYW01JM69KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5z+W9xCtpzyU5cpYEOu6rv5kpr4PkOFNHno43g7S5rk=;
	b=0Qloxd3IjJI5henjQFVlRbxV1w3WS6O6W/pEvdydkxxDMv+4ZthQscwYlVYyotFsiotZ
	 zDs4nyZ6J+kUEbWIX80rkYmrWb/DzUlb5YAHPSWC19+4/VYqQiaixua/SVFvqsPUTEujL
	 73HE6yTpJoY/gQM4KlQkdVoajLmnVk+QFHEYQILeXp15+QRkwqzncB2LHXrZY5QdjN8XJ
	 ry4eHoqTN8DQ3C8ZvbTwoK2R4wpS1mJ6s87AzPT0Q/eUTCVXkkxsWSxBRv8KyKHEyFVrA
	 OO8AvW4yw2RzwzuJbA/r98GrMySyFzjc41VzJd2Fl8/a0nKH4nU+He1cQrQJwb8OO+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sV+CYO9T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C469606A31C;
	Thu, 19 Nov 2026 02:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sV+CYO9T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5B31F000C5;
	Thu, 19 Nov 2026 02:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057162;
	bh=5z+W9xCtpzyU5cpYEOu6rv5kpr4PkOFNHno43g7S5rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sV+CYO9TrZ1N9Cui2PgZn6prPAMEvXqKF4oCEEa++a0V/RkUEN//0f1TNDkUdhxyl
	 Z+2K2L7u02uVWxDfVQO+4XWg1+SY3tV89KbsO4wJn72gicdQdUL3bjYp/QfbY2v+v8
	 egLqkTzuoGlKXcOBk5GOd3PSJT1yW4xbMdGwL4s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Theesfeld <william@theesfeld.net>,
	Brian Masney <bmasney@redhat.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0033/1848] clk: zynq: handle kasprintf() failure in periph_clk registration
Date: Wed, 18 Nov 2026 15:34:31 +0100
Message-ID: <20261118145912.558269085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ffbb9008c1c99..440016e90b091 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -187,7 +187,11 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 	spin_lock_init(lock);
 
 	mux_name = kasprintf(GFP_KERNEL, "%s_mux", clk_name0);
+	if (!mux_name)
+		goto err_mux_name;
 	div_name = kasprintf(GFP_KERNEL, "%s_div", clk_name0);
+	if (!div_name)
+		goto err_div_name;
 
 	clk = clk_register_mux(NULL, mux_name, parents, 4,
 			CLK_SET_RATE_NO_REPARENT, clk_ctrl, 4, 2, 0, lock);
@@ -206,6 +210,10 @@ static void __init zynq_clk_register_periph_clk(enum zynq_clk clk0,
 
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



