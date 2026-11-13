Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585511;
	b=mVA2W1MIgDbf+06+bWt99q2tVysqicA8Ksul/57ddljB5ded1gETvRSdSP8W6p5synJQ
	 aRrQYHccuTQ/M1sa4/d+TbAa483liQ6GLnCLuadEGJTfE/dD9CITYbmrcpSS8H+r/j1ci
	 RkxAyKP1t2JZ0aacIUzbi4YEFMv3nC7G5PWU4UTqLfpjKnV74cwTV178eWIuBmd5y6gxX
	 RRhE0lmhWMHzj1MwyJqbmkbpsTnAr66OW2WMZJ48tY/NZS1s7juDeNdA3XPgm3gO7L0no
	 v2/0qMEaxXs54GWnJlptZsslldOk/bGkJslRWGB0hDbBMXtFrvzvb9oCJH/Vl7Sn1YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3xWmgOYVLrWDuP0g7lzuBw0X1XMH0opzdv5vU1LFdiI=;
	b=rdBqtZ2P67IP3ZMvn52c1z1B3DSAW7W4zP6jDwvxddMeJ9KzcqF23V3iMngEAdgKSpIq
	 HKWOrbFp7MBnanXywHGn6ve/OkYfvFWjbziXgQvkZ2G3PkRC7M32bhy5/VVRgJxDg8Rak
	 8BW/LuqnpD5m9MM6XWHxdQcKVIHk7vvrhzRqVLLtWgw/SsJT3F+m+giy/SRqnrV2jDHd5
	 0Y3zZ3BBpHGlZDfOUe/uWVDSSRnhde8qzDUD+HCtkjSKJJUrz3JCpBawOo8Z4U6CF6oOx
	 5OFBI8KcrrY7vVrIbzV3aF3p0dRD7o/qQRC4Iw18HaFPbIgEon5lp96MwIvLqhVZ/LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0baFcS4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFCB606AE0B;
	Fri, 13 Nov 2026 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0baFcS4O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0991F000C4;
	Fri, 13 Nov 2026 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585510;
	bh=3xWmgOYVLrWDuP0g7lzuBw0X1XMH0opzdv5vU1LFdiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0baFcS4Oie5oi9Y/yvZzXeU55MQ5uzqT7FAVPT85lQAOELOjfIK3MwrXJPoPeNnQg
	 h04R8JD0ItKO+dZ/eCq3pnEgUK9Sf2BqDlP4wHbA8qaG906Df3PTbxSVAfShq62kTL
	 aGgTVFpHIMJ17QcDZMx2RVNpyRSBa4Aavh2ay5ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 157/507] xfs: set healthmon mount cookie before publishing it
Date: Fri, 13 Nov 2026 10:47:41 -0500
Message-ID: <20261113153759.828723243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 0344a9492efac4c79202a07cf284a382f7054170 ]

xfs_ioc_health_monitor() allocates the healthmon object with kzalloc(), so
mount_cookie starts as zero.  zero is also DETACHED_MOUNT_COOKIE, but
xfs_healthmon_attach() publishes hm through mp->m_healthmon before storing
the mount cookie.  A concurrent reporter can therefore acquire hm from
xfs_healthmon_get(), see the detached cookie in xfs_healthmon_push(), and
drop the event even though the monitor is being attached.

This is reachable by racing XFS_IOC_HEALTH_MONITOR with an operation
that reports a health event, such as a filesystem shutdown.  Initialize
the mount cookie before making hm visible through the RCU pointer so
reporters always observe an attached monitor.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: a48373e7d35a ("xfs: start creating infrastructure for health monitoring")
Cc: stable@vger.kernel.org
Signed-off-by: Binbin Deng <18983559317@163.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_healthmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 2bdd747f1ead2..05d6f0494139d 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -114,8 +114,8 @@ xfs_healthmon_attach(
 	}
 
 	refcount_inc(&hm->ref);
-	rcu_assign_pointer(mp->m_healthmon, hm);
 	hm->mount_cookie = (uintptr_t)mp->m_super;
+	rcu_assign_pointer(mp->m_healthmon, hm);
 	spin_unlock(&xfs_healthmon_lock);
 
 	return 0;
-- 
2.53.0



