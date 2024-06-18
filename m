Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5C16EB6D;
	Tue, 18 Jun 2024 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715411; cv=none; b=UYsVywY+8NfqpFXlEk+F+Utt3RMGUmbr5AdezQc8PBOhrWKwIjKd8O+i/u4CYUrICy+9K85KI2hb370c8AHdRCkT9i6CageZHaYQN0ReIcrggzmplwhOoCNCasRYYy2YGu9P8IFj4TYGjB9ni3MQovdTDspiffZ/67fTxSntnHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715411; c=relaxed/simple;
	bh=oO58Luq5mzbixBfAE6YXlBhwAmkohdCgghzcSHgYq0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2AJ4FyHzFXBUjTSRvafsF5sivBj36S1cMFGBNbVerE3XcfSw28JPMFOjnRW11k1yyHat89ZW5lbV1WIB9GJYPxAQBn7HtQJUtHimIgpFTqFf0Kdi8x40/huE5OKIMeBxtwjSdU90ouCXJkl134rXdlOpYP5vwQesC17W6ZZgXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjFH6SvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjFH6SvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B664C3277B;
	Tue, 18 Jun 2024 12:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715411;
	bh=oO58Luq5mzbixBfAE6YXlBhwAmkohdCgghzcSHgYq0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjFH6SvLflddG95VRgdZcEu0/od1v8BionqSaZLgaiAFPs6OEhL8ZXHxghm0pDXHU
	 418a6MdCrpG96C6T7zBi5ueQNslAbO0Q/jOvStGW3lLB3FvZkMGQsJ6k5U8B1psEvg
	 UZ5E6lXTxZJZUQ6WTHCs5ynzx6gWw2ZA40zSsk28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 299/770] lockd: Remove stale comments
Date: Tue, 18 Jun 2024 14:32:32 +0200
Message-ID: <20240618123418.805189413@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 99cdf57b33e68df7afc876739c93a11f0b1ba807 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockd/xdr.h  | 6 ------
 include/linux/lockd/xdr4.h | 7 +------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/include/linux/lockd/xdr.h b/include/linux/lockd/xdr.h
index 7ab9f264313f0..a98309c0121cb 100644
--- a/include/linux/lockd/xdr.h
+++ b/include/linux/lockd/xdr.h
@@ -109,11 +109,5 @@ int	nlmsvc_decode_shareargs(struct svc_rqst *, __be32 *);
 int	nlmsvc_encode_shareres(struct svc_rqst *, __be32 *);
 int	nlmsvc_decode_notify(struct svc_rqst *, __be32 *);
 int	nlmsvc_decode_reboot(struct svc_rqst *, __be32 *);
-/*
-int	nlmclt_encode_testargs(struct rpc_rqst *, u32 *, struct nlm_args *);
-int	nlmclt_encode_lockargs(struct rpc_rqst *, u32 *, struct nlm_args *);
-int	nlmclt_encode_cancargs(struct rpc_rqst *, u32 *, struct nlm_args *);
-int	nlmclt_encode_unlockargs(struct rpc_rqst *, u32 *, struct nlm_args *);
- */
 
 #endif /* LOCKD_XDR_H */
diff --git a/include/linux/lockd/xdr4.h b/include/linux/lockd/xdr4.h
index e709fe5924f2b..5ae766f26e04f 100644
--- a/include/linux/lockd/xdr4.h
+++ b/include/linux/lockd/xdr4.h
@@ -37,12 +37,7 @@ int	nlm4svc_decode_shareargs(struct svc_rqst *, __be32 *);
 int	nlm4svc_encode_shareres(struct svc_rqst *, __be32 *);
 int	nlm4svc_decode_notify(struct svc_rqst *, __be32 *);
 int	nlm4svc_decode_reboot(struct svc_rqst *, __be32 *);
-/*
-int	nlmclt_encode_testargs(struct rpc_rqst *, u32 *, struct nlm_args *);
-int	nlmclt_encode_lockargs(struct rpc_rqst *, u32 *, struct nlm_args *);
-int	nlmclt_encode_cancargs(struct rpc_rqst *, u32 *, struct nlm_args *);
-int	nlmclt_encode_unlockargs(struct rpc_rqst *, u32 *, struct nlm_args *);
- */
+
 extern const struct rpc_version nlm_version4;
 
 #endif /* LOCKD_XDR4_H */
-- 
2.43.0



