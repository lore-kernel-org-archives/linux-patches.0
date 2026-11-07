Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064936;
	b=jRkVTRbf6TF3KeG1feK2En5hlfMvhS+vWaxxK7LZquZmXIk1testQGDHNt+lzj7Rzzik
	 CWOnZBICyT/xl2uNWXqfoaRzkS1fiEJ0NqXwoddnrGPli0Jm5l5xX9DLZipA0KkU0o0Tq
	 fWjTFT9o8uIfktk0N7JAcbtxFi5B2ACuNfoNosV8fI4NL+E/ZN47lzE3tIqpKybQRFWEm
	 2erwOc6sCj6D4vv/gVSjFDZDjud6Q9aiW5+HyRU/qLboK/elyKG+ghmAF0k+y90TfVLm4
	 UjCRcHenZ2gU08F5nNjBONxlVse2gSgdjvZ8sNwiQ9EL25eHp6011y/arei8QFkXNaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZNtodVlmHfnacLmlylRB2h3OKDo3SlRX9ttTbzCkLdo=;
	b=HZZ3ksg/xIlASVw387/NfdT93Sv6Y/tUkchpa+ELXxH4ZVTm5DgmmhNJSBteDJ9+w/iX
	 BFYCRTz7d99C+eDhlKG367LTH+kEoJ0D9bOFfhUlFoZQzKMAVnvOgzrQVolk7N9R0LKV1
	 ElDIRNANU66c6dWND9R95gpIS5ElKl2FnqEpFq+Rvd9uY8+XkYTXX2xnEJxnGaqzpKy2m
	 4QqiFXwgvRs4up2PrzFema8C4T6mN0fbbF5rAmU4BFlAjdA5G0W2n76OehzvH0Gm/Hqdc
	 WtSOEohz8JfJhIQdn0eVbHxEJD8ypysivBmPUaX/TYN+NMjrbhcwqstI0eW7AcXPEsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tFZCZqR/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF49606A32C;
	Sat,  7 Nov 2026 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFZCZqR/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F000E1F0089F;
	Sat,  7 Nov 2026 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064936;
	bh=ZNtodVlmHfnacLmlylRB2h3OKDo3SlRX9ttTbzCkLdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFZCZqR/kbLJ5RMDoi2G4IWIAai6N3T+h6M7ruqfwCIJyH3N49eiEvr4R4Y9qAIAt
	 4jl6HDsyqjz0rWsk5RZdvtNOi1qNdGQ5AQbz9jqkMTwoexQFAmp9LCUOnRLR4gXR7d
	 FlGdSHkq72JXT7bX9zEnYJqETgyyzF6FRXJcXcpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0827/1257] rds: fix out-of-bounds conn_path walks via handshake exthdrs
Date: Sat,  7 Nov 2026 08:52:03 -0500
Message-ID: <20261107135002.176800059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 50f2103fce43922b6e562937b2d2fc62089ff7ec ]

Both the lane and the connection-generation negotiation are driven by
extension headers in handshake packets, and both are processed
unconditionally, even on transports that are not multipath capable.
A non-MP connection (t_mp_capable unset) owns exactly one
rds_conn_path slot, so a peer claiming up to RDS_MPATH_WORKERS lanes
makes every subsequent fan-out walk conn->c_path[0..7] at 504-byte
strides past the single allocated slot (KASAN: "Read of size 8 in
rds_conn_path_connect_if_down"); the generation negotiation opens a
similar out-of-bounds walk on the same array.

Only process handshake extension headers when the connection's
transport is multipath capable, so a peer can never make us walk
lanes that do not exist.  Both call sites in rds_recv_incoming() are
gated.

This is a port of the Oracle UEK fix for the same issue, picked up
where Paula's series of the same change left off.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20260825120132.51636-1-pamoutafpro@gmail.com/
Link: https://github.com/oracle/linux-uek/commit/2fdeb0513f18
Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport is RDMA")
Fixes: 905dd4184e07 ("RDS: TCP: Track peer's connection generation number")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261012025336.54756-1-bsdhenrymartin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/recv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/recv.c b/net/rds/recv.c
index 6204e577a90ae..93ee4546ae362 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -379,7 +379,8 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 		rds_stats_inc(s_recv_ping);
 		rds_send_pong(cp, inc->i_hdr.h_sport);
 		/* if this is a handshake ping, start multipath if necessary */
-		if (RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
+		if (conn->c_trans->t_mp_capable &&
+		    RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
 				 be16_to_cpu(inc->i_hdr.h_dport))) {
 			rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
 			rds_start_mprds(cp->cp_conn);
@@ -387,7 +388,8 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 		goto out;
 	}
 
-	if (be16_to_cpu(inc->i_hdr.h_dport) ==  RDS_FLAG_PROBE_PORT &&
+	if (conn->c_trans->t_mp_capable &&
+	    be16_to_cpu(inc->i_hdr.h_dport) ==  RDS_FLAG_PROBE_PORT &&
 	    inc->i_hdr.h_sport == 0) {
 		rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
 		/* if this is a handshake pong, start multipath if necessary */
-- 
2.53.0



