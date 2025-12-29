Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8933344A;
	Mon, 29 Dec 2025 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025897; cv=none; b=Or7sU9QqvTGG7SmMtno1hMMJ3tWUECPbqV7kHwVLjWdw9Mcxd06s1JsF+bcj7ckb/q/KEtQ0SI+Q2LN6CkrwkGllBGmQT6qXCULwFBHf1pRYAY0HVHq9X4ytnCmj/Ch7iGPA68zCXAN0hXFTpbAOgiG42C1ESB1h4mmIXwIsGCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025897; c=relaxed/simple;
	bh=CjsHgpCX6xudc8ndLIosxcL67kX3LZplEJ0wWbNyDgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFBmItGtFOWd/ebBGfBK0otZayDEqTyi4nqY08kXLn7MwykRVyfZ3h0pYZ3HKATAXLqnmttv8eqfooXCUzMesRQP9Bm3zn2FZElA8SWsHPk0nXwtABj7p6H7fe48yOTiJryevUT/t+sAn5a3flOVkIisGxT0/9VFnIicCkRewgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wf5NSU6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wf5NSU6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294BBC4CEF7;
	Mon, 29 Dec 2025 16:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025896;
	bh=CjsHgpCX6xudc8ndLIosxcL67kX3LZplEJ0wWbNyDgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wf5NSU6M1EfYxLs8esSbfKPPL7/DuNkm5yWCAVrKYMM6q3UFhBXGek8Vp3GPipXOX
	 d/OaTaiIUWsT2rnDDdvUFuRsOi/UffzeqzyqwVSsWLqkVlIV7s9rOZJNHGoIRConUS
	 ou3QeJoSNVS2EE0W6EWZNckkxpFYTTCDssXqqEE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 374/430] nfsd: Mark variable __maybe_unused to avoid W=1 build break
Date: Mon, 29 Dec 2025 17:12:56 +0100
Message-ID: <20251229160738.085794935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1024,7 +1024,7 @@ exp_rootfh(struct net *net, struct auth_
 {
 	struct svc_export	*exp;
 	struct path		path;
-	struct inode		*inode;
+	struct inode		*inode __maybe_unused;
 	struct svc_fh		fh;
 	int			err;
 	struct nfsd_net		*nn = net_generic(net, nfsd_net_id);


