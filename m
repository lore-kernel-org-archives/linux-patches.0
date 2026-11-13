Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590834;
	b=GrIQbfokK85Zve1cOFDqZDMr4aM1Srekoa5Vw6eb61NAivpHY5bKZSdsG8lUmuwhLlm8
	 7cSLfziyYcPfU67w97/173OeQ6btoMaUCT/ebLRIYnFmH0aNqmsybcYQcg8J6rnaem4iD
	 IC9+0xxe4U4iMwdtVysiiIluDyrCkFsN4Hs9kc0o2qcgd//vEldHiR4iLn4lrPJRJKuEZ
	 yxNHQ1dJkqytbKN82vDUhSTXfE/IOojMdiuVdiVlHuCY6aB0bBeh1rCUahMhxa6qAFZeR
	 NN+lnR22zJSx54EXlBNQbStbW2LrlwTT1spnTZN1CgtmuaCs8UDoA97vLlgEhqVe4ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YCFIdj4HveMnv0kPyKAcnoIKibLSQOGsFMOqHBV5siY=;
	b=y7qLLEMQgTV52LwhEmI9hjDzD38tkESqC1ck258n16sFASHmrSSa3JCvbeA5vGtvrseE
	 fFFy7th4d4BdaDhGED6Hao/skJDVdl7W26ngMP/M6/72Du29mq3MZkTQFbaT7BCmLAPji
	 p/4qmU8purqDAow95dyERjvb9OOlFouhTm/VmPoqrF6xIlUxZkqg2qoIV6VN80AIPu7YO
	 QFhvzgeMVZeC96O40L4C0Obi82PyUNabvtR2TYu2T1Dci99a3S6qYL9iriuiVvxGamzBr
	 N6KBv3ohzvNVR7apE4x7dyTsjDkOs+vA328KIrSS4wlswn4lOEecDoilAKYOYkFr7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HjUwxsMK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C98607E075;
	Fri, 13 Nov 2026 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HjUwxsMK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D461F000C4;
	Fri, 13 Nov 2026 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590834;
	bh=YCFIdj4HveMnv0kPyKAcnoIKibLSQOGsFMOqHBV5siY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjUwxsMK5rjR8Xhbdd4P4WtWrLc6cEoiuEPs+YmSYezjEXtrNM/JrrbbRyhpCVotp
	 t1+9ibHBuinnsnwc5aaooOBV0iaJ5ynZ0fSsgRqjurRDhns2B+u/opGzXKc4zHbVd0
	 LLmI5lChr2kGDdq+T4MT62Z1rqmy+OH5QT9IdNfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinwang Li <jinwang.li@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Siwei Zhang <oss@fourdim.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/670] Bluetooth: L2CAP: Ignore connection responses with wrong ident
Date: Fri, 13 Nov 2026 10:42:55 -0500
Message-ID: <20261113153811.566443097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 2f107c036dd4d..514abca6ed88c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4300,11 +4300,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
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



