Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7077199FAB;
	Mon, 23 Mar 2026 14:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275698; cv=none; b=AbWLDKBK79SKZ3Xxz/gLaNCwL5XS61hs+Rc9tVV9IxvrKYjjQsY09Vda4gJU0mGpd2Yt/UnSoEuKALrtEFLlBVKLI8Or5mFkBstqst8xoYx3BOmgXIZlkdqJYeHEzMvyME5j9BRV42bTQiPhmBBUFi07Z1SrU7oB3U8KQsOzb/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275698; c=relaxed/simple;
	bh=jUgPesj+ge/XYaz711lGru/H+O4B3mT5aW1VJydIKeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOqi2vmi8QS/JwBTA6C7QB6voz7O/egNIs9AdEcUyuhhgDCEty0sq+2ZPIKJt28ZBycEsKmrt1RBmoBO/uVCdEoSjyU7xs02cfmfgCtFzme8tx7Nt6uWin7l4LqyVqWQrVunq/Rv9bRVsRN8R9AO4CZHeWmf+0WfeD32yBHXcyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0U11uFXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0U11uFXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDFFC4CEF7;
	Mon, 23 Mar 2026 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275698;
	bh=jUgPesj+ge/XYaz711lGru/H+O4B3mT5aW1VJydIKeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0U11uFXP2VjY4VmhgYBim5c6FxLatoBG87IAZNq17kJU1ZIxBvg+WF7j49/eLjllS
	 JpKi+Vtyn9+RvlTH4giDuFkLHMBZnwastw5q8MopU2y2NhvVtp/mteaX9d5/wPeytS
	 QK3o9GyE1w1JWtSAH1+sfNnWd5aeUZT3kPpogG6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 186/460] cifs: make default value of retrans as zero
Date: Mon, 23 Mar 2026 14:43:02 +0100
Message-ID: <20260323134531.121647504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit e3beefd3af09f8e460ddaf39063d3d7664d7ab59 upstream.

When retrans mount option was introduced, the default value was set
as 1. However, in the light of some bugs that this has exposed recently
we should change it to 0 and retain the old behaviour before this option
was introduced.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1847,7 +1847,7 @@ int smb3_init_fs_context(struct fs_conte
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
-	ctx->retrans = 1;
+	ctx->retrans = 0;
 	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 
 /*


