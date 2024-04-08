Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA64524AF;
	Mon,  8 Apr 2024 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584398; cv=none; b=pna1sO5y9HWpL40K5tpfaWFLj1x7awKxZJA0OQwBANfph2mNnRsAp+6hY0ssSEEXhdB0DDqLtGC+/wg3siumlaJ+o8bFb8IH/l1sh77fYbTfH8gx0+XmB4JB7s5kMMfqc/YdHmvevSiTxQXXNIUrEHhHQzfdK6jWcSiJR9RNljE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584398; c=relaxed/simple;
	bh=O6wwnFcaE8n/2s5P+7m2AH7i1F+U/U0CZagyIWpUg5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gc/40VggI5Wa3tTolIvM3NsyML37R+Dt9qfXrI4JZUsJeeda5vzPG7iQx9oBe2iuIrpSikG7S7ZmmR2vFhbCpB6ZfMgbTEPzqqnm8VnTcYOu+uydRHYgN1E8jAd8Ev7FAeE78tr3ojpz1QBoY5hVCU8zb83fS1Ryz5lvWST9GEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOJ2WLBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOJ2WLBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06550C433C7;
	Mon,  8 Apr 2024 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584398;
	bh=O6wwnFcaE8n/2s5P+7m2AH7i1F+U/U0CZagyIWpUg5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOJ2WLBj2SbpengZUAucbIXDTMTkE3mHF8a7Oo/6eIQ8ZKgdd6igrv3km9W4KvbH0
	 HjsO4XsQZxOD/EwJ8lpkhMmK0u4rmzLdWUy02cx3YH3jwkUBPtZSCB6IXFvVW/r3vM
	 BMLKbnhi66bTy7frcI30iw01SJdI54p5q6RKQ2BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 425/690] nfsd: remove nfsd4_prepare_cb_recall() declaration
Date: Mon,  8 Apr 2024 14:54:51 +0200
Message-ID: <20240408125414.999807419@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 18224dc58d960c65446971930d0487fc72d00598 ]

nfsd4_prepare_cb_recall() has been removed since
commit 0162ac2b978e ("nfsd: introduce nfsd4_callback_ops"),
so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/state.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 5d28beb290fef..4155be65d8069 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -697,7 +697,6 @@ extern int nfsd4_create_callback_queue(void);
 extern void nfsd4_destroy_callback_queue(void);
 extern void nfsd4_shutdown_callback(struct nfs4_client *);
 extern void nfsd4_shutdown_copy(struct nfs4_client *clp);
-extern void nfsd4_prepare_cb_recall(struct nfs4_delegation *dp);
 extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(struct xdr_netobj name,
 				struct xdr_netobj princhash, struct nfsd_net *nn);
 extern bool nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn);
-- 
2.43.0



