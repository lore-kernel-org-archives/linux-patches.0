Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585254;
	b=XjhjR0oDWa+wzfRJSBNKmeDBrPKmkFIVaZFoWSqzHQ8eruOPjzeojx1JtnSrKj9A5Gjn
	 qeZ0mMdINMffA6Oc7vNgMeSTtoL5qTJiyjUCZJv6KpSMDtfy9Vp/wS8VROZxrN0jgBrn7
	 6VTcw8hS2DwQuFdgH3dMQcm9VHhLMRig2ta+/yIrAW8X5RkR1PMcMm3l+iC7nl4NJo8Cx
	 zqL/3ElPWBzFt5GWdCO9qMqlcwHGorJpmdQNWnRHWTaKfTwF4YpQvMszJ3w05tg4RUPpS
	 0dAWg964TrZ2K1eyyvccEVv/oSq291P5iiEIu8/gDa7IbeW9/bMDxlXIoSralogIXIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C5LRzyt3oo2JT6kA6coJPRMj/DRwEtkBY+0Fr/hqmB0=;
	b=nSGLpGoM1oZzONvH2Mp0eEhZ8qDybEnPmTbC16THqt0UyqgT7YzvGpZ6oTVzcZymQClt
	 cNFCseUpbSSzxRpLdqQkcyBcK5OjWsMOM6f6Da+TUD22A2+abE4lY16pRZbGUCLnsOX+h
	 upT1358O0at83VK11q0cWnnOQPKdX5nPpwhIfrsy7w6Y4IvTTwUH+U4+Sb1hDMFpT43FL
	 pnCYQ9IwkWc66EHBfdOe2TaUBaffTsR2502FzDAD+/Pqix4Yl4XheIHs4vN3mvCohpqUD
	 D88uS67Mv4xJ31twxrST928HsWlQYzv3l3KRoS/1lqUatl0YW4RU8iZ1KveW2PAHyAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yloyzYHE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88674606A887;
	Fri, 13 Nov 2026 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yloyzYHE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E454C1F000C4;
	Fri, 13 Nov 2026 15:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585254;
	bh=C5LRzyt3oo2JT6kA6coJPRMj/DRwEtkBY+0Fr/hqmB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yloyzYHEW0Ya/0qJq4v15Ez6j52XZk4hgjxb7rcfn8mCMVj4piBTEZwfzsMx2l3bb
	 xVLC0AGz5YoinshzqR2BszEJfkT84D9ezwhQRfFDON8v3Ndu/4L2SYWV2OCwUWS7o7
	 aqDhYqOya1ECph1ybsFKDvjH9U7X9rOopFV6orps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 004/507] Bluetooth: L2CAP: Ignore connection responses with wrong ident
Date: Fri, 13 Nov 2026 10:45:08 -0500
Message-ID: <20261113153753.524383950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 01945c55e1b87..47f0449588ea1 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4333,11 +4333,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
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



