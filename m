Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213428;
	b=jw+HMu+1YFHFO7iIY4LwieEpzoLRIILCgYNDRB25P9cqviv5bWXw/tnL98UDhUNlkvWx
	 bmhVRK4Uvw1QfBE4cVjIoqy8mhtUI8xO+Ewar7o9W3Dp+eW7VuDASiUOil8erEl2VX8CU
	 g2M/3W3OxeN5tXSBKV4Vo08HtDAo/ugFSuWwvd+/FeY5wv6ae4I6C2iv5zitqEqBFM6Fm
	 aYAtN7cCwN8A3aQI5DKg/qZq146B5A15BxG/PS5NgSVQJBN+S6p/RkkUt7wAUMu1EXFrT
	 GaPyGphcvNt8osPQOhXK8EoVqpNTj0hYg8mDrj8ychY71e0/pDAJY0prJKlcgcuHsDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Ovq51iY/uHBh1TkF61NHBKul+E0x/zdvSMrrwDaFCc=;
	b=oCY3zi2l30PFK0B0h+9iecwKs3+M2vdCkX5xSVOWcjftpOTEVp91e/vleqH9hZaujhR3
	 6LghNk9ASwqvITxEbfBxDuAaZOCoxzdmPwcKLFpFH31mxs9KI0QMmI8g9wJ1S3WxzE7Zs
	 8C+RWirh9bevm9QwTFd/nk+qPhY+XDE79kTuOgQnJX6HjtoZr1HpsaJCBPOlyee81XucB
	 ixYKOwLcZQTiITqn9QVGwAB4OpHTPAzmS79rfnRVVQQ/8fGxpSthJejUmqMX6fku4erAA
	 fGq64dEV9kVsTAgV2DTWo7+XVXMp6VabBk5d7AvS6Vvrn3GyJ/Y1RUe51HXhOS+knlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxQZYmAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E869E606A31E;
	Wed, 28 Oct 2026 18:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxQZYmAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491741F01825;
	Wed, 28 Oct 2026 18:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213427;
	bh=1Ovq51iY/uHBh1TkF61NHBKul+E0x/zdvSMrrwDaFCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxQZYmAj8C6pAe44iDtQKdt+do3kFeXdi0jZ9ySB6Ci5ZzcVnIoueoFC2fXZwKach
	 omAKZtKW9WkQ/PrW5lSZAVRFpCQQMm08Md6veUFHv8+vLwvZGjJgxvi7e5QLymXuH4
	 7DzHWPTbn2ZubxL1zRE86ATymG6gzhZaw11/4eF0=
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
Subject: [PATCH 6.1 0502/1887] dlm: validate length in dlm_search_rsb_tree
Date: Wed, 28 Oct 2026 17:43:18 +0100
Message-ID: <20261028170510.722114403@linuxfoundation.org>
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

From: Ezrak1e <ezrakiez@gmail.com>

[ Upstream commit 080e5563f878c64e697b89e7439d730d0daad882 ]

The len parameter in dlm_dump_rsb_name() is not validated and comes
from network messages. When it exceeds DLM_RESNAME_MAXLEN, it can
cause out-of-bounds write in dlm_search_rsb_tree().

Add length validation to prevent potential buffer overflow.

Signed-off-by: Ezrak1e <ezrakiez@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
[ Contextual conflict due to dlm_search_rsb_tree() using the RB-tree
implementation instead of rhashtable.]
Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index d5aeda3399f95..8c2d4bc290177 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -456,6 +456,8 @@ int dlm_search_rsb_tree(struct rb_root *tree, const void *name, int len,
 	struct dlm_rsb *r;
 	int rc;
 
+	if (len > DLM_RESNAME_MAXLEN)
+		return -EINVAL;
 	while (node) {
 		r = rb_entry(node, struct dlm_rsb, res_hashnode);
 		rc = rsb_cmp(r, name, len);
-- 
2.53.0



