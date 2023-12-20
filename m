Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AE41763;
	Wed, 20 Dec 2023 16:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7Ly7NL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21198C433C7;
	Wed, 20 Dec 2023 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088917;
	bh=0CXE1p0/4st4wHMTPhS1uSxJm+0HNOmada52NCaVpZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7Ly7NL3td+aXFkI2+lqsDqXaCij62lBX6zZ+2jfZX7ZByq8ELy3p432VS8ezi3d2
	 5X1oM86WhI3oL2KZPX+orpWU0z1TSUfOZjJZswEQxEg4eoBFZHF2skNFq22hSk3XHG
	 neVip3yKIF9aRd/0LFos0A38IqqFPOfsUcjF4YQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 106/159] ksmbd: return a literal instead of err in ksmbd_vfs_kern_path_locked()
Date: Wed, 20 Dec 2023 17:09:31 +0100
Message-ID: <20231220160936.299488510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cf5e7f734f445588a30350591360bca2f6bf016f ]

Return a literal instead of 'err' in ksmbd_vfs_kern_path_locked().

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1209,7 +1209,7 @@ int ksmbd_vfs_kern_path_locked(struct ks
 
 	err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags, path);
 	if (!err)
-		return err;
+		return 0;
 
 	if (caseless) {
 		char *filepath;


