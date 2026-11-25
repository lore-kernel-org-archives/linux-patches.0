Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619295;
	b=sB/Z8dJQeuJNGcIlaHvJg7Ub3lfxhyD0JHzahk6PROhahzi1XsiWLAj+zL8/0ppMLC36
	 gY2lXK/1qK0l6pKxi3XR7m77N1jWzfXOhcexbfgNaDEk4QHTHdA85S1xvZxeOijNAJz3U
	 bDa0W3bF52r519deXQtX78Ftfh10FdWg75MqywnLC6AGKEKrDjzt96mq18/sGhiEQBq7q
	 5KJcPQJuQAOAizZiZpx8psBwHYNnVrugpz5L8U0CgAyA9u2n7tWsObed6+jeJ8HGb6HhB
	 I3Uwf1DxWcwJrwHnMib8DDr7eNQjGauSb2WyipThIxrXbwWnvqJ8+5uGokkASFTkQZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OfmxFWcXRpw09LwUCzpoxO+8EYCpn19Ugdpd0op+TV0=;
	b=BAdxJEA8FLXJ2K8M6JmmD3fCvJB4RVmgrHk5iiijFY90BVxQeP9EhEmF8eMrfYUSLRGv
	 KKVsTmxjM/j3jU7Sjg4VYxqI0SSMGaPvQ2O2wEkYKm8cdnSR+PvE3wEXnGqD16OrIibdp
	 Kw03lSd0qJr9jzIrq4nwuJE08UbpZTArwiTz9m0UfcHT4Mwv5idm1S6f6ALPU8neaRJgZ
	 wf1JqaN+uDaMWihJIka+FEPmq+T+Ody/AZENb7xpMhJAeW/L60wpxGmIGyc01PhBHilbo
	 nckbqN44s38Q5OVs2cumj+HAoVOBduVem+AKSbGNRX+Q8EOLh4ReqYUGQt+mHJ17AZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXc5XVIk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052F606A32E;
	Wed, 25 Nov 2026 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXc5XVIk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27E81F000D1;
	Wed, 25 Nov 2026 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619295;
	bh=OfmxFWcXRpw09LwUCzpoxO+8EYCpn19Ugdpd0op+TV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXc5XVIkbDTroApC0LEJHnaR619q1Hvlt0i34PlVtF8tf3h0u4iVBGAmbwuSrqmTt
	 zgJ5SJnm5iLQvmgKYUeocrGcnRygGlt9JNtwl75ps6RVhj67uNh05aE/uGxQ9sCpuE
	 JFcjv1odrnQs3L0EEr2YRBS5NfXoUJf2daKpym9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0506/1005] fou: gue: check IP version of held packets for direct IP encapsulation
Date: Wed, 25 Nov 2026 15:30:44 +0100
Message-ID: <20261125143833.598534175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit c59f004734a2a7c0e427011db13aca524e781498 ]

For GUE version 0, gue_gro_receive() compares the base GUE header and
its optional fields with every held packet. For GUE version 1 (direct
IP encapsulation), it skips this comparison and selects the next GRO
handler only from the IP version of the incoming packet.

A held version 0 GUE packet from the same outer flow therefore stays
eligible. For example, a GUE/IPv4/UDP packet can be aggregated with a
direct IPv4/TCP packet, and inet_gro_receive() then parses the held
packet's GUE header as an IPv4 header.

Clear same_flow for held packets whose first nibble does not match the
incoming IP version. A valid version 0 GUE header always has a first
nibble between 0 and 3, so this also separates the two GUE formats.
The reverse case is already handled: the version 0 path compares the
whole base GUE header, including the version bits.

Fixes: c1e48af7960e ("gue: Implement direction IP encapsulation")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261106195615.2498766-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index 076fdca44f518..5c3c8f55d0570 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -364,6 +364,18 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 		default:
 			goto out;
 		}
+
+		/* Match the encapsulation format and IP version. */
+		list_for_each_entry(p, head, list) {
+			const struct iphdr *iph2;
+
+			if (!NAPI_GRO_CB(p)->same_flow)
+				continue;
+
+			iph2 = (const struct iphdr *)(p->data + off);
+			if (iph2->version != ((struct iphdr *)guehdr)->version)
+				NAPI_GRO_CB(p)->same_flow = 0;
+		}
 		goto next_proto;
 	default:
 		goto out;
-- 
2.53.0



