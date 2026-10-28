Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217202;
	b=5tiJbTpSKiESs6XKQuhJ9RTTC50Fv2Xqc7F3zGpRxgUgBe+OVMGchCm6ITdwuRaV1x8D
	 CrSCwTgDCduDVjQtHAymR/nz2+AIVNnKSU7szFVP02deoruQ7ccCKeD8qCKShBxCahxRG
	 GtSAfVTzigt1CLC4vHV3gjXl/1ifE/7EyZ12S3mMRdVPH3DlcnHUFuJvXtUw69uUtU3dD
	 r2qJ/YpMRXKNfdPLIWxCbmc9lxt61U3qiKEtvMNyeN4vFxKH/ePjRoS+HC67d4jR9oVeY
	 fqtOPz/YZGX3buv8w7W/9idI3s/od63K/odOdk/9sc06MAjClVsbclvOiALE25Y+CAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nlZ45O4DHRwVnFENYXr7Sn2yyYIoYh9ZCmV7Rix5Jpg=;
	b=v+0PfG4h/jIe23oo9jP4wbFxwV0PqZP4QAcO5L71HbR7VJm/EGuChZwyiOWhJ2OGgh5y
	 qrQfdqS+qyoB2+2QxbeGytSIUk1nw4NexHaLxLh/mZLPvlYlV4RR50QkCgjdkVfg/t7du
	 11Ffl5riN6L1cENjWmvDjZUweiCrugCuy46nXYShXDXriRMo2NG5+cC2M2xLSWzC/X92e
	 9TSu2zBPyXrh9mEWzAVChCYaNDWozW3CU4o0E81tQm9Fbl6VYiWRcRM6gkD/BDu5qg/MU
	 OxVPYi+wpPqrmbTC/TPUdmAZzqhJcJov3Oz9lS1h+mGXVl5hPmgNrPwHqZlIgOOON1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0qKOoX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1440D606A31C;
	Wed, 28 Oct 2026 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0qKOoX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C55A1F01825;
	Wed, 28 Oct 2026 19:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217201;
	bh=nlZ45O4DHRwVnFENYXr7Sn2yyYIoYh9ZCmV7Rix5Jpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0qKOoX4SMYlkdVH9FXpjDCi5/Jyl+5hqneZl3/WKWWxGb+IRe95cXNJXbufLtsc9
	 ABnx/u7qDV/s/ugl+bd3yOVGN0/qHgO86Lc9ewzqfAT92x/l6aOx2t/Fgda43bfE35
	 WV1iB9H7Qt6KD8jRglAFuomRmMHa0EJ3t95GJW5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1822/1887] interconnect: Dont access req_list while its being manipulated
Date: Wed, 28 Oct 2026 18:05:18 +0100
Message-ID: <20261028170540.904587413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit de1bf25b6d771abdb52d43546cf57ad775fb68a1 ]

The icc_lock mutex was split into separate icc_lock and icc_bw_lock
mutexes in [1] to avoid lockdep splats. However, this didn't adequately
protect access to icc_node::req_list.

The icc_set_bw() function will eventually iterate over req_list while
only holding icc_bw_lock, but req_list can be modified while only
holding icc_lock. This causes races between icc_set_bw(), of_icc_get(),
and icc_put().

Example A:

  CPU0                               CPU1
  ----                               ----
  icc_set_bw(path_a)
    mutex_lock(&icc_bw_lock);
                                     icc_put(path_b)
                                       mutex_lock(&icc_lock);
    aggregate_requests()
      hlist_for_each_entry(r, ...
                                       hlist_del(...
        <r = invalid pointer>

Example B:

  CPU0                               CPU1
  ----                               ----
  icc_set_bw(path_a)
    mutex_lock(&icc_bw_lock);
                                     path_b = of_icc_get()
                                       of_icc_get_by_index()
                                         mutex_lock(&icc_lock);
                                         path_find()
                                           path_init()
    aggregate_requests()
      hlist_for_each_entry(r, ...
                                             hlist_add_head(...
        <r = invalid pointer>

Fix this by ensuring icc_bw_lock is always held before manipulating
icc_node::req_list. The additional places icc_bw_lock is held don't
perform any memory allocations, so we should still be safe from the
original lockdep splats that motivated the separate locks.

[1] commit af42269c3523 ("interconnect: Fix locking for runpm vs reclaim")

Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Fixes: af42269c3523 ("interconnect: Fix locking for runpm vs reclaim")
Reviewed-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20240305225652.22872-1-quic_mdtipton@quicinc.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 40e2f110c5339..180015512aa40 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -162,6 +162,8 @@ static struct icc_path *path_init(struct device *dev, struct icc_node *dst,
 
 	path->num_nodes = num_nodes;
 
+	mutex_lock(&icc_bw_lock);
+
 	for (i = num_nodes - 1; i >= 0; i--) {
 		node->provider->users++;
 		hlist_add_head(&path->reqs[i].req_node, &node->req_list);
@@ -172,6 +174,8 @@ static struct icc_path *path_init(struct device *dev, struct icc_node *dst,
 		node = node->reverse;
 	}
 
+	mutex_unlock(&icc_bw_lock);
+
 	return path;
 }
 
@@ -779,12 +783,16 @@ void icc_put(struct icc_path *path)
 		pr_err("%s: error (%d)\n", __func__, ret);
 
 	mutex_lock(&icc_lock);
+	mutex_lock(&icc_bw_lock);
+
 	for (i = 0; i < path->num_nodes; i++) {
 		node = path->reqs[i].node;
 		hlist_del(&path->reqs[i].req_node);
 		if (!WARN_ON(!node->provider->users))
 			node->provider->users--;
 	}
+
+	mutex_unlock(&icc_bw_lock);
 	mutex_unlock(&icc_lock);
 
 	kfree_const(path->name);
-- 
2.53.0



