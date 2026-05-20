Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA5B347514;
	Wed, 20 May 2026 18:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301949; cv=none; b=ICth+lnXEE/5OEVOmxtQQ1qnYLZQ2pjylC/dSRdFnB72sFl561m3CIk+NvuGhpLsvaNOWbl4dlInEtOIEBUPIemcIPuF0zXZBvxEAgh8cS+YeLICpd/tCZziVzXAdOCEeNiWfFMdP/hI8s9q+cDgnin4lUcik9QY5cvgLz5rVMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301949; c=relaxed/simple;
	bh=VgHgOsQEOD1xqqYAzOnaZlBzY1S1fI5Lyc7kfYo+pbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZLKj3+vdtR9p8B+K/5U44YBJ2FFWxwfeNb5VcNiEPCuEYnFwFJ/DyQFnnUxGBxOx8/wOXJruaKUsarUijvruwIOLwewa3JTbqJci3hcKT4EiIxcG+ns/aV3/W9/uOmwW8kp1brRQvECczfTP4NIUl59BVkrdGBy6+Nf/IFxPNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfr0GUj8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfr0GUj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014731F000E9;
	Wed, 20 May 2026 18:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301948;
	bh=BRH+a8haKeJ1Palz7rO++0kt+WUM1GNt2iNQKlQ6OPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfr0GUj8dUpl1CjP6BJGH7TAztP6b9Exe0MtMKhWZrI6i9+97Cu1xmUJqULBcxWkP
	 /o10pGTjHW/6dR6nmuaGdZ4ncBPukcv45HtouPGhOBPfTW62sMHjqm2TxqreVTaZYS
	 TcFaUXNcDW716Cq9W6XTzJXNYROPyiUDBm6rhAAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/508] bpf, devmap: Remove unnecessary if check in for loop
Date: Wed, 20 May 2026 18:17:42 +0200
Message-ID: <20260520162059.439335751@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

[ Upstream commit 2317dc2c22cc353b699c7d1db47b2fe91f54055c ]

The iterator variable dst cannot be NULL and the if check can be removed.
Remove it and fix the following Coccinelle/coccicheck warning reported
by itnull.cocci:

	ERROR: iterator variable bound on line 762 cannot be NULL

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/bpf/20240529101900.103913-2-thorsten.blum@toblux.com
Stable-dep-of: 8ed82f807bb0 ("bpf: Use RCU-safe iteration in dev_map_redirect_multi() SKB path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3bdec239be610..3939221bd6098 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -765,9 +765,6 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 		for (i = 0; i < dtab->n_buckets; i++) {
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
-				if (!dst)
-					continue;
-
 				if (is_ifindex_excluded(excluded_devices, num_excluded,
 							dst->dev->ifindex))
 					continue;
-- 
2.53.0



