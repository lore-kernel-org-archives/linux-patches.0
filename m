Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044050;
	b=dqF4edCdZszkO7Z39hIrUzcQzM1wSnqyyOCEpZTaYpcpca7i7ywA/C70Zu1MG2yL8CfP
	 O3kB+CBNV5fgaosxvO/6kT3TMRGiY1RUi28Wo5Sxx6yLDtdfIi/76DcJx4AaAbq5yEoR2
	 HADoeGucDxYKSfxqf57EbZVTnn0q0dL5ZrxJ5tu0mYy/TPjLKhWuCJb/1NhHW2/grA3CX
	 1uczawUrQ58TT65nELGDNHrdjGL9mz3UcLtg/FXdy2sQC1h5hTRnP6NgJUxVuHg7YJEAn
	 O+Jwfw20lvIV+wU/25GGnHXcXbjSwEVPpzdRDLiodU3LWgeMue4PHoDIcAVNTtLBgzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kD9hpkBREU725yj3Xn3UglRecVjaPaqgCr+rRFSz6rs=;
	b=h7KiyoHGGh/NljStrNMTo3s5wduDZgdIdJsl8+E2kIsA5Brwm8q5WOPtggYX8JNItIoS
	 Ye7McTlfx7NB1tHafBdek34ec5LaArc0yle3B4w5EafEwrrjkYviJbvJ0URG6FN9gL7Sk
	 P0xDkVfy/L7jfLo22pDYp2tTjoqYb+Hf1lMi74V2IGfYcCg91rvrMaLVriHb/smCVHmk+
	 nlc5+1P+eozfGBe5x+kVQglUx0A4JNjdelFbhizl79HaxGxh0k2AH3uCd6kpqGp70q1ny
	 zRkk7drqTKGakEEdA55Eo2kKU7DjNhvMcGr2sONPq7c43ERR8gyVF1EAgavix9Q7Tdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3Icmyg2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42319606A32A;
	Wed, 18 Nov 2026 23:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3Icmyg2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9EB1F000C4;
	Wed, 18 Nov 2026 23:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044050;
	bh=kD9hpkBREU725yj3Xn3UglRecVjaPaqgCr+rRFSz6rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3Icmyg2F50XOZazBb1t3+wywXmD0C/uDpTKf0xhuD8yxrQvnVdocnzEKs+OZ6Nyn
	 WYZ0lSD9GHdkV2TCOGUwWNN68QLuA8uNad3hcnDPopdwJmmLEkkDu5MkLSlN+BqjFx
	 //vE/7uXsBmVLzbkdb7Xbt122xoptYLBT9QQBlmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5003556314abc915a71f@syzkaller.appspotmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0430/2857] smb: client: cancel reconnect work in clean_demultiplex_info()
Date: Wed, 18 Nov 2026 15:24:24 +0100
Message-ID: <20261118150216.868471913@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit c65eae6f61d1778ff7a82e4aae4080e26f486af1 ]

clean_demultiplex_info() cancels server->echo delayed work but not
server->reconnect, which can cause a use-after-free when the
demultiplex thread exits while a reconnect work is still queued:

  cifs_demultiplex_thread()
    cifs_readv_from_socket()
      cifs_reconnect()
        __cifs_reconnect()
          cifs_queue_server_reconn()
            mod_delayed_work(cifsiod_wq, &server->reconnect, 0)
    clean_demultiplex_info()
      cancel_delayed_work_sync(&server->echo)   // echo canceled
                                                 // reconnect NOT canceled
      kfree_sensitive(server)                    // server freed

  ...later, on cifsiod_wq:

  smb2_reconnect_server()
    server->srv_count  // UAF read of freed server

Fix this by canceling server->reconnect delayed work in
clean_demultiplex_info() before the server is freed, the same way
cifs_put_tcp_session() already does.

Reported-by: syzbot+5003556314abc915a71f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6aa4a12d.f81106d8.2ab401.0023.GAE@google.com
Fixes: 53e0e11efe92 ("CIFS: Fix a possible memory corruption during reconnect")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e94a031c19d3c..6d3f11372440e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -989,6 +989,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	spin_unlock(&server->srv_lock);
 
 	cancel_delayed_work_sync(&server->echo);
+	cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
-- 
2.53.0



