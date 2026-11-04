Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826992;
	b=YVXYPP5eEYwSP2fukmxzpTtJ74tkWqu5A81/83GjUfs8nFZss1X7YO2+XgVCBTuDQER8
	 +9YLW1oelKoa7yMJ+7MokIJnEdtQ+P5sLAul9fyOK/NbiWsxoHuN9pVfDoomXdSYgyT+n
	 R9Oia3BnH1jTafx4wtVIWyYnxIerWCd9H0vh0HYRjjhlPPl5Op4INnsW8Ok9Bg6RbiMyA
	 1EJtt7ueF5YXr/Ij4U6lpB0Y+Z1h3UkGsb0t36uNnDPaNCQatYFVWqztM/HlogXACuH2q
	 amqbJj/95Mkw5hW4JQrP5p82sPLbS1FolnRd67HxdGlKNo9vjQt1ppD+pmtBpYnBUYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RNHdxVAN9TdRXkf5XD6CcWR15LktiY6E414X9+Qjw28=;
	b=Op9MYKUp+3GZRp5Vi+37cyNbgdXF7hjf3VbBbgGgKB33U4UUKc8P71nvLaZVxYTNN93l
	 0VC0F8nPcEMEZB8WrAkI2YHAbP9zVp46gC2devLZ4muRBcXhO3t+wYbZbjp5VKumrNh/x
	 4qDdOokscrKg5Q7Co2bxF3Nrid6oKXCiIUajUoy9D0BhjouGbUYSZpQ+9liXwxWAi4dj4
	 SklN6x4X9yvnCvR2NoiRwJBCGQENrbpBTbQD1wa3M2j5QrjuOVsh0x+d0+ZvYTIRqQ/Ng
	 Bh1/Jco9CrAMpqwTUUYKXLyKOB/5QbXSNyErh5x35WsqBQuDmXhK5q9LlCWACYj1bxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ySnJkrtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7837460BDA2B;
	Wed,  4 Nov 2026 21:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ySnJkrtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8761F000C1;
	Wed,  4 Nov 2026 21:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826992;
	bh=RNHdxVAN9TdRXkf5XD6CcWR15LktiY6E414X9+Qjw28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySnJkrtMMDMnsd+1tonevQgN/q1IRgFdgBxMT+mZCHc0i2lXCiZma1RokrSdm2cES
	 OPwBsMjEZNnXoyLRJsWsZvbjy73jsmA6rLaYKG2CgmEhhSKWgp9DpJ1T16UUSVCz8Z
	 5ljYuych/iX1KxfCIigiPq77+Ogif8LqYJMan3qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zachariah Mithani (AploSec)" <zachariah@aplosai.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 128/547] ksmbd: prevent share root removal through empty paths
Date: Wed,  4 Nov 2026 16:05:12 -0500
Message-ID: <20261104211041.817218112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 9fd1fcbbf84986a7bcf601a2b90540899069d263 upstream.

A FileLinkInformation request can supply "/" as the new link name.
smb2_get_name() strips the trailing slash and passes an empty string to
ksmbd_vfs_kern_path_start_removing().

ksmbd_vfs_path_lookup() resolves an empty pathname as the configured share
path, without LOOKUP_BENEATH. With ReplaceIfExists set, smb2_create_link()
can therefore remove the share root from its parent before link creation
fails. An authenticated client with a writable share and DELETE access to
a file can trigger this if the share root is empty and the mapped user
has write and search permission on its parent directory.

Return -EINVAL for empty pathnames when for_remove is set, before
resolving the share path or acquiring removal resources. Ordinary lookups
continue to accept empty pathnames for opening the share root.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Cc: stable@vger.kernel.org
Reported-by: Zachariah Mithani (AploSec) <zachariah@aplosai.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -61,6 +61,10 @@ static int ksmbd_vfs_path_lookup(struct
 	struct dentry *d;
 
 	if (pathname[0] == '\0') {
+		/* The share root must never be removed. */
+		if (for_remove)
+			return -EINVAL;
+
 		pathname = share_conf->path;
 		root_share_path = NULL;
 	} else {


