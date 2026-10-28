Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211530;
	b=IVmNekk0UGkHCaRzrZyG6scrF9XPfTo7hzYCr3i28B1WYoMDzbgp9LCKxDIRVAmpFvk/
	 A63Ciz+plq3sIpnJmSWxW7Kfcu8Lw5svJt2yOhB3i4kroXpXVKJ7PBUtOO5u3WfmGSYs+
	 ikbf7OkXiZGq0YF4j3w4hiGvQIYD+hlRLwXLCaqNxkf5hUhaZDleEUWSbZnYRLPq7EcDZ
	 Y4X98oA18eOVBNhoZ/CdQY9RYK3S13WKHS+tf6PfyS+IWw4pQhoGY+iD0OZYh8O+dSMXi
	 vwOK/zk9yIMH4Ei5D80PS5+bdBQra8vJ6Z2BHDPcWk4yVYg+HZucda97FsIMPuL5bww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g7CHa46fW7KKHmJdKsUZosmrPVQ6QmBPLVD49Jo30CI=;
	b=EtCW04SVUGeA7MzRttcnImPpIbV3ja03s5p7Vx20tWJRGr/m+sYVNyd8g0ybXltpEg0v
	 f3MlfeHTrEmZU9cu/8BGbAhzpccJBvoBfHpiy5UzvFKAnisMoFnglErcFRxCS7fUfX3Ew
	 yKtiHkIeQ+imIVoKYdzD3rTmc3saoI9NZr3mU845KHE3i3IicQ/n5tZI2mYdkQDFF3+fm
	 xP2qe29a7Ba5oToP+hoLlI/n32rjrfUZixZ69rVBd5jf2VosPFYCwnzGEfdcyEQml0Gks
	 uGiCEp8N8ZsYKuQ9YmHzt/tsZgOv98rwpEbf/ng53mX5MRyq0zTMZ+K9YN8eR3Heb7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uz6fC5jC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7554F606A31A;
	Wed, 28 Oct 2026 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uz6fC5jC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7851F01825;
	Wed, 28 Oct 2026 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211530;
	bh=g7CHa46fW7KKHmJdKsUZosmrPVQ6QmBPLVD49Jo30CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uz6fC5jCvrUHVsJ9Yai5fWfE2judgUM8xnU5ZtpLSD/FCvsJNXc+ukHDOMp9cTOCo
	 GiTKyhgtaAtXpjmAe8uS6kNwp6EBynwJuCS6TCm2tir0+KlfPdkZl4wfOGzRKBabkE
	 0SHo02vfl7PbDYFRMDV1MGpvjLbtmOEAB3RF2mg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ezrak1e <ezrakiez@gmail.com>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Srikanth C S <srikanth.c.s@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/571] dlm: validate length in dlm_search_rsb_tree
Date: Wed, 28 Oct 2026 17:59:15 +0100
Message-ID: <20261028170017.694215279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Ezrak1e <ezrakiez@gmail.com>

[ Upstream commit 080e5563f878c64e697b89e7439d730d0daad882 ]

The len parameter in dlm_dump_rsb_name() is not validated and comes
from network messages. When it exceeds DLM_RESNAME_MAXLEN, it can
cause out-of-bounds write in dlm_search_rsb_tree().

Add length validation to prevent potential buffer overflow.

Signed-off-by: Ezrak1e <ezrakiez@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
[Contextual conflict due to dlm_search_rsb_tree() using the RB-tree
implementation instead of rhashtable.]
Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index ffe12593a8b79..88ef7ad1494e2 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -449,6 +449,8 @@ int dlm_search_rsb_tree(struct rb_root *tree, char *name, int len,
 	struct dlm_rsb *r;
 	int rc;
 
+	if (len > DLM_RESNAME_MAXLEN)
+		return -EINVAL;
 	while (node) {
 		r = rb_entry(node, struct dlm_rsb, res_hashnode);
 		rc = rsb_cmp(r, name, len);
-- 
2.53.0



