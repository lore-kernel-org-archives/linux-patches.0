Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215419;
	b=V75TBW1is751QRWq+ste7ap3sQqDaNta24xk9Wzp8Ry0e7OqRsIIrFq/Cfna6EiOo1DI
	 B3eztxZc252ZFTENcH29iIil+qOE6UdoT1kwVT+carUPENv0MJ5wdZDcFr4IVTjN+tpzO
	 XZFgrTpgG6aEoNMyhCxAkUJ4pqOEJS00KkqWCS6QJnBhmwlJrf5/THX7wucUJLirBD+bh
	 byAHq7RUnW4jega8ahh1pAp2478uBPrJnH+9P8P0eE99xfWWUNDUsfSb78q4fVhP81EiC
	 Vn25HodZrygDez3Hbien0PbGHDykv2BfUUpgc6fSFX6UkAKFpsZx8SJuzf1TDDTveQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eyi5Uw2rwxcuTwtuXPqK6Gkszrci//130voo7n5jP6g=;
	b=OFOju3iNV5V72j/2kl0KDRSVOBzLml87QpzWcQ1yTmTdmQC7Qq4me1LzyBqrYoa7r/7w
	 eiCXORKreE3pZxY+XNJ5n341LInpzPcNm7M+ndeweSfq81wpyt+0aEg1R7tD9VCmBvVd+
	 IH/ZkswIqWHv7BAb2amz+JntaicAcq+odK8bMOJGaynkl8YwbnnKchm4rKjrbryoYM36p
	 r7vDi0Z0j5vWe9fy6kuS3BYDrXjbSwVNstUnF5iHA4OKZB110PEilepTw12FeaumBSRcy
	 AmcZ8bxCikZKkfdc0YZiOiwEd+rcvAfGqyMnhAXetwIN6B1eu0lcsFwAFe8m6FWBobw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWNoAElK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48970606A322;
	Wed, 28 Oct 2026 19:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWNoAElK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9809F1F01825;
	Wed, 28 Oct 2026 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215419;
	bh=eyi5Uw2rwxcuTwtuXPqK6Gkszrci//130voo7n5jP6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWNoAElKyMpwu6Ph/FP5goirbto+jKd8vtG0Q8g7C0E54hkCDYsUDEZE35sNy50YX
	 bUWc/sENjC2afQwFPwGg0Nz4xZdJO/EY1eTG4mrld8gw/lgH3vlHL6R8VhzWtag9mH
	 y0JdDh09Ktgh+P1/v5EEl7bGKKgUq0DIE23Jd/vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1204/1887] dm ioctl: a small code cleanup in list_version_get_info
Date: Wed, 28 Oct 2026 17:55:00 +0100
Message-ID: <20261028170526.805581577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit d043f9a1ca929eee76dac940b4ccfb5429e6098f ]

No need to modify info->vers if we overwrite it immediately.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: 76c6f845dc0c ("dm-ioctl: fix a possible overflow in list_version_get_info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 57d0bc1545b73..b6f561ed3236c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -695,7 +695,7 @@ static void list_version_get_info(struct target_type *tt, void *param)
     strcpy(info->vers->name, tt->name);
 
     info->old_vers = info->vers;
-    info->vers = align_ptr(((void *) ++info->vers) + strlen(tt->name) + 1);
+    info->vers = align_ptr((void *)(info->vers + 1) + strlen(tt->name) + 1);
 }
 
 static int __list_versions(struct dm_ioctl *param, size_t param_size, const char *name)
-- 
2.53.0



