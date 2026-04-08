Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887491A683C;
	Wed,  8 Apr 2026 18:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672046; cv=none; b=sx15bCpfo4qlR+vTNPbe+ftg0EWvuM38AEVZcvfsGQJKZFKnozBKfRyOkiYDLbtPgQrAp7056fFXP3JB0WOiXHY4Ie/qU/TFkV6MO7YG5rNhu6TdyAbD5eK2eTeYJsN2hQqeRAk6PEKRD2lJDatoa5HZoqBTbc2h5O+PqL3jmng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672046; c=relaxed/simple;
	bh=EM6vEcLlNLsucty2DCGQ/KHEORzEIxuQdEe0baU53Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yh0i+QjV2HiKpFsjmaoM82r/iogQbSvmsRIvuBzH1s6jQSh+aV2xbFOFbst+0kKDf5Vs1BERuQnCLVFKA/mtQzBZcnewhJea3ezxazRxBI5woIjHDsWdQKQo6ra5ay3Ksj9PDHaFCyL9nMs3297lL540S7JLhUHqdxoAvEWi0wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gh0Abqf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gh0Abqf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFAEC19421;
	Wed,  8 Apr 2026 18:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672046;
	bh=EM6vEcLlNLsucty2DCGQ/KHEORzEIxuQdEe0baU53Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gh0Abqf1xGk1EskS0N3mKqByrm7uB+eAlqD4yebtPdPJnReu6scG9E/H+I+piDSNM
	 92aQSzVRKkRs0dS01tjxogSwEV1SoLaaUaXDVxYzrCLap7E4BPi9DQoKmDYkyCIxWP
	 n0wz3tSFRCaI1coMkCEcKBxTmhY4WC9mMWH0GSDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/312] netfilter: Reorder fields in struct nf_conntrack_expect
Date: Wed,  8 Apr 2026 20:01:26 +0200
Message-ID: <20260408175940.076877166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 61e03e912da8212c3de2529054502e8388dfd484 ]

Group some variables based on their sizes to reduce holes.
On x86_64, this shrinks the size of 'struct nf_conntrack_expect' from 264
to 256 bytes.

This structure deserve a dedicated cache, so reducing its size looks nice.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 917b61fa2042 ("netfilter: ctnetlink: ignore explicit helper on new expectations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_expect.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index f642a87ea330a..165e7a03b8e9d 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -26,6 +26,15 @@ struct nf_conntrack_expect {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
 
+	/* Usage count. */
+	refcount_t use;
+
+	/* Flags */
+	unsigned int flags;
+
+	/* Expectation class */
+	unsigned int class;
+
 	/* Function to call after setup and insertion */
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
@@ -39,15 +48,6 @@ struct nf_conntrack_expect {
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
 
-	/* Usage count. */
-	refcount_t use;
-
-	/* Flags */
-	unsigned int flags;
-
-	/* Expectation class */
-	unsigned int class;
-
 #if IS_ENABLED(CONFIG_NF_NAT)
 	union nf_inet_addr saved_addr;
 	/* This is the original per-proto part, used to map the
-- 
2.53.0



