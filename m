Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063673;
	b=wYiVpWFpX3JJUMy8xqeO7v+6u9avpzgC21NuhbDNehYxN99fYzavKbOp8OvxEHF6EJe1
	 Fov4MRpMVPWJaXyER37Aebo2jOKBESsde902uC/nuCcm/MG4E1aDDq/IwO6qg63BtWvNB
	 YfLuh7ZYiLmvxywG8ob3GlRDAF85PkWJoSUhRt5lenBZnhQ59bBMw1iSifO0Ln9imbh/4
	 P8lhQHa2zO1/vDnvTdLxbG6/plz/XnnEo0ZkGjzvlZRHDMUg/muV+HGa/Cixk++MKl5wS
	 vGLNBl6MItisO5QCI6v/Sl4jwDBmL9JYoixgjGP6nPGIESS/67gbTxQhYQCK4a5NW3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HbzRc2C9tOB6JL2k7cKr4uo+1GVc2iqBUViY6Ru97D0=;
	b=XhKkSRSj9WawUZOlUQ/3WVWzP5eEz5y1nUTEiELfR2382Qm8x2GgtqHh+ZSwtBFo3cXi
	 PnkWX05MzK30iDcDs5u+YC/uhZHaOE/6ppK37f+UcmcOT95mJ+y8uPT5+CCgn+tpSUUT8
	 zknHcQeL6LSm6x6vGcvtplvIsouaRQe7yDgCAXeiuUO4pl/aeB/rfXXHEmHvErpe/fpFu
	 UFjbPR5aadGaDoHKGSZFZkBrzSqLyEQLTc46o/G/JZkX9Ro561YxCEzT8y8nu39hJc+PC
	 LwEg16byAFyNL1ZR8tzu+hRugY7+9PvE8LQMWRlSfuQ3oUImEAHgI238+sFhzuv4EJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VoNTWtbM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0C6606A9EF;
	Sat,  7 Nov 2026 15:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VoNTWtbM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5BC1F0089F;
	Sat,  7 Nov 2026 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063672;
	bh=HbzRc2C9tOB6JL2k7cKr4uo+1GVc2iqBUViY6Ru97D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoNTWtbMFKxXFqLBf3G+7hnp3mLPKUpHpxTWRU3P3Yw1xK0wABVWrTb/WdGlQ2dUL
	 noN7fjetOFiP75jWlR8R1fS+g63KXi+B0AoHnt54/zwPYxeKzQQwlHZopkUP8+DhPH
	 hZ6iiGbn2LhBseAgQaMfmypzuR9tZu1eQATywbII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 783/869] ceph: bound name skips in ceph_mdsmap_decode() by the message end
Date: Sat,  7 Nov 2026 08:57:45 -0500
Message-ID: <20261107134919.221896816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: sung byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit 7f702e1703c9648fcb02a217d66c880d00417150 ]

ceph_mdsmap_decode() reads two remote u32 name lengths and advances its
parser cursor without checking that either string remains in the message.
On a 32-bit client, a sufficiently large length can wrap the cursor below
`end`.  The following numerical bounds check then succeeds and dereferences
the wrapped address.

Use ceph_decode_skip_n() for both names so the remaining bytes are checked
before the cursor advances.

The issue produced a page fault in ceph_mdsmap_decode twice on the tested
i386 baseline.  The same frame was rejected without a fault twice after
this change, while a normal MDSMap continued to be accepted.

Cc: stable@vger.kernel.org
Fixes: 2f2dc053404f ("ceph: MDS client")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mdsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 0fd578f0b2cd2..d377d13f854d5 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -209,7 +209,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		ceph_decode_need(p, end, sizeof(u64) + sizeof(u32), bad);
 		*p += sizeof(u64);
 		namelen = ceph_decode_32(p);  /* skip mds name */
-		*p += namelen;
+		ceph_decode_skip_n(p, end, namelen, bad);
 
 		ceph_decode_32_safe(p, end, mds, bad);
 		ceph_decode_32_safe(p, end, inc, bad);
@@ -227,7 +227,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		laggy = laggy_since.tv_sec != 0 || laggy_since.tv_nsec != 0;
 		*p += sizeof(u32);
 		ceph_decode_32_safe(p, end, namelen, bad);
-		*p += namelen;
+		ceph_decode_skip_n(p, end, namelen, bad);
 		if (info_v >= 2) {
 			ceph_decode_32_safe(p, end, num_export_targets, bad);
 			export_targets_len = size_mul(num_export_targets,
-- 
2.53.0



