Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACBB34BA42;
	Sat, 30 May 2026 17:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163924; cv=none; b=FMgpDt4bssxlFt14zyik0r5LFTpAcb/cX20n1TIJ7kMptj6TYyuTmjmO50lHwUCe6yS01Rcd40i8xoJoJgVy99voMONl44tIJIJkB3/wQKwnQSfeJGFbnl3D/a/hhTMPunUAW4Gt7rTA9vFmnbOwPnTJL1KRQf5mGfXx8RA0Qqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163924; c=relaxed/simple;
	bh=mVTsKJLSXiKom39VWGyqqqsQ1PftTHDydjaM3AznrsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JM4VEVYk8vN2wNN5RrASaJ9iJXfzDXxshuH0rQ5r4CCpURt7qABpEUHpmHQOjjdjr277vefFKKSWzHJ7oDx6y/PQ5KM5xxY6A2qjE2XJlRFnt/qb32t606yxClkssz98FJlRe/nr+usRq8kDCaUxDg37e0TzUu6BXOU1bL4xWAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7OT3HlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7OT3HlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12AF1F00893;
	Sat, 30 May 2026 17:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163923;
	bh=Y2mP+smPqBzqys6CXol5cG5TTl6ml3Covrm3LrnRbZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7OT3HlUtkIEtNMFyVcDvUGV1p6M9two05XDd5i8fm9col2U1NY/1yS+PJA0CsHHD
	 ZoDvT/6lWtqvwlOQBkZNAYYqsLaqxpGMyJD1J9NkUq6EUjbMO9mAR+2HyBPCEMFL7q
	 Ye8ynUmKWhobI3t7x+Hk8NcbgNIyK7GiEx2Pjhj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/776] bpf, devmap: Remove unnecessary if check in for loop
Date: Sat, 30 May 2026 18:01:57 +0200
Message-ID: <20260530160250.920035290@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2bfdca506a4de..6274cf7011901 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -758,9 +758,6 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
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



