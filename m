Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056099;
	b=eM9Bu0vHCN0QRiNYwNdvb9V5dslf6+wHqjrwZC+HmAIJNgPo/kI1uQGA/ZXnlaZqBlO6
	 xqtz+Z348UmoDvaN2tpME0LsEM8VTZjlIZGmEnATwY0KTL+0smwaG40DhC5rHC+qpq3zi
	 8xDYOtH8PS+Acc5cUMBj+3yIscVlJnmXYmtpxc/PVYnBw+3jbBCnGqDrh6vWvWL2tD7Wu
	 e9mgY3trgLCiGmLftwdpsqjflmro1HsaY8efKipaPsyoII1+K12ZT8KkOJr/iF0sQuYAk
	 2r45zFCG9fgX+li92GveHI9KK7L3bVF8LIlLGL9zgqTaC/MYCYU1t39awN6hSdz8BFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s/Nt58cJyrSulLWHamleDxcAodN0cqpid/OkzUc/HgM=;
	b=jzI+6RUbiYPT+x/26xqG2lFlMd4U3KsbwL3lTFwqM9rdzCHnH+59hahgn7HWoC9xw2w/
	 3dQh4NVTWZsYnOFh6fNIFQmabmMsBjHQuV3wWXkhxVoSdGkyO+Wt0XkO/xModDOFfiSBF
	 +XrT9Wxc4p+ozghuPdnQhYjkxoLUag2GXQS7DCa7UZO1cRYidn0RZ1tw9Enz2Ss+GGP1p
	 uqIQUkACFEPmwuWPWacOZAF5WlUwftAc1O+GlM9FFc+Ymrj2Id5M5l4kVOGLGu/kzyFMI
	 b2RVrknXIRieP9uDmwNBxKHw8UNU1UK1qYxkxZR0TDKK+qR3+ZT89yJ7JEpNS8K/lqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OjZR/Ehq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78734606A31C;
	Thu, 19 Nov 2026 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjZR/Ehq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4A51F000C4;
	Thu, 19 Nov 2026 02:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056099;
	bh=s/Nt58cJyrSulLWHamleDxcAodN0cqpid/OkzUc/HgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjZR/Ehq+CnSPpmqEs73F+0VDdZS4p/iKarYA4S2Rx8fA6Gyy08mDIqUmD7cyR/5Y
	 dSKKrYMo3yJcyscL9TL8UJ9aOD7Pk+bcDOy+W3TYIvXB8bxBqTbFENaWt7SRFbIic7
	 sHSsz8VjHNBQ4lnekj2I5ejskeGVLQGwqmf6wkAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1868/2214] tcp_hybla: fix divide by zero on rtt0 == 0
Date: Wed, 18 Nov 2026 15:59:04 +0100
Message-ID: <20261118150126.030124721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



