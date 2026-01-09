Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3241D2EAD10;
	Fri,  9 Jan 2026 12:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960649; cv=none; b=LcQRqPoQRjX/WhXgYcwvMmbTE5+mc5y47oKDzPSdK/kDQG1d8ANPFc2zL0Nj7Tuls1FJjwXfFJyuAOKnriDpdbR/FPnsZR0B2Ua3KS0LfnOipz7Ns9jYv8prJ1SgCYk7zXyZKNieUXtXHn7Fsvhs00pNm/jEra7T+jZfQZwn7IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960649; c=relaxed/simple;
	bh=zles2RY4EwDni0zE8aLcEoAimXvygg0HCB/BE5Bn8qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgWaXAl/QjZMAr3THdymwrS1GzskUSkhZ+hIw3YLbeuHy820vGLuB0P/oYAoifLKy//4XgcPv9iNtfjkkexa43UmSifH/A5NlDj4EKXduB/Cd3f2YgTvbKkSBL/qygwoRzzYJ6+aNUicd6ZL6UsjLjsTk4Y/nYiy7+BfJwSCU3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDlpAlAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDlpAlAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE208C4CEF1;
	Fri,  9 Jan 2026 12:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960649;
	bh=zles2RY4EwDni0zE8aLcEoAimXvygg0HCB/BE5Bn8qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDlpAlAt2sK/xapYzYGNSL9pwO4HGfRVWgjwGyeF0A4rjQuKWc+e662KNLCtwZ1J1
	 zf0CShJRmtchm2neeIU+wVGAio8AN8+XtzpGtRcFrsplk8+3UcLNjcv/i7TpZeayjh
	 kpQ0wdLF6oEaEY0B6QeAHTg8+7Un9tdunOQqBEcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 477/737] nfsd: Mark variable __maybe_unused to avoid W=1 build break
Date: Fri,  9 Jan 2026 12:40:16 +0100
Message-ID: <20260109112151.929427958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -1014,7 +1014,7 @@ exp_rootfh(struct net *net, struct auth_
 {
 	struct svc_export	*exp;
 	struct path		path;
-	struct inode		*inode;
+	struct inode		*inode __maybe_unused;
 	struct svc_fh		fh;
 	int			err;
 	struct nfsd_net		*nn = net_generic(net, nfsd_net_id);


