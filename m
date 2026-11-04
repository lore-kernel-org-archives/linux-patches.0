Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830926;
	b=zWbPtETg2/uQ6RyjDdUTSksxtpI6xxHifG5Z/35PEv0OaIPHLYF+/kzgkdbwzScMVMkV
	 h5Xb9Vj96RB7oK3Z3GCTSnfaUeG3znjrtpOO1xiXzWyf9eXnUWv52EmBTaDcL54gEofM+
	 Bfh5U/xr+RCc9HRflBeH3lBFj5xqUbBlYf6E6bu8/h19ZZZ9SvIbBB/nmvkxJWTX/MFmX
	 T/zu9ObNXDZFr9nKgQT673hIf+V3byX71DR1Rz0ctUP4xRURF5hRjmggKZoo0a5Whl/R5
	 uN0WXCsfnBeXplYAbDitmIkBuDoe6DswmWrYDg20Tl36grLQEU5y0yvFxzt6O1FK86Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9/bIQId6XD6nwsjlmpgthPfy3XfOmCiex2MXFTGTRA0=;
	b=DmyXRTnZb1L6sHcDbyZyIsS7KfyWpsiO6eOjRAvV96rQsHQfw00GNbbbGPP1XRi0cqHE
	 2AdJJtu+I/BkbMIDHaG2HHzwst6GIL6Xs13n+cMmyzb2Y0Sx14c0/wO3kRp1MID/vdU8i
	 AFjxNOvGJxULlm5dhj8YAlMi/v65+bXwxplQtnGbIaK5Bgj1sotn0XJvfL1D+V0NlRCXh
	 bxUD6YJf77Ps9XG5vS2tAXQhPrpdiNXhATVX0MQhNhBjl1h1Srt5RZNPTaHTm6jBILQSz
	 Zajjgtjl+5lAnKDQSvc3DpPWd0BhdQ0LXNgGr6k3S/j66gGROJgASk4ZgN8TmeETIoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4xfZKmT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3466606A33B;
	Wed,  4 Nov 2026 22:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4xfZKmT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1F91F00A15;
	Wed,  4 Nov 2026 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830925;
	bh=9/bIQId6XD6nwsjlmpgthPfy3XfOmCiex2MXFTGTRA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4xfZKmTwHaBxBnm5azsZLypjvFjS1bp+xS4pDhNW8mRxJ4jHrohEa/MygAlEEHsc
	 O5+XW60b09UlArKtQSb5kZa+whscus5Snr5CZzVXCLw+Kf+qXREuzG4rHM0pTVADH3
	 /myve4rU9IsqXS5vK7c2vlAU6hAxIkuEIPFD1T8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0406/1005] ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
Date: Wed,  4 Nov 2026 16:02:19 -0500
Message-ID: <20261104211055.451392995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit c1d7bbfc5e081875053723d1a69eb2cf341eaaf1 ]

When a client's Durable Handle Request V2 sets Timeout=0 ("let the
server choose"), fp->durable_timeout was set to 60. Every other use
of this field is in milliseconds: DURABLE_HANDLE_MAX_TIMEOUT (300000)
in smb2pdu.h, the nonzero branch immediately above
(min_t(unsigned int, dh_info.timeout, DURABLE_HANDLE_MAX_TIMEOUT),
where dh_info.timeout is the wire value and already milliseconds per
spec), and the scavenger in vfs_cache.c, which adds it directly to
jiffies_to_msecs(jiffies).

60 is off by 1000x: the handle becomes scavenger-eligible 60
milliseconds after close instead of 60 seconds. A client requesting
Timeout=0 is relying entirely on the server's default to cover the
gap between a dropped connection and its reconnect -- 60ms is not
enough time for even a fast network blip to be detected and
reconnected, so any real disruption loses the race and a subsequent
DH2C reconnect fails with a durable-handle lookup miss instead of
succeeding.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8d078d0abbe14..a5f9876182313 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3681,10 +3681,17 @@ int smb2_open(struct ksmbd_work *work)
 					min_t(unsigned int, dh_info.timeout,
 					      DURABLE_HANDLE_MAX_TIMEOUT);
 			else
-				fp->durable_timeout = 60;
+				fp->durable_timeout = 60000;
 		}
 	}
 
+	/*
+	 * conn->is_aapl detection above (this function's create-context
+	 * parsing) is skipped on the reconnect path below, since a
+	 * reconnect always arrives on a fresh connection -- if the client
+	 * cares, it sends its own AAPL context on this same CREATE, which
+	 * this function's normal (non-reconnect) parsing already handles.
+	 */
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
 	opinfo = opinfo_get(fp);
-- 
2.53.0



