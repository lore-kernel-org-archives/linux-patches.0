Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044092;
	b=vRpdzjvy/8eQlT8SNAj+y+pjFQYW1NCTK406t3G9SWI11I5WkfSEApN1F/slRbrPbJKJ
	 YgY9XLJ91NkgiROUkWCnC8f7GLGqXg4kIPorOUgK9CFpI2rFx6jmBZc2vHymQXKb/ewM7
	 KZ5TO/k4LuKZINJ124Nfu8XgFXnsFlreqZ3hMKLdCyOWkQilMU8qHNzYltQhSpEKOF7zd
	 fz0XuQg1EUkDmWrCoOtC+yaYR+13Yz5lXVkH0mbacJh3XiYFLtvCDryPO5hArxwmwXTDn
	 qZRwqIBbYipRljnSdGdFkhJAsmDf8VPJuUerctFsqib+OhbS1MpXY41JA9YsT/1gaoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pAfL2xvsBnad3OULQhxCKg96Oh3mCw96CxhxSOPva9Y=;
	b=cXUTsoS0vV17Qb6il1Kcy5ubNDx9hQsMtDGVYW7x6FufkEOW1AK8BMe+srzZ6m+bowPI
	 5kuSk/kjXZcIRE0UC3rEXWhGYytBphUNmcMSnIWAX+8kb75hroWDir8ooI6Sgtp1NnGFh
	 NxlbfzOptpBo0go7YeprfJeULy8u1YUWmBuIGrk3ZlLDR8UiJ2SjB9VJzbwjZSy1xjyuQ
	 E80LrVaim9KNpzN1xt6d7WpSDLnR/8XRNuPNlrM2PpYh3BZ6BU62NqQSv9S1Ve61DXQV1
	 oWmuRDKO9MdsImu3DDkBuOOt7MU4aWpHg7rSgB6T1DXObXbV+GlV9y/qro3r0bVxzJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CF38y62c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22569606A32A;
	Wed, 18 Nov 2026 23:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CF38y62c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2821F000C4;
	Wed, 18 Nov 2026 23:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044091;
	bh=pAfL2xvsBnad3OULQhxCKg96Oh3mCw96CxhxSOPva9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CF38y62cAWP3HAba1Qpt7IG379lixDx6i/C7QKacGnuldPuq4nNqDmHPonGI6R7aS
	 xCXfyEVXY2mEk+3/HEGc/MpG9OoiCuNS0qNs8oBwatzfPnMAhT5lXOmjE0iMQ1krDE
	 hKyo4Q6CTabn5kAm3J4FSuCuV3nkzffP7TdHm308=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com,
	Adarsh Das <adarshdas950@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0443/2857] smb: client: delete compound mids on send failure before unlock
Date: Wed, 18 Nov 2026 15:24:37 +0100
Message-ID: <20261118150217.330601798@linuxfoundation.org>
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

From: Adarsh Das <adarshdas950@gmail.com>

[ Upstream commit 8f6f8a48399f82f4a83f7b9f25b9707e0062a4f9 ]

When sending a compound request fails, smb_send_rqst() kicks off a
reconnect. compound_send_recv() still has those mids on pending_mid_q,
but it unlocks the server without removing them first.

During reconnect, cifs_abort_connection() walks pending_mid_q and runs
each mid callback. With no response yet, those callbacks return credits
and drop in_flight. Then compound_send_recv()'s send-error path returns
the same credits again. in_flight ends up decremented twice and
smb2_add_credits() WARNs.

syzbot hits this during SMB2_negotiate when the socket send fails.

cifs_call_async() already calls delete_mid() before unlock on send
failure. Do the same for compound chains and set cancelled_mid[] so the
out: path does not delete them again.

Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a727d22.40259c87.584f4.04ce.GAE@google.com
Tested-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index c5c81b4261985..e41cd9581cd43 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1200,6 +1200,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	if (rc < 0) {
 		revert_current_mid(server, num_rqst);
 		server->sequence_number -= 2;
+		for (i = 0; i < num_rqst; i++) {
+			delete_mid(midQ[i]);
+			cancelled_mid[i] = true;
+		}
 	}
 
 	cifs_server_unlock(server);
-- 
2.53.0



