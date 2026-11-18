Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015538;
	b=Vsh/P6At3TJbhPmDT8ZB2T8U5FNDULPO0zFrA5xdBXAC6ANqiAaorFewlYTNAEfWghL7
	 r/iiiVHUgJF18gfpP410K1QceU5cd7snxq/tuTi5u9X84v3A0QXj5ZWu6kUWMoCxUrWvl
	 FaTKBz757SVw9ZSFpHP/i0UQ7KTYrEjNF04sRjEfH+NY8vAh3YWu6s/Z1B00duMJPGGxz
	 Mto3NpAhzqDQnV6KbAOOVRO32gEmRag/vDnEed4ZBMw4EtDX4BSR0JOKtnFL+TQQSKJ9x
	 TlJXxwTjRY3FAkN00FB8AnWFES25ArfnodC64ykIP7HdUkViwGTUXa/tarNC98QTHNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vG/aj9R3DLoMZQVAkeM1vq+oIX183vr0flLm1Di/r7w=;
	b=iP+3cEUTpUX/bM46suYNm1kfCUDaJmVkE9ZgEKk2x4XQ3778wFq5hh0ZQAhLD9aR5S4B
	 DOcGp/hWUEprNN4jHSCD5FRorFg38H0BEb5wJH+QHPFv91xbHeSFW+1YQO56jXVn/2g53
	 2qHD6XvLAX5PV5x/f05QEkOiOfgKEP9CDXCB4t4RPD41+W1YPoL9nAM/IpQ6nnGFcy0qA
	 28MiU8pHJ1BAvNo2HoEFUTMS/pbUAL18Ye7waEcWdAVxPqM5PBZFNYRhFMkA6vuCNhJw4
	 7U3fe+MCWymzh0dSklqaBebeWgT+CZplNGQWxGWd6Ls/r+WRdP7uaql/ChZNwDC99Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5zLX3C+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05475606A32A;
	Wed, 18 Nov 2026 15:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5zLX3C+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4C51F000C4;
	Wed, 18 Nov 2026 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015537;
	bh=vG/aj9R3DLoMZQVAkeM1vq+oIX183vr0flLm1Di/r7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5zLX3C+Z12RukbMAoqA1Fazm8raK+zdrMZPF0yKUn+TOlkZUbTdohtl38VjOlc+l
	 qoF2K4NZXURZD2D3QCw3dDIJm2NrYRwQTgd1RxgwcSlTva2RmeQlcmpBIDlTD7tHN5
	 MYjNksvUBusi3i4fLs9WApRE5A+Nnv8106S2HrB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0168/2651] dlm: fix buffer overflow from negative len in dlm_search_rsb_tree
Date: Wed, 18 Nov 2026 15:23:28 +0100
Message-ID: <20261118150253.899092620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 9aa4f7a190742..d73c4aed1f8ac 100644
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



