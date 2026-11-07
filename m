Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061416;
	b=b9+MUNP039PzbGNEOKwprBcGsa9K15IA+/7YDOQ9c0dy7jhKRoXxN/RrTtBKLS2SRaKC
	 fgzbCe1YtnRSJ5KH4OncvOuDq3RngpclDmUyY3tPRktNyOwl0aaR5G+l8F/UBRRLG6Nmx
	 tcZKrLk3yahESLqAkWtl7aVSujHTXT4DjAI08kGmI/3qZZyww6/pldIa8vPqCN9+U6jvk
	 0Dz8Ft+GoxrKcfWe2gTJIK2+Q5uBATo6BeULFF3+I/i5llnA9t5DQFrYbZVxUzRTcDajs
	 mQPi3iGHmZ04qFuyCrGnBmuqt/6l2u44UlhHy2LYc4l6F7vD3c5g/2X1vZbt212U+UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ekhFhfhMxeluHJ0qwAF9u9sgHUx0awebfw0uhw2OlNw=;
	b=wLhzUnlchalm+VjnZ7gDYb8seru3mOSGytzrvHU3SJzJX0eIA/UHQhoJMP1/sFuJkxs+
	 E0R2iPkaSubXhf/LQkHXawn5bK27UYWyCwHbbnwwFSj2QgBrT3XGHmsNy+7g+7Hw1FcGc
	 kPegOzhQI8fgpIPYPuyvyYt4ucxHTzfyev1+XYKMkddQhOMrnpJa+FXms+c5PMwA0w6SF
	 Eyjl4kHFUzvUYisvQHXgFhWhOofqGBpT14n3iWXeDr/1f2NaGsw7/mRdkUWgDgwEdEini
	 pdosnHJgNDq46WCobrIshm2RJecS/U2VJnibCc/ltomoSHtSDRtI+T2YKS0Gm5rvfWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfgbUacg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7862606A32F;
	Sat,  7 Nov 2026 14:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JfgbUacg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A79B1F0089F;
	Sat,  7 Nov 2026 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061415;
	bh=ekhFhfhMxeluHJ0qwAF9u9sgHUx0awebfw0uhw2OlNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfgbUacgRQ4DcJkfwwlOqp5LvA9ajaQ5Wk9hMes7DDKj+BjuiY9z1YHmD0voaleYT
	 QyJA6UnW+cIwTIkfaGtP4rRup9mv9SV4kuwUP+tkVVkj7Tt8nIFSWGitYKnmVnPiyX
	 iHmXJOWO378hDnbZvnjIykxS+FjuulM0a8EQf9LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com,
	Adarsh Das <adarshdas950@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0528/1536] smb: client: delete compound mids on send failure before unlock
Date: Sat,  7 Nov 2026 08:42:24 -0500
Message-ID: <20261107135012.447630791@linuxfoundation.org>
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
index 9fa0c4161bb88..54827e8cb806a 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1170,6 +1170,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
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



