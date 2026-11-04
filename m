Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831321;
	b=usYyY7lkVPjoFr7DiVB1OaR5WukfYjT04GWtLKuuQuifPXyNPPBVBjhpN0O3vJeEc7bw
	 a3voHJ0+xAIrluobnBcIFOH7TLsTcvL/gU8gxiRbIbELPlFnF+3aT8aOIgtlTUHg8Bvf1
	 wxWsf0Ix5MYInCxitE/XH6xjStEYzOo/S16TFWttapMJ9GVzU0oq+NqO6U42G5A1dNVM4
	 8LyK2qa81GLEpYWM1j6aJoNFqmrM2IZ1I367jsM/dOVMPoxZAx5B0J/zVR66Ard6siusH
	 T4QdVr+IZ8ZkIkL0VGyY+apxEM+54sBj6VBpitIT2rygqGx5x0ynJZuexPTOPz6ekPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qVGoVnVVycOnVTSTWlK0Z85j6t1POayQPPKg0vk5FKo=;
	b=rM85iINLltm61z+kG4sWjUu4ho9jUbXOw05Nq6uwCOHJyGolFfVP6tnZ5gKVIC5LFtwU
	 4SHUogG7rtH/ZdBOCE48RqAk5V/FqG1v5j3Jer9kGRIMzMrLqKts+ypjv39iUc56AX0kW
	 s8hTgFAFFvPaj6ql11+yEh68zbyBZ3dC8RSCz6YG1LhXlF6mBxDJf2KD2ALrgZo5Xh/uf
	 Jx8Jyd7iD0u2f9PNOXzIzClGnz9LVzaupn+tfY+ChGR5DzcI1NL1XWoyGBh0fUggD1EDJ
	 Q0RG2SVoupFRdjSI12LwtyLKOXgBb7pUaYHAiQaYyB5MgpXpCAJ0ntrfWbheVQWDKtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYHsRur0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D420606D80A;
	Wed,  4 Nov 2026 22:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYHsRur0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5B71F00919;
	Wed,  4 Nov 2026 22:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831321;
	bh=qVGoVnVVycOnVTSTWlK0Z85j6t1POayQPPKg0vk5FKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYHsRur03Ha6SYoyZP9GAT5d1xe0RSdX3hsCqijmuHlx9ZazLXnHz2qr2BSblJiFE
	 WV8FUcqpKxE+ftAGE+JDzWuzFUuN7kfeesdX90lK01GBEX6OD/fJVuElik6I2tGcAx
	 j0ZtiT3WRDxN/fnn69lKlgAAC/2pKQBCFUyEyQRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com,
	Adarsh Das <adarshdas950@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0594/1005] smb: client: delete compound mids on send failure before unlock
Date: Wed,  4 Nov 2026 16:05:27 -0500
Message-ID: <20261104211100.500806547@linuxfoundation.org>
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
index 342664eae295a..446edaf94cf4f 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -976,6 +976,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	if (rc < 0) {
 		revert_current_mid(server, num_rqst);
 		server->sequence_number -= 2;
+		for (i = 0; i < num_rqst; i++) {
+			delete_mid(mid[i]);
+			cancelled_mid[i] = true;
+		}
 	}
 
 	cifs_server_unlock(server);
-- 
2.53.0



