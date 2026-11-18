Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022964;
	b=Kc4evTIdv6Uq69TamPsk+GIRYcLrhV8hkPB7+Qs7Pfn3JTgx2kojNi6yjjrzK9viZW9L
	 WNBkxI0/XLI0lhB3VvKheDaRlcLcpYKa75biUmaCqORZ/waRzt+Ipg0Bcw7cmREdtMymv
	 9P+wR19wfkd5JI/NmCaSIrMKjBbDsVOMk35VVsFvlqrSsHTOlTIaeZlSRCPLhyiXuYAHa
	 dzaHxo+teSvLt1x4l+PlJFbPJepjMARNbGV3G0D1+KL3PtGwcXeV9NAUMGzczmhPZrvDk
	 +7/nT7gldPrSQ2wEpihCn1XIAswpfrtBfn6K8Q8rTTLjIFj79bV3xoILTf2bZscQ/Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ysuPJeE91YMo9m9/CjDDvhfWdL9YRwe7a5Sb+r6SdY=;
	b=eogrVG7wY9nobP7c3Je1Z5pZwAk9pulVq0eF+hEmhtj9QodZBX159xICG6oMA0ym/arC
	 wj/4sxuHQ7fdCzu71bHOqTdzoMn1uz4WijytIHRt3E7aoz56f+JC/OKw3/B21itnamVRg
	 1ZMqX8aSl742LRtS+oltvzMv+R+FvHNeE5onuogPiHv9Pv9FwCZdAd5zLVohffIHyu50+
	 AI13Uul3+JomXLLUDJfozYLEDcTGNsNSO1Kfz+0LfvQ3+EMupJn1ybLMpj7KF4BC2RSOK
	 r4n7pMvBlyjOAaUWUMbVOP3LgoGAMMrpgUCvVd+jcL0PpbdzDrI5HjIdq8bzZKELrRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GKS2cTsa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF99606A330;
	Wed, 18 Nov 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GKS2cTsa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCC61F000C4;
	Wed, 18 Nov 2026 17:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022964;
	bh=4ysuPJeE91YMo9m9/CjDDvhfWdL9YRwe7a5Sb+r6SdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKS2cTsaaE3x2a1aa49fJnLcwauq1+2RwZczNGqIYAlDPlwOtQqPl9Hn0TepF8k+V
	 oFrKvB2gcQiqtwz3Nwjx0ShpxjbM0SBqJnZeinrEtcEVmdp6W1LnVTUuCYGuqhpKKY
	 UQ+Hq/8dMQnZvuR41KXRpsRJ0qWGuOPb2N2NJ7d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0201/2151] dlm: fix buffer overflow from negative len in dlm_search_rsb_tree
Date: Wed, 18 Nov 2026 15:32:16 +0100
Message-ID: <20261118150129.104883416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit d785f7d92f197b72d496bbcf54a160cd54f00263 ]

commit 080e5563f878c ("dlm: validate length in dlm_search_rsb_tree")
only checks for len > DLM_RESNAME_MAXLEN, which does not catch negative
values. While the input 'len' can be negative and a negative int passed
to memcpy() is implicitly converted to a large size_t, causing a stack
buffer overflow on the key[] array.

Fix this by changing the 'len' parameter type from int to unsigned int.
This ensures negative values from callers are implicitly converted to
large unsigned values that are caught by the existing
len > DLM_RESNAME_MAXLEN check.

Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: b4e6ae7ba711 ("dlm: fix variable key length lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 6 ++++--
 fs/dlm/lock.h | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 58f3d885c6858..f7f250ffc8eed 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -622,12 +622,14 @@ static int get_rsb_struct(struct dlm_ls *ls, const void *name, int len,
 	return 0;
 }
 
-int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int len,
-			struct dlm_rsb **r_ret)
+int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name,
+			unsigned int len, struct dlm_rsb **r_ret)
 {
 	char key[DLM_RESNAME_MAXLEN] = {};
+
 	if (len > DLM_RESNAME_MAXLEN)
 		return -EINVAL;
+
 	memcpy(key, name, len);
 	*r_ret = rhashtable_lookup_fast(rhash, &key, dlm_rhash_rsb_params);
 	if (*r_ret)
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index b23d7b854ed46..c75975937331c 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -31,8 +31,8 @@ void resume_scan_timer(struct dlm_ls *ls);
 int dlm_master_lookup(struct dlm_ls *ls, int from_nodeid, const char *name,
 		      int len, unsigned int flags, int *r_nodeid, int *result);
 
-int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int len,
-			struct dlm_rsb **r_ret);
+int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name,
+			unsigned int len, struct dlm_rsb **r_ret);
 
 void dlm_recover_purge(struct dlm_ls *ls, const struct list_head *root_list);
 void dlm_purge_mstcpy_locks(struct dlm_rsb *r);
-- 
2.53.0



