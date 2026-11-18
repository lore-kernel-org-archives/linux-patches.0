Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050503;
	b=xPqsAU8r3Fo7Yca84lBsje2T+NaUqzPuvkcJYUIWc79wErslSkR6XAYZRkkDbGqXAb5p
	 y2E6NqZe0qlIPWDUGZxjgZAAS0K/EYgticPBah2BtQ4KfPSu3NPkcZfGdluoXssqzX5+Z
	 yPsxvSGoDVxvbhvZotuGoLTKQln2Of04JSZkr0y9XMfdRhiE9OuUM2RzfhIoHSciLbpoV
	 xDWuj5vC3qf/vVQ2q7ZEyeQBw+WAJnxRe9GSpFTe8wQWvRlGGrR5dJzDwfaYrYAGMpKCC
	 eHZlzxOjj3Pep3EB8LT9wFgU1zkxSc1hpKovI2ifnztl3qFzCx4vCSFUUF6YO5uh41g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xorfHLLgSBvZrBhLohWPaFLiXB9/hJ9XSbiIsx8Jkfo=;
	b=tTWpBccuqoCcXpdjyKEyIMCKqHuhuUMb9SbEK14uvMAHUhOJ6i9cj/urIv0OHiy29mts
	 qC60ZNzK2fs24+Z2PmfmOo9+uIflv7PECF84CqeG2wSuoN80bWCmK0kaKbQe54Mzhmr+6
	 E+YFFZIeV3lwor94W0vzmbDuzyW95rgUI7a4LEVrHIQAFe8BKltW4yZxdmbjyq+sWNuP7
	 Ji/HCV2L3vA2v5bXo/TpZkgolhMnpDVisq291bu3NlEHLXbTtbJRs0EB859TaPXWWeMJk
	 8buxPg3NubbpMkXXWc9cUBHzklY6GmoAi4qflwtS6Xf1alyewTOlK0P/YBhe2IehOMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxdhcCSl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBABC606A320;
	Thu, 19 Nov 2026 01:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MxdhcCSl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0BA1F000C4;
	Thu, 19 Nov 2026 01:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050503;
	bh=xorfHLLgSBvZrBhLohWPaFLiXB9/hJ9XSbiIsx8Jkfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxdhcCSlMrhLFqmJPSOfCKjFS8c/dwyZxyjk9r3RzKvVe6MxV+jIzoTTsd0JFh6qW
	 puhM1+7v2cst7u5vjtDcNNh7IRXPDmOJmRulUqsesBBMmcQxusd6KRoOr8AYg8zXC8
	 Nr9upe5lGTrU1MuoYQjpvkyA/M2IKc0b6IEzoXIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2731/2857] libceph: reject bad connect_seq in msgr1 READY reply
Date: Wed, 18 Nov 2026 16:02:45 +0100
Message-ID: <20261118150339.956198404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d1787d7d33ef9..73fb7f707087f 100644
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



