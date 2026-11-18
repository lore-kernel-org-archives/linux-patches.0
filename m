Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042431;
	b=KBhwVG7shEdMkK9svssle00BatG292XjsgT/8cSYcRzZEuOltHTuaYAy/0cc/bOUFB2I
	 611l6h97cFhdXKNoboGHJRd2H3WYMCAjsjwoyBYXhiT4ra+FnyXvttXtPa9M/MUYOJtYT
	 EgKdT1JNlq4GdKNGSoN/CbdSZq58noXsNtGUeRy4eJjWhonJx8sQDBDwQ7UCAIA0DnFdK
	 6L55MZVPPmUixjBL1ZcI9wtGILkWeSyryDDGh1nn/aYP+lbu/76aVvbl3E3ehXrj3y4su
	 J6HMUR20bH/u7ImglSsdXQCtKmTcnqkqLAzqQSKXQwDJF4ki+OwhqE2/GkCicY6+9FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IGUQxmJ5KuFezXMFi5y+1neYs3MC+xv4chm8hlqyQIw=;
	b=0dPDnxVtC4uoMdBols4SxsLhftxMeAVt3QdIZc1Ev5fL9zkVX8BodFLQ/TESlZadFYSk
	 0NCe8ZiP3Q7Vwh7iTPSJbrkK3r3cl40NpVEvVYfIlSsjOkFKu3IZPmFJYIH33iIvhTQSU
	 iZWPTwVA9nNV+U+N7/HWkufaEMQEOyVS/OOmlh1RoG+sjQP/WfAfOBiW4e09SoSMkRk3C
	 pxtmCOeIYuUx8pUnEE7FTd9OHmeUvIiH5svzZNLkr5pEpR5Drf8W6arl+infZkY8MlE7c
	 4ScEgvhwT20HNrvFHJCH2Ug1GGsg32kLhVlG7iflVBCLgKOwV8rpmkDnxpdGp6wpoOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUS5KvqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE44606A320;
	Wed, 18 Nov 2026 22:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUS5KvqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BF11F000C4;
	Wed, 18 Nov 2026 22:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042431;
	bh=IGUQxmJ5KuFezXMFi5y+1neYs3MC+xv4chm8hlqyQIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUS5KvqGWOIQPoIKH9u3wdpeAkisB4Opgp4cbw0sgw1HD0cxx6hFKt1AADQQwDa4s
	 sFarqZuCLRwSJSsdUgzxHtKYurvDuBfHbIAqNPV9/cyduhtg/rt7jll4cMGiBCuWjy
	 K6BEntoGJ5zLqn5eoO2U3slqZUWGCzgad3W/XCaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3169/3318] libceph: reject bad connect_seq in msgr1 READY reply
Date: Wed, 18 Nov 2026 16:03:11 +0100
Message-ID: <20261118150454.905129397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0cb61c76b9b87..d3a9d08b59d84 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -891,6 +891,12 @@ static int process_connect(struct ceph_connection *con)
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
@@ -902,8 +908,6 @@ static int process_connect(struct ceph_connection *con)
 		     con->v1.peer_global_seq,
 		     le32_to_cpu(con->v1.in_reply.connect_seq),
 		     con->v1.connect_seq);
-		WARN_ON(con->v1.connect_seq !=
-			le32_to_cpu(con->v1.in_reply.connect_seq));
 
 		if (con->v1.in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
 			ceph_con_flag_set(con, CEPH_CON_F_LOSSYTX);
-- 
2.53.0



