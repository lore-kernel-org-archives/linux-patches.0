Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9433AC0D3;
	Mon, 23 Mar 2026 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282309; cv=none; b=VG/YGm8TMVjxZdMw8ZiFBoNotSj9j5jazAjoGrCM6f9vpD1Q+vcw5EvXTxdful5YwGJ7pFhsg97Ft5j/NgLfzYdlYsJTUT58nvigFT7qITrcPbK6d4bpOd3zgDZ1OevwLIaub7nU5w/wBpSyTY5D1ChOi2KgC7Y3dn3d+K8Mf20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282309; c=relaxed/simple;
	bh=6wJ+NEbOz/+Ftq5PDQHXxSl3uuSh2mzpQn6V0LIndcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fp5RDxokqL066+R+XUCTXC7qu4booTfVrYz2UbiuKbiIRvl4SZhiVRbB+4y3WP4jTPTjl3fDDt4mtHDMeni39bpADlDyZllWC4Jx+XVPGz2c0ycrjOdokxC/gGE7CDVY3XijpvROuSBizH89Jrz3p6XfJ62uX0SA+kW1u5gewko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5u2zSIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5u2zSIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45213C4CEF7;
	Mon, 23 Mar 2026 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282309;
	bh=6wJ+NEbOz/+Ftq5PDQHXxSl3uuSh2mzpQn6V0LIndcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5u2zSIguXmtBoP6FP7+j+XxZOZmpd5Pc7yKpkRnk+Qm+tkOgSjt2QZ3LpOML/8mW
	 ciFDWPvYqrMEEJI/L2A9kzMueB/AZtztQ9t2RV+CSNKj53wu3IDK1/UE4sxSZa2crE
	 HhlPON1XyBN+Bqiy+GLNDsJWnRVRcTEdyygc2VvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 092/481] smb: client: Dont log plaintext credentials in cifs_set_cifscreds
Date: Mon, 23 Mar 2026 14:41:14 +0100
Message-ID: <20260323134527.520613214@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2178,7 +2178,6 @@ cifs_set_cifscreds(struct smb3_fs_contex
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);


