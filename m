Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062412;
	b=rV8PbYvJ3IMQhqgR29kbx43cB6NnajoqPMD1+gJYwbyivxpIv3oUf67KQ/e0vOANm2nh
	 nFArJfFJWf8AihZLH7oBYO8SOegNN1OKqTOKJutlrBY4pYqtOu6MF5494S8yPQ91HWZta
	 Ue/hBvulHuzW0QC43BfczSKXbs8Q/KEXB7Am16g1+4AUIAB2ONtcOe6dXHMYLah311m2T
	 etWtEL+HjjzYL+aYa5Qb41dj8txj7M8VGWhLtSDTp/uAtjFyMAZPEO1bSbwG3hLR8Tse9
	 JSNJgNvQ5YBaLyfvJCIAq4/IkUWK0ZBGhNs88iBV25bRRMt9VgLdfIRT2qp+zoyrLvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+JWIsF9zgPPvn5dbVRPXwu/C7Ssj+Fy8NJTznMkNn0=;
	b=2yXeJmrxrFpjjIHCaZ30A2yayopRtAJA5gUueLAFeYtz0VvUucEXuiGTjswGBQ+EJtL2
	 EFRrWR/636SGLKG8dytQTrpwkFWsnhChgDl+5mnrufp6i51zWjR10Tj30TQpENErJr4cd
	 Bf+rViLE3m5mqU6MODm5/Izd0uzXRO9HTUGix/CXnfZRvZ8ugXmYDz33EFh6LuxWvJJ2Z
	 C2jiyggTls0jmX86i8SOsERAFEK43Xh9W7Xzo8Tv8wS7cKdfD1RybZEK1XL36GW2fv4+W
	 pcG92r7KD7arRv02UNhHs6By0vBjEMtO9XyoY80oKRos0fFkLZ2i2MHRy0ZTOp/kPHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Op9tLgx5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3503606A334;
	Sat,  7 Nov 2026 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Op9tLgx5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612CA1F008A1;
	Sat,  7 Nov 2026 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062411;
	bh=M+JWIsF9zgPPvn5dbVRPXwu/C7Ssj+Fy8NJTznMkNn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Op9tLgx5ju7+34n7vGz0WyUMxndsXSOqBiCZ28PTji9QAeVbX5suOLzBNV4/Dpfgj
	 xJsU+tATBsD7AJuo/e9JaERsOA9ILoDqUKznbxNENrStdiXqONF06Onjdp5aumnZew
	 26MxgHCNs5hOyKc0pgJQ+bkAYNly10ruFGThlUBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1328/1536] ipv6: defrag: orphan skb before queuing
Date: Sat,  7 Nov 2026 08:55:44 -0500
Message-ID: <20261107135035.117001766@linuxfoundation.org>
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

From: Zixuan Chai <petalzu987@gmail.com>

[ Upstream commit 5dfa91a5ec53cfbf907a1fca095ac3ac7a4e94c9 ]

IPv4 and nf_conntrack fragment queues orphan skbs before returning
-EINPROGRESS, but ip6_frag_queue() leaves the socket association intact.

Commit 18685451fc4e ("inet: inet_defrag: prevent sk release while still in
use") moved skb_orphan() into ip_frag_queue() and nf_ct_frag6_queue(), but
missed ip6_frag_queue().

Without orphaning, inet_frag_reasm_finish() clears fp->sk on frag_list
skbs but leaves fp->destructor set to sock_pfree. Freeing the reassembled
skb then calls sock_pfree() with a NULL socket. A socket using
SOCK_RCU_FREE may also be released while its fragment is queued, leaving a
stale socket pointer; this is a second consequence of the same missing
orphan.

Orphan the skb before returning -EINPROGRESS so the queued fragment no
longer retains the socket association or destructor.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/5c396b7011168cd98b9812df4d6bbd00a96048e7.1791008591.git.petalzu987@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/reassembly.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index e8e58875fc726..29e15ff9d7c1e 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -227,6 +227,7 @@ static int ip6_frag_queue(struct net *net,
 	}
 
 	skb_dst_drop(skb);
+	skb_orphan(skb);
 	return -EINPROGRESS;
 
 insert_error:
-- 
2.53.0



