Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285682C027B;
	Thu, 15 Jan 2026 17:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498127; cv=none; b=DtCdtpoTU2L97SnafDGAB6vOFYDQhhk+hrpvC8dbff5x3lzupDPpQTfJCHIS1NGTLDc4T7KL2WvvfBGQulS/RqL33BVkVH4f1Rzp5qhknIFJ3Qzpew8i0WXnTIjOgHyv2Sr3li63ae8GI9LuyQr4g5d/m2YN+iX5k2Vnhz/b+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498127; c=relaxed/simple;
	bh=AmluADb9lFN+QkxIDOOkcTm5Hx90Gk46SUEZp+hyxEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDBfM5wnLh4veRg41heizextAzTV//7ehQVDEDMNF9475ZcJF3MtVDJnzZk4ppeNMvTSFZ47cnA7b/CIC6fo9vmxLyutyOWfrRaSOpa2xAV50s8X9/45ewb6u/1XKKY7KMkI/906xZAEDSojanY9XGSbhlxdsvNgIOJBwxka4CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcoruFom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcoruFom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B36C116D0;
	Thu, 15 Jan 2026 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498127;
	bh=AmluADb9lFN+QkxIDOOkcTm5Hx90Gk46SUEZp+hyxEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcoruFomEN0Ldl0ziiifLIU7S4JXU53p16Rm229WdklMJa8cqK01xDckTEL0by7kY
	 wL6h+sbpyNTmdHx7qtsogtY8JFOvscbrElw4TUDMRq74utmpW9P5NkDzqeKebXbbC0
	 MQQvS6KmgKgUrcvHQw/39rRbbcYgIzn3w80VzChg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 323/554] nfsd: Mark variable __maybe_unused to avoid W=1 build break
Date: Thu, 15 Jan 2026 17:46:29 +0100
Message-ID: <20260115164257.920058042@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -990,7 +990,7 @@ exp_rootfh(struct net *net, struct auth_
 {
 	struct svc_export	*exp;
 	struct path		path;
-	struct inode		*inode;
+	struct inode		*inode __maybe_unused;
 	struct svc_fh		fh;
 	int			err;
 	struct nfsd_net		*nn = net_generic(net, nfsd_net_id);


