Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056927;
	b=DTsTKLNuUt5d3p0OdydOd6y10mgyxcPO9/f+5aWSPPR60793w7jXs0pteZ04hqZ6vnjL
	 vWGPkxMjYaQ3R1/A5jZ7Wc8qQKYsz8QtPokj7K6bFq22DhN5fm7fPjsTn1usNx3+H/eGk
	 Jfwb9AE8TLvOfy1jOOa3Am7TOqe8obmfz/pxZ4DVu70wwEYeIQ6PspmvWKkNCOcMNzA4V
	 eTY5GZ3i8XG6zByozgEcGBnDG8vNjW03HGiMy8EbSbCnuPQkxi9dOMJuPrXK5EDY9zdQx
	 NuI0eDaxxB91ZJ47WWMLjDSWldXGKXUt+VPT5iBXrq4BTjAC4I7WL+6mfGUBmjuUJ+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0MBAznIscZBOCFyrFALRYW2cIkiUGyDmEOsqli5+og=;
	b=4RUGGmLal7k1LJXqk77FCkNkEMq+LtUXRrADW3AouypwDwOlXR2wxefutweMiu9HDeGP
	 uY9yJlmAutTSUDRM8TMeD0OYzWvMs65t9vgkxuar7TMNJW97+l+fJwNsr4ve5KLl2PcVi
	 bmgaoIZISSGygZNMNcIpa+SvY/p8jRTYqX/XkhdBYZf5DCfuqclHtlhgveBGOxPkaKO0p
	 PAeBTFNyVgV9drsdPHF7YknOj/S3o//xhyZptu6bZyYH+uYI3kZvcoeylXgwUEeMC+ASe
	 JCzVEU3Et5lweOfuCneh2EioQthtYkBuKU9zIpy97ttrdlD6PkdpHUJWJ3YgD1Gt89A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XPZev/62";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBA7606A31C;
	Thu, 19 Nov 2026 02:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XPZev/62
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA711F000C5;
	Thu, 19 Nov 2026 02:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056927;
	bh=m0MBAznIscZBOCFyrFALRYW2cIkiUGyDmEOsqli5+og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPZev/62wZXilodeceIJcFjyP+S6vzg/x4WTM51A7c4qkuGnmdGmliD/HYGxprR+z
	 /hJT/RynvskwRPgmd0zZ/9HRRBTPvSsvT2QRD3WKH/l1E0O33tm/yolgHZy7sRRY+z
	 tzFxvnSB0EWOVxz1vTxTBwu7MrHKkS/bsg/1yaGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2125/2214] libceph: reject bad connect_seq in msgr1 READY reply
Date: Wed, 18 Nov 2026 16:03:21 +0100
Message-ID: <20261118150135.572610515@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 6dfc1b1a99da4909aee07a906352be5c3fc9baba ]

process_connect() WARN_ON()s when the peer's READY/SEQ reply carries a
connect_seq other than ours + 1. That value comes off the wire, so a
misbehaving or malicious server can trigger the warning at will (and
panic machines running with panic_on_warn).

Check it before touching connection state and fail the connection with
a protocol error instead, like the other bad-reply cases here.

Fixes: 31b8006e10a4 ("ceph: messenger library")
Reported-by: syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=21f8628595b2061c438d
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/messenger_v1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 6290b062d631d..dc5534c7d36f4 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -897,6 +897,12 @@ static int process_connect(struct ceph_connection *con)
 			return -1;
 		}
 
+		if (le32_to_cpu(con->v1.in_reply.connect_seq) !=
+		    con->v1.connect_seq + 1) {
+			con->error_msg = "protocol error, bad connect_seq";
+			return -1;
+		}
+
 		WARN_ON(con->state != CEPH_CON_S_V1_CONNECT_MSG);
 		con->state = CEPH_CON_S_OPEN;
 		con->v1.auth_retry = 0;    /* we authenticated; clear flag */
@@ -908,8 +914,6 @@ static int process_connect(struct ceph_connection *con)
 		     con->v1.peer_global_seq,
 		     le32_to_cpu(con->v1.in_reply.connect_seq),
 		     con->v1.connect_seq);
-		WARN_ON(con->v1.connect_seq !=
-			le32_to_cpu(con->v1.in_reply.connect_seq));
 
 		if (con->v1.in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
 			ceph_con_flag_set(con, CEPH_CON_F_LOSSYTX);
-- 
2.53.0



