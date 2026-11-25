Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624261;
	b=Q/U8prQ38hpeAgmyCvrfVPVbd+xMewxRzZYJgdHpSaO+sSrFBs2eQDrsJxQhwYuOYBz6
	 JjqP78082lJSlzrodfOwlGrE2DZvznnDoFMKQWNwWw/sdyBNb4+MUI+2h6a3FiJvY9+XG
	 ApQBJS8o0LqdoXgXRSFqLP1L12ShyoQqGQ7dBqDuA1aDiiW87AKxlGxQ7qVdEDVkP852R
	 1jBIgEzF9iV9x+OU+31t+/BpULce2Re0MHxKtPgXEsQ+qnI8K5qHh7SHeG5YmT/IGq+Ss
	 pue9aqLjeZWIZ24rwf3UE9EqRuaWtLYbhUdeSRD+j+IRZfNwPQANUY9Rrif87O4/E3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DnUwuk8t2uYkCwBkZcnoQW+xOho7Wo6gaI0O3Ep48eQ=;
	b=IFmoZ6CUk+LDVABYLyMbdX5jlbYHMWxqhimVwf2Vfg/1aX+JWtT8mLKEnvqHQvzgMP7x
	 qhJWBt6bWoC1tW1Mb+0xYS4ucoH39ufEH7yodBiSwS9qNFqxozySza3SYQ7QEd7mRyDWv
	 cn9aM0ZIfckUREs/6NACrZjexL2IzWo/hEyA0dZ5voCSl6wvdQcc7w2y5KRe8+jYXz1/r
	 Dop4RWD/7YjbuPBxcLJBvSMufgiLpy8GrHINkBj4gAgNOoewAfpG+iEKepIKuWS0QMnG9
	 RcTBKYn5SMlDJ3Mqn9TkFHRVdX7fAs2eM80WoIUErmfZ7CFUv95yD5FDF1nXvrwzyJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H0AFCeCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98181606A68E;
	Wed, 25 Nov 2026 16:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H0AFCeCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919C01F000D2;
	Wed, 25 Nov 2026 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624261;
	bh=DnUwuk8t2uYkCwBkZcnoQW+xOho7Wo6gaI0O3Ep48eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0AFCeCIha4TUzeaK+UumSSTUsNSJGr6dlpfoMQtDytD3KIiPx+ndZyjjEjM0hd/v
	 3ABZQYnNuOLGHSz9n5FbhoX6kXgEih8rJXAWfVntO0f9Mb33UqrjIWBXEGXRwwh7ir
	 fZZs8EG7OFX40xCRy3PmU+pZiZIpxsSrvnmV7gz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/816] vhost: reject invalid IOTLB update permissions
Date: Wed, 25 Nov 2026 15:28:05 +0100
Message-ID: <20261125143852.374341287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit b179f21d2d8a60ede29a00472bffdefb0284ef39 ]

vhost_chr_write_iter() validates the type and size of an IOTLB update, but
does not validate its permission field. An invalid permission can therefore
reach perm_to_iommu_flags() and trigger its warning in vhost_vdpa_map().

Reject IOTLB UPDATE messages whose permission field is empty or contains
bits outside VHOST_ACCESS_RW before dispatching them to a backend.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260913-fix-vhost_chr_write_iter-v1-1-76bf1f436cfe@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9d5ea96f67ce2..bacb48308b084 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1728,7 +1728,8 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if (msg.type == VHOST_IOTLB_UPDATE && msg.size == 0) {
+	if (msg.type == VHOST_IOTLB_UPDATE &&
+	    (!msg.size || !msg.perm || (msg.perm & ~VHOST_ACCESS_RW))) {
 		ret = -EINVAL;
 		goto done;
 	}
-- 
2.53.0



