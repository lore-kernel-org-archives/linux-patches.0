Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034782;
	b=cshqkmHX62o9ilcpf8Sb1qGc1WEuDARXC6gi9oFUEM8LKLL5S0XEGGpc257Go4R9gIkT
	 9HX18B32Wtr4rqy7c9+4PN6lRkz/iBbNwEJhqImQS/4XmVtYbXhtvvdd8XAqNztKV5GQf
	 6o4yFIJGuGlG3tM4DNkEf8sClNK2NwrTCdzKZaUR6ohCy8lE5HOpNG3R8S3AI/wEWv7f9
	 2Bp+6ahiYYPSPUXLv5MXBIHnBLTMqsQqeSJiB7g41AY8ACKJ+78uqLndbDcVhFLIa26jc
	 w+OwfHOZ9LvN89xve62MeRQDLX0KyFSFy+HWhA+GkA/hsJW5dMgwM0zn+Yd9caz+vBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MAYIoKsoYYeeA7ElFkrr09ubJf56/I5lq2g4R+FgU14=;
	b=DjS9iHIzA0LH3Zr0CaU7oy2YZcRAAq3qn0ubY5fKmAf2hY3LXZWUCXbfviCDeZX3vC2m
	 o97NGo/Mshl7YaFaGSn/AaFAVcwTjHWlYGUOid5A33nolVYHS1FXRfGcNJFyxt36SgvE8
	 SLoucP+7wdIQTFmz9cBG0MxfOUDMkCybyvCBu8Y+ddpZav9/R23hnjogA3ivSvA43uXRt
	 p2NHmgzL6+12OePmnHf1YF/opLXsHCECOXXI53t8S5lRJ3ejm8JVYLA2hVHeQiZ4Pjp1O
	 vmLxPRQdqrcesD0/na8xqOmjT6TitWnhrRiTsRAEYmgLih+jzcCpMVvGdT+l+rqdI8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXtHMOag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D315C606A31C;
	Wed, 18 Nov 2026 20:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXtHMOag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366581F000C4;
	Wed, 18 Nov 2026 20:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034782;
	bh=MAYIoKsoYYeeA7ElFkrr09ubJf56/I5lq2g4R+FgU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXtHMOagAeksoHc5clg1GqqDEAtlNeQKLGhgtxriNFhJYbk2tN+Sh5nMyq9tFXbFt
	 ACIsVeOBi7vE3EloyIjG8LXurxXAX1B79tyXs0HNfua9qRVfl2HU91jxjCtGRhm1f9
	 /0QXMkOgPHbN1MBxwmE8+N7RHYrxE2AWRb2/J7BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com,
	Adarsh Das <adarshdas950@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0493/3318] smb: client: delete compound mids on send failure before unlock
Date: Wed, 18 Nov 2026 15:18:35 +0100
Message-ID: <20261118150331.800383588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index facf4c6b180da..85ac020a33379 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1180,6 +1180,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
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



