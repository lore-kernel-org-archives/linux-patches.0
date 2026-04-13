Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C6049620;
	Mon, 13 Apr 2026 16:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097692; cv=none; b=jGYDjiH6yir9LjCjEc0ScgGANaKCr+0gLkZJXGFLpwiOHqDIStMUGq7vflx5AptG8Mp77l+i0La4vKK3sI/jhuxZhW29CEgVa8errgC91uTDqleDnQ80VbOllS6VQ7qPd998cyygETMt5mEecjZM/kmv0amG4L+JbEXcm2wz3F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097692; c=relaxed/simple;
	bh=J33gXQPORFGTIUsW0ZdrSFDjXZ41ZK309FpEFm7fmjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4pPxsASwZAstk9AStg5mzv+W9BZl7rFx0SzvT75cLw4ksVS0leAHBeSmko6LebiooRd/4tWTNMaQ+Sm58rM3C2zNttAD3kdtKhqWk0jqDrAI3YfXUdvR4T4WYUFIIUOkcI9pnGUYwrqF6ZFk3ItP1iGTSXiHc/awATAVph2giw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGeI6ygI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGeI6ygI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF858C2BCB0;
	Mon, 13 Apr 2026 16:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097692;
	bh=J33gXQPORFGTIUsW0ZdrSFDjXZ41ZK309FpEFm7fmjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGeI6ygIQ7hl0fGWo6KG41q1+LUgu1chONHquSY3g/EyxQt6zW/97l8GCjVDhRkeI
	 5AOW8sjgX9uM1dLfkc2GeXb5sKyLkwEw9ErxhUuE7CdSqz9AefHymP0fJW6tGpm9Q3
	 oW54RRJr1pPgER+4iLts5GLjOz0cFFY9cijFBNVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/570] smb: client: Dont log plaintext credentials in cifs_set_cifscreds
Date: Mon, 13 Apr 2026 17:56:07 +0200
Message-ID: <20260413155839.306375666@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 2f37dc436d4e61ff7ae0b0353cf91b8c10396e4d ]

When debug logging is enabled, cifs_set_cifscreds() logs the key
payload and exposes the plaintext username and password. Remove the
debug log to avoid exposing credentials.

Fixes: 8a8798a5ff90 ("cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1874,7 +1874,6 @@ cifs_set_cifscreds(struct smb3_fs_contex
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);


