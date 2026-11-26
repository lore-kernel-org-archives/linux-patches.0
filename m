Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705098;
	b=frE9br/7kgPuCGsWuRkKovpss2cADWB5UVSQeYMbePoc2sg1863CqAMCBn1QvB79H8/U
	 Gbf7iUU5mI+iVv79XPuM4D1F1a2WXm58BHXdzwqkSAEIL665LaOG50QRf2ANK54eDnX4x
	 1/OqvNV4oWu2wMXlO2J5nGf1BxNk2P6DGd6USoQoglas+pUa2PLaSoVAp+hcy26zSnLxw
	 Nb0Ho4WRaQ8Nmk3eGWQyPR9ume9XLQZIe/Fhkh/zGBo/aa2+H1A7YP2gUqA6neKokXYWt
	 aet50yoHiSrP5Ufv6v+hvNJOLP0e6egwCGKuusZ8XwqCZsdSseNIUmnUavEDnYXbqRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ilmnwclwzCCXL1HhTloat7OtwGvw91zo8TanBjvzbrc=;
	b=zT7nRuMH7HIxxVnkv8AgkQojFEao4tB3WSYJjGXnRA1wOh1Y3qs0t36tBsSta+FQi7oS
	 gwRZKaS7Yqo9MSAzu1yYggWxQS4BFBTtysHQjEz/aeg7gjlCbwltFZ2Z8m6jIDDgOffUZ
	 Ab8sJRvwf/H0bSGVmnkJrNdhBJda1wZtzGxgGoEJwYPHuUu9K6s76hMcC63v/3QviKBsi
	 YIhdFk5TAyVmohri9Uc0O6hJxw4YPrWGtSPgQ2X5v0Viz2CPUkS2vumJhAlr+x/IVd5UK
	 OjJtG1NBtKTJhDhpOo8O+l2wkc57YHUWm08lKlvgGNIswK4y4dFo4OoOEbUpPUZu1FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seNvvbcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FE9606A339;
	Thu, 26 Nov 2026 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seNvvbcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F68D1F000C0;
	Thu, 26 Nov 2026 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705097;
	bh=ilmnwclwzCCXL1HhTloat7OtwGvw91zo8TanBjvzbrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seNvvbcvZ9VsdGc+JbYgdnqZZdG5a0TH5kgiZsC/VnhiSVVjaQemUT+slj/t4IGyK
	 yrRICj3p5H4i8dFEXSmB/Mr92ZnhJ12yykhl/jnAFTnnE0n8w+O//WDsKzIE/gPnzl
	 e30eoAjQj/Zmtp6TJ+b29rj6nhqrSLZTIAuUIQhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/319] vhost: reject backend enable without a kick file
Date: Thu, 26 Nov 2026 15:37:23 +0100
Message-ID: <20261126144008.432471472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 509f6bd229e94fc39506e01be692c4aa22338b49 ]

Enabling a backend without VHOST_SET_VRING_KICK dereferences a NULL
vq->kick in vhost_poll_start(). Reject the request with -EINVAL.

Fixes: 264ee5aa81ec ("tools/virtio: Add --reset")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261011-fix-null-pointer-in-vhost_test_set_backend-v1-1-60b2f12d64c6@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc79f682..e68611a566272 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -288,6 +288,10 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
 		r = -EFAULT;
 		goto err_vq;
 	}
+	if (enable && !vq->kick) {
+		r = -EINVAL;
+		goto err_vq;
+	}
 	if (!enable) {
 		vhost_poll_stop(&vq->poll);
 		backend = vhost_vq_get_backend(vq);
-- 
2.53.0



