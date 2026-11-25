Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620146;
	b=Iev1yOh0NMKzAOqakXfghC8xn24xi1TJ/Mvg5rW3hERsLH7xgstTSHK5bgyyGJlgTfHP
	 sSCm3H8eMjSYVbUgHZCG2GcwEZzwikrQA/Zi3BpH53899Pa2wOZPta8F5OlQEHEniwf78
	 4IrIgQ9ORHAR8f25QVOHMzAvL975EDjCumFKqAieVru1S4iEWDOzV9mQjZ6Ck8ah0qDic
	 QI38PKtVoQ8kPv0SZFE7/FyIpBEOca3U5SJV/e+/IhNxHrQ71CL4X+ZpK7SAVjnVz95VP
	 o3+ehyD87Z00SMiLWtnAdY6qHUtXnObo4N2Mnfbq9MUi/t0sI6+sxhJdwK6wvV9guXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7+1wrmHRRnRIPsLiYOPO6fCrNrtVZXgjv85Y2r6stlY=;
	b=AgV6v9EdxX7l+Yx2Fy6EmKLfJFjcPEcBxnuW5bvV67Io2IAPaTtGcqTOkpcRN7+ep+mT
	 e9WKczpW6VIymmdB2h5zdvb94RJ6PQfpt1Prqkpr8FM/lhSckkCH3E/ixZif4GpSSyrJf
	 eWqDQv0xwLLrc3j3ZFlwxioqSNf6fz3x0zdEVvuIlIa/vM/c/0Wlnbbl6ncSU+OjfK11K
	 HxXL9Yr6DxhhlMzTC+1nF1ZDbJg/pYSI+OCPCRxtX57jWD0GNvNzK1J4mhZj6S7PcAcnC
	 fqmZ4kw2NNhsELKkISlWeRI+DtI6A/5Lmdm6AaJtZXtEmLRkeSQbBhx1dkihZLo4VxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UgejikEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58470606A31E;
	Wed, 25 Nov 2026 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UgejikEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3CA1F000CF;
	Wed, 25 Nov 2026 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620146;
	bh=7+1wrmHRRnRIPsLiYOPO6fCrNrtVZXgjv85Y2r6stlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgejikEUE4IY2Bk1i9KeoKsa4MwLaCKe/PCvzfitymVz2ZpXB2YwEEWgyLmALlu1K
	 Twvb7aa8C+YyY2FiQCxTKFEys673B6Qoz80rZOxO/m1jMeuNEBujlp6VoczhQMaMxF
	 mTQMavCnjLh+CuKv+5N6nD6E3eutaMdpltSKfWOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0823/1005] ovl: do not read the flags of a put upper dentry in lookup
Date: Wed, 25 Nov 2026 15:36:01 +0100
Message-ID: <20261125143841.004344111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 7031366be218f291592a7ad38bc34a7cd1459737 upstream.

ovl_lookup_layers() passes ctx->upperdentry to ovl_get_inode(), which
takes over the reference. If an overlay inode for the upper inode is
already cached, as for a second hard link, ovl_get_inode() puts the
dentry and returns the cached inode. ovl_lookup_layers() then passes
the put dentry to ovl_dentry_init_reval(), which reads its d_flags.

With a local upper fs the put dentry usually stays in the dcache, but
with a FUSE upper whose entry has timed out, dput() kills it, so this
is a use-after-free.

Fix this by taking the revalidate flags from the upper dentry of the
overlay inode, which is the one that ovl_dentry_revalidate_common()
revalidates.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-986db859-840c-479d-944c-b9c43b93377e
Fixes: bccece1ead36 ("ovl: allow remote upper")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1381,9 +1381,17 @@ static int ovl_lookup_layers(struct ovl_
 
 		if (metacopy_size > OVL_METACOPY_MIN_SIZE)
 			ovl_set_flag(OVL_HAS_DIGEST, ctx->inode);
-	}
 
-	ovl_dentry_init_reval(dentry, ctx->upperdentry, OVL_I_E(ctx->inode));
+		/*
+		 * ovl_get_inode() puts ctx->upperdentry if it finds a cached
+		 * inode, e.g. for another hard link, so use the upper dentry
+		 * of the inode.
+		 */
+		ovl_dentry_init_reval(dentry, ovl_i_dentry_upper(inode),
+				      OVL_I_E(inode));
+	} else {
+		ovl_dentry_init_reval(dentry, NULL, NULL);
+	}
 
 	return 0;
 }


