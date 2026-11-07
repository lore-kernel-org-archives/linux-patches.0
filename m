Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061096;
	b=KiBY4FO8qJ1whBgooGpYf7WVzhUyVyEkjSSNtMs750dAssu4jbKV7UUND7WYynek2UoI
	 gEt2xDLwmspdEzdxxsywayWtlqdQk95EZ4bJIeJsx7dvjkatYt6cMh8vVue8jyRl0bC8Q
	 wWMIMQFoP7lnoO0ZuiLQzckekXost1s6BGk0rL64pVFxULsgdBT14Vpga44602CVdQ6Fj
	 tlxU97pE59AFGkjEdHtXfSx20P2jDicY41UfjMGd5tpZeTHrvRoTCz50HJD6d2546qpkc
	 gdHEhQUpATIf3IFoYZrKfd49xuZRtAejdQhSwcOMUWiGYsZC/DLRvjVwGQOHFh1GkFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJ9/TVVBuA7N507wpEbRkFdbOfiFxYaI7xLQWAKu/Aw=;
	b=2fIdIhMfGaglWj6yacPhj+iSZeOc57D9nYEKvmPEMQCDQSECSA6MsFrFdjgTBiAvDWd4
	 9ATOCjS4uZL+gzuX9RO0z7Gfzl41oNm0X0/BdyyI+bz89zo/qr71KLDXWrn34wdyDXnBp
	 ytxDjNTA8Ox0E7e+f07NX8tN1vJg1i3BMukO5K3Po3cL/+zNi7yJS93nrP3B35ltTwTAn
	 l7w3mDsSZ+mp6LOd4l+SUiqHFocGKTSXE7tjJO0N/kd7RClj9SY9h8g07qulhSaKgS96b
	 7P5vnVe0uV+SDsm6HoQ4e3PbxAOb9SQTkBTGRPmRsvjBN3gBaE1nCWhIRNRb8d7L6oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bz4S3RuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C477606D837;
	Sat,  7 Nov 2026 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bz4S3RuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D441F008A1;
	Sat,  7 Nov 2026 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061095;
	bh=EJ9/TVVBuA7N507wpEbRkFdbOfiFxYaI7xLQWAKu/Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bz4S3RuLPSCM3yvUzSOEY273NnmxzkIF+RGhcKmIIl5nYK8zoGMKFZoWAjUCn7YjW
	 dHK/GaLM4SW4oh0cKPCAfT8gYqCAbc+XE0/lHM+3pdNLqnvtRwXoVsJV0c2HL+vtMU
	 ZhpQB8LnP0YPRHiY/LCmwTXazQZLOVqhF4uy9+hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0377/1536] ksmbd: enable TCP keepalive for accepted connections
Date: Sat,  7 Nov 2026 08:39:53 -0500
Message-ID: <20261107135008.219619310@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 56549c18a4f75309161ca780feaa4d17904e3ee9 ]

A client that disappears without sending a FIN or RST can leave its
ksmbd connection in ESTABLISHED indefinitely. ksmbd sets a socket
receive timeout, but the connection receive loop retries timeout errors
without a limit, so the connection remains in conn_list and consumes the
per-IP connection quota.

Enable SO_KEEPALIVE on accepted TCP sockets so the TCP stack can detect a
silent peer failure. The keepalive idle time, interval, and probe count
remain controlled by the existing TCP sysctl settings.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 902a6265e323c..2356edc0e29e7 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -325,6 +325,12 @@ static int ksmbd_kthread_fn(void *p)
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
+		/*
+		 * Detect peers that disappear without sending a FIN or RST.
+		 * Otherwise the connection handler can retry receive timeouts
+		 * indefinitely and keep the connection in conn_list.
+		 */
+		sock_set_keepalive(client_sk->sk);
 
 		ksmbd_tcp_new_connection(client_sk);
 	}
-- 
2.53.0



