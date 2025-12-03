Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6405C3081AF;
	Wed,  3 Dec 2025 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776383; cv=none; b=dnbMKeygwkM4megpgMsmmPv6xc/7xbDarrNRJNz9cIrv4jFrcNd04xtZrqyKz56dcNsHGyzAxPEWtQGqt55ItAxjswpQQD5CfOCJ0VhhVVKEx2MHiE2V9ZrtSsw4gqZqlgqEwExXysZrR2pbBD29jmG1m1s0Yr5N9B8dbt9OQbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776383; c=relaxed/simple;
	bh=EjcrfcPC/PQGt2Gf2535vus+xB5xSVz/FpUhsaybg/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlF5GllrArNEgq709TJijVGOrGKGFMR9zfEk4VwQmY8LSRuIo07IArrGSiZJbejTPP6n//5yTj9YeW1NZFrOhnYa1VHK9VG5i+HZNhxsBmAKEpGCBavDIOHlvOAGGrwhwR4YqaJvcRX8yAGWbLiIDTHl6IdUWaCHTj5p3YtQjHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3jed2Ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3jed2Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A67C4CEF5;
	Wed,  3 Dec 2025 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776383;
	bh=EjcrfcPC/PQGt2Gf2535vus+xB5xSVz/FpUhsaybg/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3jed2IcPQQEjgem2x4gSUq7v06NOMICqA/iSe0ENAmvreTf29IdBUCIqwwP+q9ez
	 fBSpOXtn8KE/22qoq3yZgOz8wEJbOBUFuNL13Ou6uJJyrcoazlH9PW9nygpr0iMBSR
	 fn8tmPDdNgjuS2TovDaZk+W7arq/6XAngNTcOL1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Lu Wei <luwei32@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/300] net: sctp: Fix some typos
Date: Wed,  3 Dec 2025 16:26:09 +0100
Message-ID: <20251203152406.731804816@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit 21c00a186fac6e035eef5e6751f1e2d2609f969c ]

Modify "unkown" to "unknown" in net/sctp/sm_make_chunk.c and
Modify "orginal" to "original" in net/sctp/socket.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f1fc201148c7 ("sctp: Hold sock lock while iterating over address list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 2 +-
 net/sctp/socket.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index cf77c4693b91d..85cc11a85b383 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3206,7 +3206,7 @@ bool sctp_verify_asconf(const struct sctp_association *asoc,
 				return false;
 			break;
 		default:
-			/* This is unkown to us, reject! */
+			/* This is unknown to us, reject! */
 			return false;
 		}
 	}
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 196196ebe81a9..8fe09f962957f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9266,7 +9266,7 @@ void sctp_copy_sock(struct sock *newsk, struct sock *sk,
 	if (newsk->sk_flags & SK_FLAGS_TIMESTAMP)
 		net_enable_timestamp();
 
-	/* Set newsk security attributes from orginal sk and connection
+	/* Set newsk security attributes from original sk and connection
 	 * security attribute from ep.
 	 */
 	security_sctp_sk_clone(ep, sk, newsk);
-- 
2.51.0



