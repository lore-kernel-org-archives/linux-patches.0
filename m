Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058775;
	b=YOX9f+Nge0MpQu6ukAFLevTv/tD9H8QRoFQ2H7DBFLP4Uer44YNhpHMpA7udVnEktUQ5
	 +KScPcHM+1Hz+S50Tf1Jf0g++7rmF2mQtugXje1KvebNTwpum+2wf7I79R7BfHdw4qGZO
	 wwEXTkKWQ4x2doFMRwPCATxlNDX87msnoRxXftTROGQweiKMAAiGDRmFGDPx7Ks2C7j0y
	 +opmACi/1ZOuc5i7J9QJkyAEQu6VTnuegrFAqNWBWOjmSp/Wbu2547fG6Bzh88PbtFBhm
	 J2OpQjuu4KGTKK3k/gAaoReBpwus8gGd5o8z2Ux+PqNG8T/u+lUz7FEqCi5F3DnIseg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AO9D/KowG2Sp8z181VIC5ymdjm08emxaQ74Otn86dvQ=;
	b=1sTfNp/tEmg3piHOzEGBC3rmvfrygZ5twkj8d/4nyQnxGdRA+5GYstgyTte8yoizmH2x
	 TzBDEdSwIE1c+/DJM8izHla1JgPZI1oZoVDaBStI5/Xo8XOx1MeV265KfbHFpjR+JU2LH
	 AQXc3LVvrm+oA0v9P0HhSP2/014xcyuaCIxxqrcRt4291Fx/+8+edqwM0ePSL/tmsIkmQ
	 nVuxKb8s28D4P5o0ZCq1TJIuRCiZixSe4FL/m4X0tMBtdupaImwCozYXh2JCCu00tP3I7
	 nEM7c20dthO6mvSjUPFAGtYzlxoDCYKL6UlX3GFXuESrAqC9eEUkiTCG0wi7buHxx3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uOwS6wX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D006606A326;
	Thu, 19 Nov 2026 03:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uOwS6wX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3DF1F000C4;
	Thu, 19 Nov 2026 03:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058775;
	bh=AO9D/KowG2Sp8z181VIC5ymdjm08emxaQ74Otn86dvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uOwS6wXJZItplbtqz9OJmxnlW1zcrivSWJ/vB9gDVaQynqdkLIrC5zoGtReNmWWh
	 ZfKtw+WIZV+dnXx7z25LEbfZu8/dSe5a0JXUZYkQH2dFCA/CVoLKURVtfdm7Hkm7cX
	 Rm1bTwHG8NR/mIOOhZMmxGGSQ24aGH+DmjUKtlmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0605/1848] tcp: check congestion control restriction first
Date: Wed, 18 Nov 2026 15:44:03 +0100
Message-ID: <20261118145940.677818274@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit dda51b73721684637ab8e9bd97c78228b99c4bd2 ]

tcp_set_default_congestion_control() takes a reference to an algorithm
before checking whether a non-init network namespace may select it. A
rejected request returns -EPERM without dropping the reference.

This affects module-backed algorithms too; BPF is not required. For
example, after root loads tcp_bbr, a user with CAP_NET_ADMIN in a
non-init network namespace can repeatedly request it as the default
although it is not in tcp_allowed_congestion_control. Each rejected
write leaks a module reference. Since module->refcnt is an atomic_t,
2^31 such writes can make it negative; later module_put() calls warn,
and rmmod can hit the BUG_ON() in try_release_module_ref().

Check the namespace restriction before acquiring the reference, as
tcp_set_congestion_control() already does.

Fixes: 8d432592f30f ("net: Only allow init netns to set default tcp cong to a restricted algo")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/71c142b2d45af6a2fe7fc6cd4a5ca52c53afbe23.1793075984.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_cong.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index db5831e6c136a..4185cc5c87d18 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -228,12 +228,12 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 	ca = tcp_ca_find_autoload(net, name);
 	if (!ca) {
 		ret = -ENOENT;
-	} else if (!bpf_try_module_get(ca, ca->owner)) {
-		ret = -EBUSY;
 	} else if (!net_eq(net, &init_net) &&
 			!(ca->flags & TCP_CONG_NON_RESTRICTED)) {
 		/* Only init netns can set default to a restricted algorithm */
 		ret = -EPERM;
+	} else if (!bpf_try_module_get(ca, ca->owner)) {
+		ret = -EBUSY;
 	} else {
 		prev = xchg(&net->ipv4.tcp_congestion_control, ca);
 		if (prev)
-- 
2.53.0



