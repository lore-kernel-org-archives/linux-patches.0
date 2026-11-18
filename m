Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032889;
	b=k2UvDw2pimUEzi6mb34tBiGUFryR1cHD2edVQxwf1AwxZ4qpHRdkcrzab1I3eVNLWnxJ
	 em9/2JMfLlHJz4DTMb4tfuY8i69NfmtTlRloQIEtBQqoXfTKrTJbJzyKeFyOr6JRDVsn+
	 DvMV4QGiGWHJwXA4Ut5r/3mju57H0zd/UwaEVleXP2l9g02IEo2a74yf8YWfu+cmDLxKS
	 HWn9XQMFIPpjNbnhI2zxRRoOhiI6u7f9GINaBeImID8VddPZ23B3EXzFSoIoVUdDIsgk7
	 eI8Ik5zcCAp4sL8eUD2ftxd+HK/J18XVJYXkLdMMJQx9w76Ff4hhBwkV34uSwUNsX9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4+efXwSjKZ2YDTvi2L+1kfIgNJKwpvKKchAKy7MLIsw=;
	b=CsN/ZI91z94+sDMh+RqPkRmJi7ua96ZmiLTr/nis55RossE02rQTYjfu5QU8TJOERPDl
	 5eTqhGPtrx966opMFiffxKNMgLriGwN1NhuhQuS+2UYtJcTQxtU8pJ+XIXhWVblQ92hPX
	 6oHhyrP8lkz9qRbz/k/a2VEu05gk5GZAyHTv0HiQVtyrJMBfr/Sc7Q3bsZ3GOWxgoceZF
	 GeLRAYeL4W9B4sG5nX3uJiwU44GUFhvacNcmGXqN3oBadc+ct2ZhzKlJgIyQxobN/DYbC
	 MBxe0rKiKOu6B1HqowrPCZ3R0u1FUo3utJll3Wmvm2iuWV8gpulknW7OGJd3rmtOSrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B7BYuHrA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34A3606A33E;
	Wed, 18 Nov 2026 20:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B7BYuHrA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E411F000C4;
	Wed, 18 Nov 2026 20:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032889;
	bh=4+efXwSjKZ2YDTvi2L+1kfIgNJKwpvKKchAKy7MLIsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B7BYuHrA7COK3hsG1tpfNVV2T/XoYRZ6S/UpP0xQNNGXO6u6+OIrQJ8LQuT6bN8xB
	 rVWtU0J3KRKqXNKN2H+Fzc13rz5690DHLcRKpiSx2zC6hnfzml+rJQCRBFbB+xhtQa
	 TwJ37ty0VdexpIZ6nAn+icNRYHyzVJM5pE3KA6Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1573/1756] libceph: reject bad connect_seq in msgr1 READY reply
Date: Wed, 18 Nov 2026 16:01:40 +0100
Message-ID: <20261118150112.385074320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



