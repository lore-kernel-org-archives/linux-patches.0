Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705024;
	b=mbeMvT9bCBVP+aQ1YJllxs3yyiMnuIELldN76fwi4snTTabogvD57dZVf0b6SgTMKND2
	 /Ur6fud6hzfrAz2uAdy8UmHQ/z9TfL697eOID/Hhj+jly+38an0OWWlYCd/2jnDKkMgxo
	 5BKwHNxu4DbGJhtdi7UQA/Ot3yRVqgjUgcJ5cxE9DsXXOJIyqy7bR4twMH1GSBx/E4f+z
	 wz/92grmeXDzeAsrSIfy7wLsvKCayMmZuc/EwSMRo5OhUDD84DNMREfJCCSY1/+Z2+kCG
	 68p3qi2E58jyXbD2T6THBhanaX5FIjHuerHj36SJM7M3X3fWsV0SNOjtjnAxDxROuvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vpfgYztnK1O5uwhjO6HIBdp/vqfq7VmMsKhqIbb9my4=;
	b=KLlC75T/pgUvp/GEq2RJN7Py/o+IHyq5sPUN2aJ7HZxF2/ln7DNpHxhPGGPt5xsuiCD3
	 h0WwBaHLM/sFWb5bRMqBYHveNCCa6/7yeNSWVGMwOORXlIcaTX7q2ZNeb6Rj9HraHMhFn
	 iJpL6Xkwp/YbksdAOt1t0WxpR8eNS7FMw8L9ODJSIbRvmmL0c8DXsZKR+k9jKHCp57h1H
	 G+WuZztWS8OKhvfLFpkMRSllkS1DxOa2bT//VHMZ/QMabwhrNE/Dwt5/13I89iwuZqwSw
	 UEqmO+Pw0U8yDirsQTdLVTlbmZEQGr1jojQg1uYcEtK9jlQ3p3mCjz90/sqjeynj4kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fArxERMe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7544F606A31C;
	Thu, 26 Nov 2026 14:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fArxERMe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897191F000C0;
	Thu, 26 Nov 2026 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705024;
	bh=vpfgYztnK1O5uwhjO6HIBdp/vqfq7VmMsKhqIbb9my4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fArxERMeda3eqlyH4WPtAbO19GL28JUAH1XvD3MoEe0pbQyR5JzE8eMQqYnhGAiSm
	 ZdS505lV0e12IZ/fogNVu69ZVYB64guHXNcd3ASRYAH5x0e7l3qDyjxHytdNKmqZBa
	 73TrLgz18NBnkdlRpt/C8E2fP5LeW8cIROwCsntc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/319] vhost: reject invalid IOTLB update permissions
Date: Thu, 26 Nov 2026 15:37:04 +0100
Message-ID: <20261126144008.003069750@linuxfoundation.org>
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
index d8c81c25b7475..15ded95d4117a 100644
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



