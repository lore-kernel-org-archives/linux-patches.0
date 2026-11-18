Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053676;
	b=dLVD4ESLspMlbrzu0AWafE94j/M94YTZLQZtEVackbfivXlRR+2mJBGxxNGcg/Kvzjrw
	 s3kGQs4syuTJkdZo2qhd3uQ8W4qKWKQkkijaxydB6GaG2CorSK44FUENXQZzEnSpQK5LF
	 QsokoM3u30GgPyGwFSo24Tqh6yzz10DdZzxrkJYTI8VoxoQgN9GoJYbDnuZFzagXlJ+rC
	 uJllD67o2Rk3r260gwe9PXxJvOje7AzQXc+MMMPpQkAQfdPzUZ6qvx2upkpforP9N+T2z
	 Nwo8wu/dyDw2T7VeIp7azp0WEpysBFVDWdfCOtMH9j6eBTd6TtbsI8YPnus6ZqU8jOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CQVXxQojC7Fh//Hwc3xhNnSd4POjVDmz3plQruswuzc=;
	b=nxSIKaeVwzCmyqN+BRZsRt8QIoJ6MLDYAiFsQpiGZGCJyZir3SaZnauL/Qg9ozJV1Vfx
	 B0rO/vUodfQ+k6EK1IXQ1E2I6RfrdXYKT+OGe6BcRBgGQNPFSsbBcWl/eHz0Bd8Ph5M2S
	 n9vVlF+SZKJeCgVCO1SKofNt5Hsc2zscApNa6c1QsytYNneAnxRwad3arw/3zTjJz/8eQ
	 hLISDEMFKcL1r6PU9Ll9aB2FYeBG46J3HQrDFPghCyn5OHmZAvmkscSGg0KByvDFChuZE
	 1HWi2BVH4DNYjpHZoHvGIR/UWltkicZq1M9QeBf90Ca928m+byxC8uq624jxpl4z+PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVNnAxgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328BF606A31C;
	Thu, 19 Nov 2026 02:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVNnAxgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BB51F000C4;
	Thu, 19 Nov 2026 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053676;
	bh=CQVXxQojC7Fh//Hwc3xhNnSd4POjVDmz3plQruswuzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVNnAxgm2kY5Hjb04sdGMHFQzZcX6G1TAWboGzpc8znnrknRjmQKodJRDlFmYfIFP
	 QVqi7iiYUzm+KYJ53N/kAMtPTp0O/JWZCixIurO3o0x1aJR11GNwoBubj6waTS40bB
	 CF1lvJlfwUsHzvzozvXBrS24P2ZjINtvSwfDdS/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1003/2214] Bluetooth: L2CAP: Ignore connection responses with wrong ident
Date: Wed, 18 Nov 2026 15:44:39 +0100
Message-ID: <20261118150052.528677034@linuxfoundation.org>
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

From: Jinwang Li <jinwang.li@oss.qualcomm.com>

commit a9f9eeb5344fc7dc625e5700ccf09891bc2603b5 upstream.

Adjusted context as stable does not have the lockdep_assert_held()
call in l2cap_connect_create_rsp().

L2CAP/COS/CED/BI-28-C requires the IUT to ignore a Connection Response
that carries an invalid Identifier.

l2cap_connect_create_rsp() only checks that a connection request is
outstanding, not that the response answers it. Add an ident check
against the pending request so that a mismatched response is dropped.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jinwang Li <jinwang.li@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 75c2ab39be167..a25a134087861 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4467,11 +4467,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
 	l2cap_chan_lock(chan);
 
-	/* Only accept a response to a connection request we sent and that
-	 * is still outstanding. A channel waiting in BT_CONNECT for security
-	 * or the feature mask has not sent one yet.
+	/* Only accept a response matching a connection request we sent and
+	 * that is still outstanding. A channel waiting in BT_CONNECT for
+	 * security or the feature mask has not sent one yet.
 	 */
-	if (!l2cap_chan_connect_pending(chan))
+	if (!l2cap_chan_connect_pending(chan) || chan->ident != cmd->ident)
 		goto done;
 
 	switch (result) {
-- 
2.53.0



