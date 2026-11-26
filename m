Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704354;
	b=oKtkkKn2O5vHXoTdazt2kkBoIbP/I2WIPAyWM5o5PdWAzZo+qYnp2S4WdYY+3ZP9rukc
	 jQJtnV3OKHgyiaXaSvp+VrZL2sqxuU2QGl5fCU40USjwAfO7oksux7u6+7giRSI2t7D/p
	 Uf6uSDBAnJncUkHiB5c90vkud7Oh2lgielQezG6XiVD3EiXhhJ3+REabGEr/EcoPwk4fW
	 2xRKbqTdnx4Ocl/BfwsPY/1DTmzFgXBU0vtb1OWVTJjvGG9xj0/VHzeKhtkfUWmA9q2lj
	 Cy64tx4Qyf4JcwAs2bLLwRoTfNs3JzLBgHNroRWmmD3DjuijqvjQ5LFhImOH/DkgXxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U5KuE0r122nTvxtu3SZvbRgfhAbLnimSnFkW15Q661o=;
	b=dvzvAil+6PlBnn8VyJh/Ll38aVmoytkB+ciBo6TE5b+Sf4j7r2Nh+JaTewSCAjJsSizk
	 LmCwPKuGc/LcK+dL0pe54Mfw7ZZz+VA3bNttztSB1y3UJ2iNJLkWQNGNNp2u4AtYX/DUb
	 N8x+9Kp2ANR6XyQd/F1JX8dhNF7nGewsWHM/5Xnev5B724IMJXHYGNpWbzbPJ0drFfKi7
	 154CLFYqbAjw4hP6JAvoFYmPJbAFfUapOFkYjNWDKEV4aTp13osDAFfcM0Rfuri1QO8bO
	 TTCBiRQeAFBB0jHpCOgE5RR46iD6Ipc/zbH2enKZXaDLt7rCv/91NQi3uYm1l/CYZvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCZAYg6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAFB606A31C;
	Thu, 26 Nov 2026 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sCZAYg6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA31F000C6;
	Thu, 26 Nov 2026 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704354;
	bh=U5KuE0r122nTvxtu3SZvbRgfhAbLnimSnFkW15Q661o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCZAYg6c9QQMXm0Rgv/UtIrPssdOb3rwuQFyGRg4hCmvNv8wJZ3nJIHcX2gnzIiaQ
	 VwwDVrfBw743ZXSN3EHwgQZYDnLD5jJyIWpb97UjZ98h645t9RHU2h0n5qSyZs+3yV
	 n7nP8m4HAJ8RzPbdt/f6sxr2LIq9/+pb84/tWNEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/265] vhost: reject invalid IOTLB update permissions
Date: Thu, 26 Nov 2026 15:36:20 +0100
Message-ID: <20261126143608.610508517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index f1f35f239354d..d107789b13fe3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1171,7 +1171,8 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
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



