Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431811A38CE;
	Tue, 18 Jun 2024 13:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716420; cv=none; b=qchwyfM31PZLW2cLNTuq6CYGP0lKFCHsUUcZKxssel/bbCqzK//hUaF5F8eh0vtQl6kh8kLubUdWwIqOIrE21tCqdq8gdNTadXP9gXeGDkYxM9TKGA7CHsEkCENdOXuSARtLIQy3czCvNpxyKHxxBbzlfOI7KoAOXUK2n8UXkds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716420; c=relaxed/simple;
	bh=bTITszObUPzj0qon6c5WBUs8XzonmhIk3zYbhZDpaVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koMe166nkgYN99WSRsHndCDEQIpkm25uGPp9p5cfoFRxtHdIazYK/lghNxyQ7HnFzuaGo2pItbsjN7RHTZ6wLcMg1CaYmBF7CxPHMF1HEY5XMaP2LpgrJWSfFJ4fW98kcZ8THdRQPRy1XAW12aiaAI7HqiLsOEeAtTnmPN6bIxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P53oE35p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P53oE35p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8A0C3277B;
	Tue, 18 Jun 2024 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716420;
	bh=bTITszObUPzj0qon6c5WBUs8XzonmhIk3zYbhZDpaVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P53oE35pb0b4PaNn0qXMXnMgS57TwYJQCDWPEHmQxrdKYCXC86Aa2zBpu20hnwTLp
	 D2fGeEBvJX8Z4JdGdBt4oJHj/TA+TAxF7kB0p0SBTMF9SZ3R1G7HUWntaIpxNpH3zx
	 Y5Ye8HdZEvuu17w4eUxhDq7pIX0PEp5KJo+0fuTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 640/770] nfsd: remove nfsd4_prepare_cb_recall() declaration
Date: Tue, 18 Jun 2024 14:38:13 +0200
Message-ID: <20240618123431.993152115@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 18224dc58d960c65446971930d0487fc72d00598 ]

nfsd4_prepare_cb_recall() has been removed since
commit 0162ac2b978e ("nfsd: introduce nfsd4_callback_ops"),
so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



