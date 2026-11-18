Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061521;
	b=d5YQ9UzUwkxwCg3D1WOzN3za3HamsGzvZmBgxnQl7qu8l7nZKso3Q/ZssvjvRv5UFhqc
	 kou6b+cqJKIeHAvt3vvrB1XQx91s5kiWei2KX1OLYtV1zWQ2kiY5KxT9/KO3lm8ygMwVA
	 s1Sh6/CAC/eQb9pu7ZTwxXwI44+CHScqsEfA1Mv3kaUARhghTStHBaDxASuym8mTbX5CL
	 uC0AXwn8anmAKzoAt3cruQoUNaIRPwEHHydMEzaWfyFKR6ESo9QW+qvDDufw4+RBdiLSG
	 iU5wdN80g2yb8qOsPVWOVgp3uRQlZf8NotL2bDwv6BUlh38IosqxqafoQUFLb7oc5BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=20JLRJN5U3n8ORKj2Pw9ar22mTZBFgiqhOd46OOOzXM=;
	b=rNaULZ/i1VMR8h8QRVVP2kT6RkRCGCK7yS1usOhvMeF2/atviCwA++FJ6eLFKzLHKwT9
	 gjfrbBBOFCpH7QtNU5Jr83Or/dRxf2C4lhySZFTDOCSM1Y7FnVAfL7qgQVEVTg7zjkuuS
	 Ef5OPlsv8HEmrzVNfsxnpFwssFzVDnX3YEdIhhe4nJ0wYRzLDVn6O4iMSz6XgfuCnGpCv
	 qNR8Kd3GsCN7CPPWZzC0mqUTZWdKbym+J0aBWnYNcyUBTFYPPjo7HYwD3PrW7PtCgxt2u
	 Ru/zS+Di/jsyOq+cRpKY5FgFo6FSMAUVb2sWB/lruNIearkn0IE0Tvq/GXOu7J/tO1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhQ4WTQz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15C5606A325;
	Thu, 19 Nov 2026 04:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhQ4WTQz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDCF1F000C4;
	Thu, 19 Nov 2026 04:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061520;
	bh=20JLRJN5U3n8ORKj2Pw9ar22mTZBFgiqhOd46OOOzXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhQ4WTQz9Z/dcIg6+Ceup/NAOxFHsI9j373zvJiHOI81/lWBAmR4lDBPKJoPUy224
	 yH5Cv35xqgKBct4KyBBal7zdirIxkAzCm4CsvojhF7islTUiDzWFUuuqWlF5O+OYSz
	 ThZngXezmNvqmAMrEG+V8xH+IgK1dJbZq8gw1KEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1581/1848] tcp_bic: fix divide by zero on max_increment == 0
Date: Wed, 18 Nov 2026 16:00:19 +0100
Message-ID: <20261118150025.755610748@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 8edbf6c23363563e508a61f3f26f4e4b6eec9dd5 ]

max_increment is how many packets cwnd can grow per RTT, so 0 makes
no sense, and bictcp_update() divides by it.

Reject values below 1 when the parameter is written.

Fixes: 83803034f423 ("[TCP]: Add TCP BIC congestion control module.")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008092641.140777-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index f5f588b1f6e9d..c2b602ff04d4c 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -27,15 +27,25 @@
 					  */
 
 static int fast_convergence = 1;
-static int max_increment = 16;
+static unsigned int max_increment = 16;
 static int low_window = 14;
 static int beta = 819;		/* = 819/1024 (BICTCP_BETA_SCALE) */
 static int initial_ssthresh;
 static int smooth_part = 20;
 
+static int max_increment_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 1, INT_MAX);
+}
+
+static const struct kernel_param_ops max_increment_ops = {
+	.set = max_increment_set,
+	.get = param_get_uint,
+};
+
 module_param(fast_convergence, int, 0644);
 MODULE_PARM_DESC(fast_convergence, "turn on/off fast convergence");
-module_param(max_increment, int, 0644);
+module_param_cb(max_increment, &max_increment_ops, &max_increment, 0644);
 MODULE_PARM_DESC(max_increment, "Limit on increment allowed during binary search");
 module_param(low_window, int, 0644);
 MODULE_PARM_DESC(low_window, "lower bound on congestion window (for TCP friendliness)");
-- 
2.53.0



