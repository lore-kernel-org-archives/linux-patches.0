Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107AA2874E9;
	Tue,  6 Jan 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720457; cv=none; b=L/rysI2RBSw2NB4j1VNDRrR3fB3NNT3/FBfB7hyp9xjT/ctie1QT+9n14ll584DSENK9e04QtNzKBHsF1N14Sob9KKGwgShHuCSgj2SCzX/j51/n3gUWbsPZ7deSlbgmbcE0j0y+cE6//Z8Bm7Qy1Vs2MyXFRrYNJEPsZyLfVy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720457; c=relaxed/simple;
	bh=lf2BA2khvc43yLxJ6SI7WQ0+Fpxs8JFAFpPCEy3qDJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHu4uBEU3OvrC6v3aqvzU9ZcTjiiX1n0vhfRsvxDHYqk5z7x/Y//QafwGEjw32+njwvmM1eO/NhXvpP1300DnwNqK/C5rQzo2qXEejdnEP5s63JBKyn8sXCucm0j4uuPbMTgiuWRRhrP7KLJlKxjZOS8Zmk2q6ciRof/k/FhT88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPjwgMVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPjwgMVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD01C116C6;
	Tue,  6 Jan 2026 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720456;
	bh=lf2BA2khvc43yLxJ6SI7WQ0+Fpxs8JFAFpPCEy3qDJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPjwgMVsrT8RqLL9rCdTk1GX45a4yNugKVJGNS20/+yeu8R2b5GGlRffEODSHpa9J
	 QVdeABjT+s/umJSaO5+dfv9Sqp0i87HzeKRHij/rQGUhfR6iJSMlzM3egeiSj4tWCP
	 m6ll9jgliD39nYy7MRUI5nNxn6ocvv7D6bL97AJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 241/567] nfsd: Mark variable __maybe_unused to avoid W=1 build break
Date: Tue,  6 Jan 2026 18:00:23 +0100
Message-ID: <20260106170500.232397701@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit ebae102897e760e9e6bc625f701dd666b2163bd1 upstream.

Clang is not happy about set but (in some cases) unused variable:

fs/nfsd/export.c:1027:17: error: variable 'inode' set but not used [-Werror,-Wunused-but-set-variable]

since it's used as a parameter to dprintk() which might be configured
a no-op. To avoid uglifying code with the specific ifdeffery just mark
the variable __maybe_unused.

The commit [1], which introduced this behaviour, is quite old and hence
the Fixes tag points to the first of the Git era.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/?id=0431923fb7a1 [1]
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1017,7 +1017,7 @@ exp_rootfh(struct net *net, struct auth_
 {
 	struct svc_export	*exp;
 	struct path		path;
-	struct inode		*inode;
+	struct inode		*inode __maybe_unused;
 	struct svc_fh		fh;
 	int			err;
 	struct nfsd_net		*nn = net_generic(net, nfsd_net_id);


