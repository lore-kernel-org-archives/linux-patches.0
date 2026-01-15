Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990CD3C199B;
	Thu, 15 Jan 2026 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499539; cv=none; b=MyAE2IXU7rOdGiS35DspJ7yS/951uTDs2ufZmJr8Fb5s+szg6Rs/EqvSvD6kBlbWbQk+PTTBRTlPClYBOZE8/YIta7MpnBej34a/4ZY1fx2zt+os4mNO7rF7z7QreS+8F35GpoZfqdnLaG5Q/3ScirbHXDKhiyOoNa1K0drPp0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499539; c=relaxed/simple;
	bh=YOc3X0pEyw9YuBdvE0+ySOfqMPGAy/L9K0VNdL6srkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQkWuUvx7VQ4rlbpjRAzEcYlKN2XnndosSZz/1ui31J2xGpTYe4DVOxgcJSvPIACCUzHS5/642PjeyoQZJlB339ZwDGLS74Uhbqq+B0WWuOEEwFGpr0UoqXo4XHtBJDHToE2Nd3sLkOGa+HOUpXUgB6cG0sZ7u+LiL8LwnuO0wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5PjZXrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5PjZXrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17374C116D0;
	Thu, 15 Jan 2026 17:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499539;
	bh=YOc3X0pEyw9YuBdvE0+ySOfqMPGAy/L9K0VNdL6srkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5PjZXrqeHTjSvLUWmvLy4F2yC+1W56G9IdGRlBMS/sVTaSSvv32qNFHvwv/qkCrw
	 RDHQ7A7r3L44jOr3a/dW7nDfHYUqPT56Gm2tP5CWQwKKKSOwPerrqTKuuntQye4nom
	 Grl65bHEYRYtF1jR2Hp0gPJti+VpB+6QYh0hXw5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 261/451] nfsd: Mark variable __maybe_unused to avoid W=1 build break
Date: Thu, 15 Jan 2026 17:47:42 +0100
Message-ID: <20260115164240.328491735@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -984,7 +984,7 @@ exp_rootfh(struct net *net, struct auth_
 {
 	struct svc_export	*exp;
 	struct path		path;
-	struct inode		*inode;
+	struct inode		*inode __maybe_unused;
 	struct svc_fh		fh;
 	int			err;
 	struct nfsd_net		*nn = net_generic(net, nfsd_net_id);


