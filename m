Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620168;
	b=yn+QVEp7eJfgI/uaMJEhow/SuV5mhl3yt/QblbwWJARC2iPlVliUQOuHA6pxbVyejqbg
	 XEHqx0V528Di2Hogy33ia6qR6ULaL/w44kXAd7ReKqpzvd/iYPB3zNDcyHPyUt0mj9lL1
	 72tPjYFdQsk+7VrSpsnuST0POiOPNesQT+wzqo+jRLSCwpTrvBDLWhP8JdvJmbDIlRnjw
	 tCDWKwzdSksxvo/KurohnCqU5pUIUpwy6ZSw71p3oGoP8qtOQTwAuiYHKSCQL7caZ8jDG
	 mQJnffM3bpa6VwIVc6yDvEgy+36qRwOzrkTf0JSB7cn6g7F1K0S34h7p1qut1dPNW0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2yWsmR029CGZNiPdT3s69PKAeMK/knV/Im+C2oB5tco=;
	b=1f5RicmkUARtMQHVFtpYa+HHImZp4EdUfUbOR6ijWXnfEujEwuI6wG/0dQKaJtECvvY4
	 PngLdZrRQl+VfGO8EjwNHcU5R/JwNruR/jHWxHJ08zS1bqE2n9izyBrTxVNQbjpWXCRBI
	 5vSa9ccTXNR+4BprnX2dbpBHX81cuEW8FxtZD5ozHPIBHs67Drq00TE8PHsdxoOZe1BfP
	 rhAHH5oyfxe8p+ypbZ/VPYaYtzYEZj5KZIyGj2ZWqc17oIE/RJV6MNNLqraENAiv1GV9q
	 FUoo/KVch+SLRBCumuiEtWju8RtVvQsxE0kajAwXmoE4Osl9n+udNxas/Ox0hFmFf3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHgdVGuH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94850606A321;
	Wed, 25 Nov 2026 15:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHgdVGuH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD75B1F000D3;
	Wed, 25 Nov 2026 15:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620168;
	bh=2yWsmR029CGZNiPdT3s69PKAeMK/knV/Im+C2oB5tco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHgdVGuH42RIt03KCS/hgGoI6ST0tw5BTVAW/Tp38SwxXrYtgXNAdTXqcG9XB7j2N
	 9fagRZt6NVFbOIlMA3LEMvg3qh642M4Zr9iuvxuB3mCQ6ddaQN3ZDlUD/KmAqzlQO8
	 /Xgj5aFNaC1TLoT+IeEGF7slecnebBpeH7xMkNs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0829/1005] ovl: do not allow nfs_export with data-only layers
Date: Wed, 25 Nov 2026 15:36:07 +0100
Message-ID: <20261125143841.141523837@linuxfoundation.org>
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

commit fba955b070d13e2fdac097577ce3c6ffbeda4ea9 upstream.

Since data-only layers no longer require metacopy=on, which conflicts
with nfs_export=on, an overlay with data-only layers can be mounted
with nfs_export=on.

Decoding a file handle of a lower metacopy file whose data is in a
data-only layer builds the inode only from the decoded lower dentry,
without the lazy lowerdata redirect, so the data of the file would be
read from the metacopy file in the lower layer.

Fail the mount with explicit nfs_export=on and data-only layers and
otherwise disable nfs_export with data-only layers.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/params.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -948,6 +948,16 @@ int ovl_fs_params_verify(const struct ov
 		}
 	}
 
+	/* Resolve nfs_export -> !data-only layers dependency */
+	if (config->nfs_export && ctx->nr_data) {
+		if (set.nfs_export) {
+			pr_err("NFS export is not supported with data-only layers\n");
+			return -EINVAL;
+		}
+		pr_info("disabling nfs_export due to data-only layers\n");
+		config->nfs_export = false;
+	}
+
 	/* Resolve nfs_export -> index dependency */
 	if (config->nfs_export && !config->index) {
 		if (!config->upperdir &&


