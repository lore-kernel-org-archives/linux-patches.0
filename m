Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208223;
	b=kCy9yncuezl7b2RzWQbwMbHLkNqJdORScBDh6gdlMEUXrcydYeOfIm868hS2wjzXh6GU
	 e2Wy+XrKzZxyBawFzXBMUzDZkCF3h0tYf+GNr6hxp0WCYjrhKy49xyuwzikC1xWMrMUy5
	 ZxVpJkGHrBuw/NZKdO1k94d4mFeD1HqBvH4a0EUNcqQdDfe0u97RIzGqk067B473pn+yJ
	 3nSmMYk4CgN6vQO5mBompcZlxXYBEbnjVBtGXQvKRyZDC0HZMDTHbkNvp1I5yr+Ykuwlr
	 Xqmy/Dwdn12OfJ5OwNV3OjQMwepkRmpRljC6NUMuvGA8KdUCqR22blwCBmbDGPLBFGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rHXtqqV3pzleWrNFfV26DZAG5rIMMSNWVvofUeNh3Vg=;
	b=kFSZ1V/YhS+T9MEwHUh5XPh8JIednbtRn5IMgKwXuu8qGf6FocwbBKLvjA8ZhLEM/JF1
	 /4tvbL0xFSwWDm8ttOwqTBZL/aB2XACIGi0QU6dD0uRl6qcMkcPVaXbLpPH4vDBvTT+aD
	 nu7k/o7LsLP3oJ7aeHg/oTMX4u+G1UVBOFGqcPvTwFj/dY6v3IRHuaAzb/vshKCqNqVmg
	 0CGPEbvE5d9uMhvXIGDQpD+1E+nkISbfBFdKMYKZVNGIGhNTbIvTsrzFUq+vA+KYcv7ix
	 akVtCFdz8GCtIH9dKPMJRkRaGt+pkA2JVAIQJxCmv+61ZZrF85XbnYPLHgCDnrnvNHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUf7s240;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E66606A325;
	Wed, 28 Oct 2026 17:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gUf7s240
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75831F01829;
	Wed, 28 Oct 2026 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208223;
	bh=rHXtqqV3pzleWrNFfV26DZAG5rIMMSNWVvofUeNh3Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUf7s24083peBFA9qn0SZ2Qd4wXeAhHwhlRv6E2R0mT4v49hPvEZHbl53VPHUMUzy
	 S++gVmajVoAhUy6DOmagb6vtcRoPK4vRN+Q3GBAUJpJY4BkQmxo29BAFzDmvdpX12M
	 c6AVeHSL/2m+4stZRNOH/X1OtTHdhIM5Y9vv92fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/516] ceph: bound num_export_targets array for mds info v2/v3
Date: Wed, 28 Oct 2026 17:52:39 +0100
Message-ID: <20261028170003.701224973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit a3eb169ee297aa99670ba927c659990bd1e453f3 ]

ceph_mdsmap_decode() in fs/ceph/mdsmap.c reads num_export_targets from
each per-mds info record and advances the decode cursor by
num_export_targets * sizeof(u32) without first checking that many bytes
remain. The only upper-bound check that catches a runaway cursor
(*p > info_end) is gated on info_v >= 4, because info_end is left NULL
for info_v 2 and 3. When the monitor sends an MDS map whose per-mds
info version is 2 or 3 with an oversized num_export_targets, the cursor
moves past the message front buffer and the later export-targets loop
calls the unchecked ceph_decode_32() on out-of-bounds memory.

A kernel client processes CEPH_MSG_MDS_MAP from its monitor session
(net/ceph/mon_client.c dispatches it; fs/ceph/super.c routes it to
ceph_mdsc_handle_mdsmap(), which sets end to the front buffer bound and
calls ceph_mdsmap_decode()). A malicious or compromised monitor, or an
on-path attacker on an unsigned/unencrypted messenger session, can
therefore drive an out-of-bounds read in the client kernel; on x86_64
with KASAN it is reported as a slab-out-of-bounds read in
ceph_mdsmap_decode(). The decoded values land in the internal
info->export_targets[] array, so the consequence is a kernel
out-of-bounds read, not an information leak to the attacker.

Impact: a malicious or compromised Ceph monitor sending an MDS map with
a per-mds info version of 2 or 3 and an oversized num_export_targets
field triggers an out-of-bounds read in the CephFS client kernel.

Add a ceph_decode_need() for the export-targets array before advancing
the cursor, so the bound is enforced for every info_v >= 2, not only
info_v >= 4. This mirrors the count-then-need idiom already used for
m_data_pg_pools later in the same function.

Compute the export-targets byte count with size_mul() and reuse that
checked length when advancing the cursor, so the attacker-controlled
num_export_targets multiplication fails closed on overflow rather than
relying on the later kcalloc() guard.

Cc: stable@vger.kernel.org
Fixes: d463a43d69f4 ("ceph: CEPH_FEATURE_MDSENC support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ omitted the newer-kernel-only adjacent `u32 target` local absent from Linux 5.10. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mdsmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 9699de85a15e2..4f05ac84b867a 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -3,6 +3,7 @@
 
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -122,6 +123,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 	int err;
 	u8 mdsmap_v;
 	u16 mdsmap_ev;
+	size_t export_targets_len;
 
 	m = kzalloc(sizeof(*m), GFP_NOFS);
 	if (!m)
@@ -219,8 +221,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 		*p += namelen;
 		if (info_v >= 2) {
 			ceph_decode_32_safe(p, end, num_export_targets, bad);
+			export_targets_len = size_mul(num_export_targets,
+						      sizeof(u32));
+			ceph_decode_need(p, end, export_targets_len, bad);
 			pexport_targets = *p;
-			*p += num_export_targets * sizeof(u32);
+			*p += export_targets_len;
 		} else {
 			num_export_targets = 0;
 		}
-- 
2.53.0



