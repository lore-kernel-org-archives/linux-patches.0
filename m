Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053187;
	b=sG7GKO7a+QGzFQm6PKNGdmiSEuLiqwbpJUofxrfWi6CVUTNTQ542k2TfJPVCk2P4SK3M
	 wQRRv1EL6fRxFgE13DEeYNLlCNbk1lww/MRagwLpcx7MCiLls3pMaGEyuZkcIotMSS0Nt
	 eMbrJKVh+1tLSom4waxRzk7SwzCYdquLnG8cOEx7XEH+hPpJce3TNS6rZtTGLkEzdEGkv
	 5MufV+YgUMvX9IaCB92HP/kV+P0y57PguCkFkhhZQNCzKKI2m98RddydpLntgEzuLLKk3
	 UudR/Jf+gf4l9x4PY8PjDijQkU31pIzadDj61/MZ24pG7+lqgPWpqAAm9AiLVJzYyMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1e+U5v10YhvOknVFSOy7eKUr1t4LObrxlTDmOVFQm/s=;
	b=ctBUhU3o00ptPNnrv6TxQcxbPkQKq7zhTpul2TalEW5DgGEw2kjZMd2PHThDaQ5eWl18
	 ZFc2Q5V0T1/AwztBpEGajCe6aY9YIsfBnN4nGTWe3yPNsxw/UTu4xXUGOvyrCH5Ft7lWn
	 7DIZUdbvX3DgGYDRjrxE0hNUa6MXCGrI3sNekBolp5nRckgTv1IL9jLVoK4gpOGhpTWhL
	 30SULXI+v8jWYyo+5lL9Lv/gzabTx1+exjMkhr60+XrM3t4hBbVqJshcja6CNhWnBJIUM
	 W0XD/i4yrcRk8E/amoMRfB5ZU+8mse3rBAZon8hUe7plkR1OtHfkG/85a0ELjrEKuDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfXrRfKr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719A4606A320;
	Thu, 19 Nov 2026 01:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfXrRfKr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E791F000C4;
	Thu, 19 Nov 2026 01:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053187;
	bh=1e+U5v10YhvOknVFSOy7eKUr1t4LObrxlTDmOVFQm/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfXrRfKrshCO/9kzSwt9S638VDjlWIKLAB9yFw7s6FMozs7QM7w/XvKmNY+mdYzsU
	 nG1IAe2OLNnEPnbK0MMj4npNM2deaNv3mh96pY/b9FDws4DgLE5CDLwaMLF3hI44Ta
	 i53MNvMzD0xUarDF2zO3Zn/Vbu+I4IhQLlFx5ShI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0828/2214] rds: fix out-of-bounds conn_path walks via handshake exthdrs
Date: Wed, 18 Nov 2026 15:41:44 +0100
Message-ID: <20261118150045.035447895@linuxfoundation.org>
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
index 7fd77e1b4fe71..a55a53fb35024 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -342,7 +342,8 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 		rds_stats_inc(s_recv_ping);
 		rds_send_pong(cp, inc->i_hdr.h_sport);
 		/* if this is a handshake ping, start multipath if necessary */
-		if (RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
+		if (conn->c_trans->t_mp_capable &&
+		    RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
 				 be16_to_cpu(inc->i_hdr.h_dport))) {
 			rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
 			rds_start_mprds(cp->cp_conn);
@@ -350,7 +351,8 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
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



