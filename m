Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026337;
	b=Ac19rKOx+NvNqjPdvCaLpyetBXe/ReBYCBZdOWo3w6fC/IfaRQmDZqO7EN0vMFrC0Y6i
	 Z1dN53qyfW+OT99MuxQbwdQcrAr9ePSFBgyzE94bmlu8v0k++HPkCmSDCxxdGvQ6sno+c
	 UmEwqDSeKt+zOkUFYL/0RAwmA9//53hTzk9Cmhx9IP988V89X1P9I8Vnn3g88UfcmzPP7
	 mIBOBsBKikTLb7/ZQam8KCqWXq+kLVLlYEMnAd9TLvCVjtWPF0aTW3dUjIpHQ5O96pWvE
	 DdZhqLZG9kua4blP4mN82CXYxmsfa9BRKLu/lrqdkQ3w/RkKbeSH8KkDZWEkAlDWIXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJu6RiHjP5Vei5/HCnrMRFjJtKD+QBxhP4pGFQOaMB0=;
	b=hSkh9gVE9O3sgxh+S4/UE6brSJTJfURi2sbxgV6E26c5PQkESTMwZ3VjKv1zW2cRLy94
	 f/j+cb9BCoua5pBtKxlGdnw1RP2swkr9mB0Jnl+/ZYCr2HBpsKivVuPdB7sCluQ8EvGaG
	 cblJKS3XJHZSB1Dqi5oDKd6Z0fvCXpygyb5fUUIi26GT7SV0Epvi5PM95deM5w+mpRIG0
	 VsmMS940Qwy7ZlfYY1uDDYM86kYS1SnMpACYlHTrGv9M8+PwyUPjQUTde4MdO0czLpk3g
	 aBG0YLzG4wi1lb3Eig5m/vnGAzVWWY+aokIFbm6gpaHL6oUCeiSrU1npBSPuutg3pUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeFYdaS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEA6606A331;
	Wed, 18 Nov 2026 18:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeFYdaS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5AF1F000C4;
	Wed, 18 Nov 2026 18:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026337;
	bh=PJu6RiHjP5Vei5/HCnrMRFjJtKD+QBxhP4pGFQOaMB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeFYdaS4f56Nf4x/xtr2ijK235NVS2aLsafJwPWgWei5hNf1+sxd8PO1hSNIs0mRO
	 WS7oInMWtIzrlu6I1FllXLku1IzBhdTVpJrTXRR2pPqYdkDgZh31uUBwP2ymv+6RLw
	 YZ5SO1vGtuX4JoyuELd8mWim5r9K3ULbxy79xDt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1399/2151] tcp_hybla: fix divide by zero on rtt0 == 0
Date: Wed, 18 Nov 2026 15:52:14 +0100
Message-ID: <20261118150212.957165767@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit f09eb97322b16a6f709a47599c95b62f786905f9 ]

rtt0 is the reference RTT in ms, so 0 makes no sense, and
hybla_recalc_param() divides by it right from hybla_init().

Reject values below 1 when the parameter is written. Also cap it at
U32_MAX / USEC_PER_MSEC, since rtt0 * USEC_PER_MSEC can wrap to 0 on
32-bit. An rtt0 above that (about 71 minutes) makes no sense anyway.

Fixes: 835b3f0c0d7e ("[TCP]: Add TCP Hybla congestion control module.")
Fixes: 740b0f1841f6 ("tcp: switch rtt estimations to usec resolution")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008092641.140777-3-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_hybla.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_hybla.c b/net/ipv4/tcp_hybla.c
index abd7d91807e54..b9b482180d30b 100644
--- a/net/ipv4/tcp_hybla.c
+++ b/net/ipv4/tcp_hybla.c
@@ -26,8 +26,20 @@ struct hybla {
 };
 
 /* Hybla reference round trip time (default= 1/40 sec = 25 ms), in ms */
-static int rtt0 = 25;
-module_param(rtt0, int, 0644);
+static unsigned int rtt0 = 25;
+
+static int rtt0_set(const char *val, const struct kernel_param *kp)
+{
+	/* avoid rtt0 * USEC_PER_MSEC overflow */
+	return param_set_uint_minmax(val, kp, 1, U32_MAX / USEC_PER_MSEC);
+}
+
+static const struct kernel_param_ops rtt0_ops = {
+	.set = rtt0_set,
+	.get = param_get_uint,
+};
+
+module_param_cb(rtt0, &rtt0_ops, &rtt0, 0644);
 MODULE_PARM_DESC(rtt0, "reference rout trip time (ms)");
 
 /* This is called to refresh values for hybla parameters */
-- 
2.53.0



