Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620987;
	b=OoPQHLdi67n6URBIivls32xhlLYnEpJC26qpQwgoI2w77z9yzrsBqnwW9PLu9GkNn8iw
	 M5Mb/Ss1Z8xG5QYanM9w8BZAj6E+bsrfQPy9JojmMBXNZOi6XI8LACVMZz5czyKRrAS/6
	 rwbv0wEsm85XYwzEGiH3owDfaMaPdvyjyd5WTPiD+7uCbnCUUhpZMVi9oPK1cm9QpUOyI
	 3aCFQVF7Bs9BdAXn6WDQYrpZBAvmWCA1YAFEAqjv4hFDQu7l6QMN2E6u/wVxzyXyFj3Yf
	 Yh78oRIFmiMTwA9WlLLV/i0UjkjyuihXNoDBQOqV2OI65MkGuwsiQ2/o3nr7zBKLt6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=McyJdCl9vaE9pANSWjcEY5aeFrZHR3D3ya4a+4tVR0A=;
	b=EeQkl6L2KjgX5yLGubfsF6GmHkvzwvfUYSu4cpxpOUpiu6L9cX6MLzSkNvge8e5EU4yY
	 h4IvXo0gbt4WH6c0K8/xEmTVdd4Ln5qL39ON73wwfmWkpHWc79oQQB/tJzMlqSFJF4qpc
	 OJWZPKZJGqj7saWOiXJFyJ6DAtOxLAocdor7jIEjs/tiTzFSlw3CRCwKj2k8mItsZDBCz
	 2LJlKOzCfl5R9oCn77Cz5FIQucQX+tNDzBusDytLUanIKZrwX87vfMv91GFJM01/agegL
	 Es+xPUuJCtGyGpOwOjSErFtsHsgOWVjE55X4jUTDzLX7bDdPChtH+bBfFOfh+ZAzupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOJMUjkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E07D606A696;
	Wed, 25 Nov 2026 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOJMUjkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982A51F000D0;
	Wed, 25 Nov 2026 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620986;
	bh=McyJdCl9vaE9pANSWjcEY5aeFrZHR3D3ya4a+4tVR0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOJMUjkgJoZMVCmgge2OlH3BdL9mCRBO+xqSBcfawjFrQh8bdi2tDoV6Aj+rkDVqs
	 WY7VfYex85WdJmiWHoq9ox/EnKZVicvz3BW8uQ2O5Ms6dPQNnOvznWF6c5g8QhIjlC
	 zbo4WLNeIs4VzLcBi0L/DwnzmjEgebOIFRlpZje4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Luigi Santivetti <luigi.santivetti@imgtec.com>,
	Michal Wilczynski <m.wilczynski@samsung.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/990] drm/imagination: Align rogue_fwif_hwrtdata to 64 bytes
Date: Wed, 25 Nov 2026 15:24:12 +0100
Message-ID: <20261125143824.083061640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Michal Wilczynski <m.wilczynski@samsung.com>

[ Upstream commit 6c6200ffebf9766fd5d9293002298ea371c261c1 ]

Sparse (W=1) builds fail because `SIZE_CHECK(struct rogue_fwif_hwrtdata,
384)` expects 384 bytes, but the compiler generates a 336-byte
structure.

This is due to an alignment conflict: the inner member `cleanup_state`
requires 64-byte alignment, but the outer struct is explicitly marked
`__aligned(8)`.

While a non-sparse build implicitly pads the size to a multiple of 64, a
sparse build strictly respects the 8-byte outer alignment, resulting in
a size mismatch.

Fix this by aligning the entire structure to 64 bytes, which resolves
the contradiction and forces the correct 384 byte size on all builds.

Fixes: a26f067feac1 ("drm/imagination: Add FWIF headers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512131851.1WNXk3BC-lkp@intel.com/
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Reviewed-by: Luigi Santivetti <luigi.santivetti@imgtec.com>
Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
Link: https://patch.msgid.link/20261029-fix_imagination-v4-1-689745dd52ef@samsung.com
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_rogue_fwif.h b/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
index 5d590c4c25663..2f8daa93c9e68 100644
--- a/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
+++ b/drivers/gpu/drm/imagination/pvr_rogue_fwif.h
@@ -2174,7 +2174,7 @@ struct rogue_fwif_hwrtdata {
 	bool geom_caches_need_zeroing __aligned(4);
 
 	struct rogue_fwif_cleanup_ctl cleanup_state __aligned(64);
-} __aligned(8);
+} __aligned(64);
 
 /*
  ******************************************************************************
-- 
2.53.0



