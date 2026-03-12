Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D360D2D2491;
	Thu, 12 Mar 2026 20:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347058; cv=none; b=tXHT5HqOQqNbeTi+aPHgIgxcYWsQPZtMsW0/Vs0MaeSyZnceOaOsJ5CzS5FEu1JHPCPalLcO9DB5ok+WKp59i+GYu5cjlkDyYJhMr/4SAfEVJmasZMO9R6UQ+Pm9+BvyeZTd49ceFCvN/wRabhi1edFu0FTmkvheorm70xNHs9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347058; c=relaxed/simple;
	bh=KFi48kEwteZPwmhQ4Uengo2srzQTvrfKCetsJXWrN18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgruiJ5W2jAmixo1wJl3mANI57YvjvbMGBEG1nhZ4eVfZb/LiG5uRp/xgiiFgx+1uJKVGNbZ+h8DXrPMzE8BDlQuXgOxIZwYjAuQ/32xWou0TjD/bEge68F6u3o61gD8IXD0PJV01qATkzB9Vlu97cFW6LW2smVMOGsO2H4xWQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2PgS8zM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2PgS8zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3FBC4CEF7;
	Thu, 12 Mar 2026 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347058;
	bh=KFi48kEwteZPwmhQ4Uengo2srzQTvrfKCetsJXWrN18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2PgS8zMql5cSxN0pyZsPCcp+a0m3QQOEBwucISQ0Q5IbqA13KM5Qn0z32TIr134M
	 I9Sulozqt8NkTCtKVb0DQ9Xj17GNncQu7go1zObZ/ALpr2Fi0ChdGsTFTHj7fTmRP8
	 VBxiXC7rtoSwOtuO/B9koQHc+hc21T6VwzENOzyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 159/265] smb: client: Dont log plaintext credentials in cifs_set_cifscreds
Date: Thu, 12 Mar 2026 21:09:06 +0100
Message-ID: <20260312201024.015474963@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2197,7 +2197,6 @@ cifs_set_cifscreds(struct smb3_fs_contex
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);


