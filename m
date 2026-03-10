Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3E93803CD;
	Tue, 10 Mar 2026 11:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142060; cv=none; b=HCO7MPjhc6vCxb2im4EEbaNeEJfc1ccfzNXUvqPWNPqhqG0UOVF2gCxVuJZ6sbXzU8oNXsF8QWJK84VrXEn2bVRJaITug2Wki+eDqD3WIYIjGIAbPCjEsuZJ/XFCawkAb83UgOMTVTafq1H1TXXqXT0CI1RMcWxGFpWtZRHxctE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142060; c=relaxed/simple;
	bh=jrOwvkvZwoTTJ62Col/5P9PZTDwZxTKZQQOS/JmhWmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3hU3L+Qgn+UmkycvBAwFAK+JS/u4yCx3INpJzr3yhVxmduy5VrzhUWCUogSldAJC32zPahYSXrsTZwSaw1+2KZoRambaduLwdAYAZ6cQBwe2TirM/nkbsGt9pCdE4bCm622M6wZoJLztlE1NwhNUYm7Lg9Zdlrie0hb3f/V3R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojBiBYyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojBiBYyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA871C2BC9E;
	Tue, 10 Mar 2026 11:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142060;
	bh=jrOwvkvZwoTTJ62Col/5P9PZTDwZxTKZQQOS/JmhWmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojBiBYynWwjjweMvTRNtRjbp4PQF9EUkDISVWt3Kq2prGgN280MEddMrQS18OpQaN
	 e4ewEHuJUWIw5oZo0ED2+NSGwWkZrc+68aHRLk2NhniyExvqt9qj+6gOkaUw4FOU54
	 8KAK+5WL+Fi4+qd35D49iLuK8S7QN/ojDeGHeli7oVkRE7SIluT+Hp6ZIYIDLjV8cu
	 sucfXxrsuGzGamPVY4g2J3y98GjTg9zX4YBmRn3nUak1zWcVBpdf51dN7O0sZEItav
	 EX223VW/rhlNHF+vBJHu7CYEbVxhi9BnXgn+IGJHt4rI++AoqzXJ0OSm7y3rZ0pNpg
	 GMT22Vnr+mMgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 186/314] smb: client: Don't log plaintext credentials in cifs_set_cifscreds
Date: Tue, 10 Mar 2026 07:17:25 -0400
Message-ID: <f6327cc4a71fe2b6cd9e06af9e318254b0161d6e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 2f37dc436d4e61ff7ae0b0353cf91b8c10396e4d upstream.

When debug logging is enabled, cifs_set_cifscreds() logs the key
payload and exposes the plaintext username and password. Remove the
debug log to avoid exposing credentials.

Fixes: 8a8798a5ff90 ("cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index d96d23a8f4903..dd7f48f530979 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2235,7 +2235,6 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);
-- 
2.51.0

