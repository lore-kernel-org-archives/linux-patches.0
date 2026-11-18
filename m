Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052885;
	b=me6yoMLP12n+nWTAc/lvP6HSgsBC7GNjqDf7E38U6pLorX3GCtkseKGATiYXBexn6N8e
	 OgKbU1wkzzvipbOizJsQR9w+1MD+3oUr4IL/xaXzTp4WGsHX9c6akUMsgtAAayfGt8/oS
	 PqrgyRygwGvk99QBu4OZ5zZ0NTDMg6a37Yx9E+qTgJ7BKAqyyRW2k/9woBZL1JWJKJSNm
	 xPj1VQSW0rb5qoJl17rCs+hTZ/kxARFFWiXI4R/cN5ea7w+S3yOG86mT9zHw/+zSZiEA3
	 +a2qm0eapAdY4kdBWDIE+Q8XoW6Um7boC05BWCg1jrICe/gfrHu2+FfPzG9xWa/Re9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jEzbV0oxHM9WnsWa5ZGETPqQT456w+ugK33At75XTSo=;
	b=Rx/woYn7UZWeIuhPah83BYCBy1KrzTUUtZPWeVxU2vGOfEvqBQgUrIXtVNxzxhBc/2ay
	 dgIsN4XuO6aLrocU9DtmDLQG4pw6L5/hQwyz6DiDaOgx+hRk1Q8oziIdGRjfJTsxGvb4+
	 zV8t/K4AtzGa+QQ75ZqXTJkvBTv/ydXOlsR9joICy/Dbt2dWLOLLRGM0gRsiPYAWVKfQH
	 XPy+zpdVmGnUh9bxeo2qlykO/bnu728H9GnDyRbuzioQvuEl6SI/ewGGpJ8Jgtxo+hAV4
	 B5oCYI1wVhZ1IEbWPebLnr/oB8zceH5rS+GLt9f62s7vV70PD26eFNj0f2BEbboyavA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNpX66ed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1EE606A325;
	Thu, 19 Nov 2026 01:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNpX66ed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4521F000C4;
	Thu, 19 Nov 2026 01:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052884;
	bh=jEzbV0oxHM9WnsWa5ZGETPqQT456w+ugK33At75XTSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNpX66edhiEX6yF2+fRTyGRkLgt+96ttPsu2vkoc4KcXfDsJBakUOjFsZpmkqdLhI
	 hIcIeKN523698kxxVgfAacXfp81tsRXVFPWb5HzJ3oDlJvIOxQJARsbsl6q3VmDnEi
	 ax9h7EzPtxL1bR4Mlc5kWtm0Fsp4oiqoajeBu6Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0720/2214] ceph: bound name skips in ceph_mdsmap_decode() by the message end
Date: Wed, 18 Nov 2026 15:39:56 +0100
Message-ID: <20261118150040.587040821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 77eca4d7aeff4..355ce829d8e72 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -206,7 +206,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 		ceph_decode_need(p, end, sizeof(u64) + sizeof(u32), bad);
 		*p += sizeof(u64);
 		namelen = ceph_decode_32(p);  /* skip mds name */
-		*p += namelen;
+		ceph_decode_skip_n(p, end, namelen, bad);
 
 		ceph_decode_32_safe(p, end, mds, bad);
 		ceph_decode_32_safe(p, end, inc, bad);
@@ -224,7 +224,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
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



