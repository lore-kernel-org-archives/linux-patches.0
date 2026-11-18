Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028031;
	b=HKX1Nx8pHXDXDk6fhq2CIhNsVFQb+FpeMQAmuTbJ96B6Y92Kfg7FhpyFs7gmG17hWzyM
	 Gz6PGEg4duzWiNoQh6vap296wgx8rKHMP/DMHr6h/t58AoL2udBDfKwSYB9a1ZAY36hwO
	 yEzF+JXMI0cmueN7o98BMlzxzUr818/Upx1Rj7rqI5A5ROVfD/TmhCT1toEM2YXOaYUSr
	 RzmK7hfSsK4/NpbUxxUjkYTeYVJv85RcjH+RyjS45BF2NXDjzefwyeaEFiU7HoSyFwtxe
	 eRNetK9JdpDAymIwAmoQlfJTqrJhiEKfHeG4Tgqwt23PwJxd2XYAsvr1lUMDZ1h9kNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RvILUfaP0U/F05SVtpsZ9O26WqAwOeWHTCrOa/rmnYs=;
	b=TGptmXOz7ww4FwWVo8YYRHt+Kb+iChZdMwy3RoLwGl3gOsnRbeSssRKFicv3oLirDXx8
	 DkzFdWdOpFyLC3LJUNaU/SaYVV7Mnwwh/VDNLstVU9lVnc+WH6YC9mqUnryntRY+/oquk
	 qoznZ30BbMj2uENqDoyA9V50GWZC1QU/oc+/ATfXXD60ByaUJwqTCVavKU78jOKS2IZF5
	 XcGbj0mr/12cJZewdtUjonaQEbJHCTCUmN1Z+gL2UemM5hFDWtpRSpCAFJkEUoJWVS71r
	 MR+7RYhK992GQlfLpza24hS5uVsuHqKaPBMlT3Exab5FoVQ/FA5tBlczG32TmLYtcFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6MU7DYq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BC6606A325;
	Wed, 18 Nov 2026 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6MU7DYq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944811F000C5;
	Wed, 18 Nov 2026 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028031;
	bh=RvILUfaP0U/F05SVtpsZ9O26WqAwOeWHTCrOa/rmnYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6MU7DYqK35by8a10UsWYkId5xcTfakhjzyPm2cn5atw7U8ST0oNjkdyYOQbFV/Eo
	 oWREaPa0RnXf2ibjBcSwVBMqELlrzyzWjX8osxmQwMJxGmXwbguOWuMQeHzDkYCmvu
	 xyWG9FxlB/f+ZumBk99SV6xUxFRdXDBqRc3hi/j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1959/2151] libceph: reject bad connect_seq in msgr1 READY reply
Date: Wed, 18 Nov 2026 16:01:34 +0100
Message-ID: <20261118150233.120868005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



