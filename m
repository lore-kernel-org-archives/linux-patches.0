Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065360;
	b=UukhjubeKcF+ZukDCpt+b2UBm+Q3HpEjGQbmhaDtWw2kCFajUWLzLQ6hUSi3yvmVK2Mi
	 dvCIZhSGfahRYKK38TqpoNcgRzDrJPIKBKjBAZY+wa22Xty6GacWXq94lBVLfS3zdLPJS
	 bLsnPi8tfAjH4P6aatXfNzBF8EQRmqdjejnlTUPucFT+xZGrNoJ7xxCn0P2BpzUTc/kff
	 XYyrJQxIjWwesLF5rXmIwPmm/gB8IBmjQEsqiKRb9sc1ert/7yt3ADMnyJMULOHLJqkCX
	 IVHOQGceEvVSy3lkSN8bL3WRBRQ6v5kTDBWXXFPXwzw16UtKkefrB40zhchSRJxHccQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3khf0gsWbQSbgn7J/+OysoFmPjwwajRWFPEvEWQZkN8=;
	b=tp/D1um3eqbVXJbBmZKGK4icgL63l3T9wUCvb3g2KenDr01Ndd8H1AUzj/ANh/j6Ke91
	 6s4vtqhq7V7vCa2ib84TfORocUTWOflCoMXTxJpzfMjSaponPNxXPkgOG19y6ekPjTeTr
	 6IGq3DHOVnJe6KCrEt3a0iBb0ejvu5hmYvoAkBQfFp0pnm7QQ/O1xh8atjSsRheEAUxpF
	 l/mTSolzAHFS2GewQSaVWQOi/y5ebl1fQ4BupzIwHfFKyIE9dVtgyYbqOXYuGWzsOyOy0
	 GtQt7sWFvAyA90DbD+IiO+pgs+1AJTZn6Dw+7k9xy3RFpvLSvs53Nl6bL55Vvp4hj5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0iuGUMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936E1606A32C;
	Sat,  7 Nov 2026 15:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0iuGUMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9581F0089F;
	Sat,  7 Nov 2026 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065360;
	bh=3khf0gsWbQSbgn7J/+OysoFmPjwwajRWFPEvEWQZkN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0iuGUMFfENOKqBb/xocY2+M1ZKMOaAZK9p95qX/q0+C+k8uQL+9lJPPGMhMo4opo
	 AJ4gdYXhv/Q17u+koe3PK8RlAdurB76R5OuxX5bcdtC6jSOI+cIcJEJHXwuiMrBtov
	 fkF98o0DFptD2NJENowGBRo/DDc+v1sMkEkX7vNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	SJ Park <sj@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Michal Hocko <mhocko@suse.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1095/1257] mm/vmscan: reclaim every zone in per-node proactive reclaim
Date: Sat,  7 Nov 2026 08:56:31 -0500
Message-ID: <20261107135009.504943478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Gregory Price (Meta) <gourry@gourry.net>

[ Upstream commit d0a12d80d2f7e9f4ed2030b6f04c8a897956bf84 ]

user_proactive_reclaim() limits per-node reclaim to
gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
folio, so writing to /sys/devices/system/node/nodeN/reclaim never
reclaims a node's movable memory. A movable-only node, such as dax/kmem
or hotplugged memory onlined movable, reclaims nothing and fails with
-EAGAIN.

To reproduce, fill a movable-only node with clean page cache and write
200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
cache stays. The same write to a ZONE_NORMAL node frees 200MB.

Scan every zone, as memory.reclaim does.

Link: https://lore.kernel.org/20261019185002.3428594-1-gourry@gourry.net
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a14e42ea9ed6..1d1ef7ea52c59 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -8041,7 +8041,7 @@ int user_proactive_reclaim(char *buf,
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-				.reclaim_idx = gfp_zone(gfp_mask),
+				.reclaim_idx = MAX_NR_ZONES - 1,
 				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
 				.priority = DEF_PRIORITY,
 				.may_writepage = 1,
-- 
2.53.0



