Received: from mo4-p03-ob.smtp.rzone.de (mo4-p03-ob.smtp.rzone.de [81.169.146.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3E715EB6
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 09:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="S76Hubov";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="rUZZDv0d"
ARC-Seal: i=1; a=rsa-sha256; t=1698744632; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=EmQx1zC6EcbTmXFRJPlmCS6PaJzHk13emPMkW6fcvRxNRQ5oAEfhbADOIGemL2ZfGk
    Gt6kJxFFvNhrrJAwaVSyGmGtMJsDSNa3X05dRBHdBGmp3lmRR9SAQruwr48FJiMooqe4
    5fAxH4vD97nyNTh7ZClC7Xyxrvumh795iEtIBul/ifPOVUS5SZ5OT0KpqHvSeq01N88b
    Kaf6fT8+/PL8iAZaf5B4hxwKwfXPsjVFOTwiJF7d5ADqE6Z3LeAUGTSBrv+Y0WRfQu+a
    7aOyQxl237QuoZYH3YRTUHMU35yyrjXXeRWtj+w9vLGvEN2J1RYYekeIO0vtO4gZEAWO
    0m9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744632;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=aj88NU5p18dAF/7YWtzTK8+v3lQ/lDk4YoM++cx8mew=;
    b=PFAAOoRQ5P9DyQ/OyWUiWHXGfiBxb8jivNPAUTmfCoPZXiW6XrpGWwaJ1VT0bLbzCz
    B8vXBvtclOImNVWZT2kwE67VBwWVsRwFXm6ThdEqkgNZU1/u5/+kpt53ceYyUwiV79QE
    DfmW30BCpAA0+1vMX19Ji6lUtgsevx6ybXc1IuDj2omHe6DREWVSQFDomorXeQlmwkfA
    EH2YdBNtyFlNnBfXG70ySnPHjn+cg5FFteBwEqu0s7HAsq5rWF8b2miPIPzfrVrBjvqF
    Iw3/7+4mg3bpkPYalEsyJNcgm/ul6maaWfYZr3R29+p6CgmJVjPVve1ZqsziSjGTOdcp
    WYkw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698744632;
    s=strato-dkim-0002; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=aj88NU5p18dAF/7YWtzTK8+v3lQ/lDk4YoM++cx8mew=;
    b=S76HubovhIPZzSQ2lnJOEr9tWI8sl1RGQ5iy9GvsBROfGH3XkAWGM4k8HjLGKzCes7
    wqpMkA3Y0uvMonuiDep8++JxKXAHosUNkv82h7SuNwupaMJoKQpLyoSiHZLp0pLkoPcU
    TBx5hb5kQH2SG9B1XXpEQEz8Z/ARb3D1Q0fVrm7H9tQzz46iFbRgpmhfF3qvER6MpC5h
    Hp28c4cgc34H6yoW3mgGIwHLGXGec71GzSl9O8IE11DbmhcfSFY5H6p2sJwPho0Nnsel
    qcLyc2OXRz6ZFQlUUaZpJFajOMDdo0Pt+/pV/W7KVXivCepyHiMeyVeuBtom1RUrU/FE
    u6nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698744632;
    s=strato-dkim-0003; d=hartkopp.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=aj88NU5p18dAF/7YWtzTK8+v3lQ/lDk4YoM++cx8mew=;
    b=rUZZDv0d4LnYTOdbKGF7Z0/EG6ADsRcH20SKuz2gTECzHfhfni18wMfJXSPdniZgE0
    KqW5yYHIGv94NEag/6Dg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejuVITM8sik0"
Received: from lenov17.lan
    by smtp.strato.de (RZmta 49.9.1 DYNA|AUTH)
    with ESMTPSA id Kda39bz9V9UWFha
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 31 Oct 2023 10:30:32 +0100 (CET)
From: Oliver Hartkopp <socketcan@hartkopp.net>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	sashal@kernel.org
Cc: linux-can@vger.kernel.org,
	lukas.magel@posteo.net,
	patches@lists.linux.dev,
	maxime.jayat@mobile-devices.fr,
	mkl@pengutronix.de,
	michal.sojka@cvut.cz,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Subject: [PATCH stable 5.15 3/7] can: isotp: check CAN address family in isotp_bind()
Date: Tue, 31 Oct 2023 10:30:21 +0100
Message-Id: <20231031093025.2699-4-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031093025.2699-1-socketcan@hartkopp.net>
References: <20231031093025.2699-1-socketcan@hartkopp.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

commit c6adf659a8ba85913e16a571d5a9bcd17d3d1234 upstream

Add missing check to block non-AF_CAN binds.

Syzbot created some code which matched the right sockaddr struct size
but used AF_XDP (0x2C) instead of AF_CAN (0x1D) in the address family
field:

bind$xdp(r2, &(0x7f0000000540)={0x2c, 0x0, r4, 0x0, r2}, 0x10)
                                ^^^^
This has no funtional impact but the userspace should be notified about
the wrong address family field content.

Link: https://syzkaller.appspot.com/text?tag=CrashLog&x=11ff9d8c480000
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104201844.13168-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index b5fdf30a6996..82e56f3dd2c6 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1127,10 +1127,13 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	int do_rx_reg = 1;
 
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_family != AF_CAN)
+		return -EINVAL;
+
 	/* sanitize tx/rx CAN identifiers */
 	tx_id = addr->can_addr.tp.tx_id;
 	if (tx_id & CAN_EFF_FLAG)
 		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
 	else
-- 
2.34.1

