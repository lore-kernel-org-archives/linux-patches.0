Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BB6383C7C;
	Mon, 23 Mar 2026 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277832; cv=none; b=NzIkVdyLKDl/SUWV4i958APEg1ML6XVeWu1dy3dtOBdt/FzbFou0psWzAs4cUxnzB9Ogb45l9y+tp5kZzfkSqqglvMaSSX3gyl2+sFeF6i9wKSTMiSMGa5s7FTP4dpj1cANXu92kIRzUgucyI1eO3NcIdlFBjKF9BqSU/Nh2qzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277832; c=relaxed/simple;
	bh=UdXwbu9Gi5KiKhXYDLv4Hnp3Wss6VIXxYMVyCd94nZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1OL0Uia1XocvCmuXlUlL/3pKXWwUYbM0d+q4oGhtWkB9gPjyqqMwE6GkvXfHqyXaza+ju2iifiuY4BI6s8HWZQasUaNMhA1bdwUbWfTtA6MeuZMS2uihsglYVFJ/6c5fnwoF4c8dvnLOhJnh/NGUnTPHQNj4wKD9W8UiqbrrPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4KPspfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4KPspfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A7BC4CEF7;
	Mon, 23 Mar 2026 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277832;
	bh=UdXwbu9Gi5KiKhXYDLv4Hnp3Wss6VIXxYMVyCd94nZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4KPspfxDrHxlqV2ZcF4/dPDNnPk+PDk1DbREbQxyLLMsKf6be3/OFckML2GEz0El
	 KdDdQZqTrWO/s4fHmsutn5rwgCv2HfSIPAdykQ6bWmQIMoCBC8/Q6VADYiUPM37D8i
	 44LSmctZYDQUryC3pS5PluBMqGNQRqx294hCtnlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 117/567] smb: client: Dont log plaintext credentials in cifs_set_cifscreds
Date: Mon, 23 Mar 2026 14:40:37 +0100
Message-ID: <20260323134536.706372308@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 fs/smb/client/connect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2214,7 +2214,6 @@ cifs_set_cifscreds(struct smb3_fs_contex
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);


