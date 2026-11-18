Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019669;
	b=32wK7JMDu1hzawcD6PIYvojN0rJRks3D1803/Ck6SKSuqDIDvxt6BwwSXDLrrrC9aTC/
	 GZaZ+COeQjVOkj4Jwl+5GfqrA276iA3taZVeUho55GqCHduizk2+x0akYqP1cEsijdrc3
	 bki94Bbym2ZMotrQktiBkCUeLBsHd53y1aWohgLk9oJyMB3JjfCGZrUHogqwtUNNNYcAJ
	 xG8XmKtOSixcbSD+sRHq7RfePpBIzWg+O+WocDGz61GhXbYKuaKYtFqedwErXu5WBzJaX
	 a3jiISs0mLiQi1Gl2JmRJ8X0GwqynHht3mOqb88kyg/g+yjs6YnMTGZoWDy2/zZA3/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFLNg4VIA5VXALpM8w3abM8roQw5Bo9Qai8/DGOqDoE=;
	b=ClcwZlObk7WpS8LA5chFgwj4h3niPJReGKMeKLq7KLnCXMrgOjBrPHCSFpb5ze47AocO
	 DrlnPL2SOalglflGdj4jJ6Hz0ZchWFwmcoQOmW/XMKyDzQ+ZfgVyfy61oJmJx0HNHhZ07
	 kU6N3Ugp59kZa90LhZvHnedJMjzBpltt5dZ790/UktQF3yPJqiKX3XEGA1z9gHqnF09ox
	 vDTokXB/ILRlgXBK2uuxQ8orsq1M/OMbnPh4O98shlyjSqyMatTLKEiYu/Vg5TkjoFMZy
	 jxRj2u9/7Zki4wR+tW/ycbUijpUoHlIrFQ3whe6VsOImDxZGdWtYAt6wQDhCIgU9c4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPjw3aoy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E64606A33E;
	Wed, 18 Nov 2026 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPjw3aoy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A6B1F000C4;
	Wed, 18 Nov 2026 16:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019669;
	bh=UFLNg4VIA5VXALpM8w3abM8roQw5Bo9Qai8/DGOqDoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPjw3aoyrMsB6FFGq5zyJ77pC6xADkmJNpms8NmreHYzc8oDWCq/BGgbwhu8A2ZBZ
	 7cAedOHKwWmMfqG2qC8Iu1bv1uNaRvv/B7i35ivtP1fW1DA2w3oxD21SJDUjMVGezM
	 y3xfkUnqmz9lVb951tPBc7jJAcY9bSQka7jDUglc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1678/2651] smb: client: log the selected security type on session setup failure
Date: Wed, 18 Nov 2026 15:48:38 +0100
Message-ID: <20261118150348.093580568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit a4111beeade900346726acb2746f22a6313aeaf0 ]

When mounting without an explicit sec= option, ses->sectype stays
Unspecified while the real mechanism is chosen later through
->select_sectype(), so a failed session setup logs a useless name:

  CIFS: VFS: \\server failed to create a new SMB session with Unknown: -13

Resolve the mechanism through ->select_sectype() before formatting it, as
cifs_debug.c already does, so the message names the actual security type.

Fixes: a8fce7c807b1 ("smb: client: improve error message when creating SMB session")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9795aa0661d55..230b7a4a500e5 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4184,8 +4184,12 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 
 	if (rc) {
 		if (new_ses) {
+			enum securityEnum sectype;
+
+			sectype = server->ops->select_sectype(server,
+							      ses->sectype);
 			cifs_server_dbg(VFS, "failed to create a new SMB session with %s: %d\n",
-					get_security_type_str(ses->sectype), rc);
+					get_security_type_str(sectype), rc);
 		}
 		spin_lock(&ses->ses_lock);
 		if (ses->ses_status == SES_IN_SETUP)
-- 
2.53.0



