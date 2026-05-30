Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619A34104B;
	Sat, 30 May 2026 17:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160863; cv=none; b=D3juoeh2nNoEbRGUqqSsQ78dKfNxmaWTl+gidz5eZ82WbzE3Wka8I3Fh3sp/ogEAfrR2rUiFVSIVCDQXh1adyp6eBFRsUVRyPFkG4WgLEDzK1mvind2yNt3NiFhtInTIdwxFOdkFbLHkoi+OwMi77vXKY++PnZvQdVc54HFsl/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160863; c=relaxed/simple;
	bh=VSAODh/vCvaKL/apxHWGzql+MBS/hThSMpfb1EA2iW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fKPEaREAnFc4TzBkBCdZQuwamy7YNR2eXHRbVMTp/XhE1ZB/Q8cOIzUq4X+8hFP+kNgzLj4hxioYRS2ns+CuKp4hjYldkxME4Txhn3cUUyXB7q9qg1a9rOhX2XNR/p1vUNwNQavLOkeBYBR9EL75AFjzRA3fQOmUVyV1gjR+i8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceX+D7u+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceX+D7u+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC111F00893;
	Sat, 30 May 2026 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160862;
	bh=4fP4rPjdh68DrbtL11tY+ZuE2orTBtrhHhq0hdU8ozk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceX+D7u+bEZ1Eky/gpmXxPAhGXaATXvmTk+2Vt6GOsoUfy4RhG2r+V+VYB+ptkiMC
	 Sl91igc2SBmK0NYPOxkXylETpVniS7sEFNTsJHb+ebBZiJfcvCFdijts+GypnVskmk
	 n/RRWVXB2Po+TpVjBtZnxdwnRKnIkAbgzJh9giak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 456/969] bpf, devmap: Remove unnecessary if check in for loop
Date: Sat, 30 May 2026 17:59:40 +0200
Message-ID: <20260530160312.873311922@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5e05732db2368..71025d1311a57 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -759,9 +759,6 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
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



