Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021757;
	b=aZbeinvPzBZXBDDvc9IQq3Lr/Gd3ea4HaLhg4huCqP6+usP8lAwzJOaUhPl4wFzjx/w3
	 5jB0hvOkCSBkWGF0L459BapxS265xH+hGT2PKV6tdzwCRXUKLcwUCU1ALkOzx2D+37omh
	 Z0TEAyCqayD2UYvLmn8MZElwwjNH/cBsQ9a9QnulrLKIvA84qJBN7CLUghyTWlWeBQ/ag
	 0goHZoypUl2GNVS3E7gBI1Jo1z9CWUvypUL26pFJqPnUckTTAwQaTaGesvNz1+4Q0U8gE
	 rCaSRn6e8xDqAejJjkncgcT90J1C3A9tS7yINM1Prm6FjA2gBSekwV4hyKOaDXdMwuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+KIRW02VBFwKmG0WHYHZG8QmizQT8EeYBQ88H6/99w=;
	b=dnIsZhaU1puiPE7rZ2qLwBK9T0m1k/z/SV8udxqf7E5nAM1ZoXSW3ku65qzC2I5Jw5Lc
	 ARqAbjsvLXWDagZ7Kk9X3u9qDzWl0LtuuRfZ6tsAEW4tOo1aiF1h6dFM3iHYEbNwG7SIL
	 XIxMO6mV/69CSphBEkIHPkqUjoBKPUbHqYiu9gFJy6WZfeL37rWPMyZ/ULgvyVvb1vn4p
	 DsXFMbIfaaB8+IlR+hm4whLHqLlKC8oRr5gWDH99DlfWtX6iK+OWlY1lEb/ZLdgjfjR07
	 QD+DRu7F5t3jpkF2to6UyPa66yRWFie6vRNRnijZcBgWQW/nat8bDYTQUSOF4XXkcCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvOHGwhl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430ED60A381C;
	Wed, 18 Nov 2026 17:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AvOHGwhl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9220F1F000C6;
	Wed, 18 Nov 2026 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021757;
	bh=p+KIRW02VBFwKmG0WHYHZG8QmizQT8EeYBQ88H6/99w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvOHGwhlmWOQG1LBnL4oYw76V9EJGnegjdFia4u/PI9gEXX6F8/qZ8i2gxHXrnuH0
	 bH65sJZNMUYLebeuCIhai3g+HMJdxPnidbpBlTZtX2PcyK0L7FfmxXoqYtY0eZYosE
	 r1SaWgYeh8l2VQ302jO+QLM/AsBZjGkH/1+zygcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2421/2651] libceph: reject bad connect_seq in msgr1 READY reply
Date: Wed, 18 Nov 2026 16:01:01 +0100
Message-ID: <20261118150412.409287251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index c9e002d963190..b3ff3274344e9 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -887,6 +887,12 @@ static int process_connect(struct ceph_connection *con)
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
@@ -898,8 +904,6 @@ static int process_connect(struct ceph_connection *con)
 		     con->v1.peer_global_seq,
 		     le32_to_cpu(con->v1.in_reply.connect_seq),
 		     con->v1.connect_seq);
-		WARN_ON(con->v1.connect_seq !=
-			le32_to_cpu(con->v1.in_reply.connect_seq));
 
 		if (con->v1.in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
 			ceph_con_flag_set(con, CEPH_CON_F_LOSSYTX);
-- 
2.53.0



