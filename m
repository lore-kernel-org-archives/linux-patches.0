Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052862;
	b=2PWZR/4eWmrWY3/CgOQJRg5zcnbdEg+Uekiwe/oQe+lwkHkbzIiL3j1W9H71FqiQJEyA
	 1HAXMcCPMZaJW1LYX+Z2ZHt+AvMJ3XV75JLhVryYEHrKUvEE2x1Y2DUey94D4jgv7I3Rt
	 hgtJhr10Y4+jGa7rM+rnuktFL8uSqS2+fL7G2bF9bYgjl7HY+Qa94S2j+3/FeajxhnhCB
	 H8Px6fqvRZlT1Ntmi8rmNbK7bOjsAco6/guEMw8dqJ9yr0VTtoboFDtMDWboW/AdTNEYM
	 3qEjmu9kCZfhA+rAMT2TTCwjg+J0Eok5cQAFtpNPSESIcQPtCpoao2ZfUSjoMNjK9mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ZA2BJNY4J2wTbQrZ7Cx3T6+5lCQMDxIoUC/OI/y6xA=;
	b=QLvoe6L5ITi1ARJcIkKGYD62EFQUONjg3mYauhrLKy5jkDAA6uMlMTXSZD6RQUcAFV8V
	 cS8SgLEKlBdcUmqfWSASCzcSSvluFWq8yK2GFpZXcv2d4EeLVFXqTyfKoQavx9ssrMm6V
	 g80LfAmApMlDVhLHO7h3vXja1Qy2HkniVZCtwSzjOIH5tNcRfvtgsEzSP9z/ggaJVlUf5
	 qjd47VYRgN0k2d2RxxKfWa3dT2qYfuto/XfTpWv0wyMfCkBllYK/im/lXX3ynn8NNkMxV
	 gNy7q9x3EYzJEsoDUg3Ty7bFBo0QBRsyNtLftzS9iCM18c2i2x7amVYH8sYtroe9vjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nv9sGUeB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE164606A31C;
	Thu, 19 Nov 2026 01:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nv9sGUeB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B671F000C4;
	Thu, 19 Nov 2026 01:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052862;
	bh=8ZA2BJNY4J2wTbQrZ7Cx3T6+5lCQMDxIoUC/OI/y6xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nv9sGUeB11xwis3H/sTPtNNK3Z+cpEwaaI/1kYEwQP8h8iU5Qz0eBgH+QmYnvxDqv
	 o4KIrZhEb+tSlblbaflu6s/uARJy/UgFGriO9ZwBj3r1jBuwrhH0akCB7xJ1aK/ugJ
	 zmJ0Q69cFEeGZsOmjHebUVQVr1fsn8dbeQ9wJimQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0713/2214] libceph: Fix unsafe decode in ceph_redirect_decode()
Date: Wed, 18 Nov 2026 15:39:49 +0100
Message-ID: <20261118150040.333340748@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 0405670e50f213594366ab7eddc07002bd7f84c0 ]

ceph_redirect_decode handles unchecked data received over the network
from an OSD. Currently, there is only a bounds check covering the first
three decode operations. After decoding the first len field from the
message, the only remaining check ensures there is enough buffer space
to hold len bytes. However, there is no guarantee that this value is
large enough to hold the subsequently decoded fields. The decoding of
the second len field is missing an explicit bounds check. Consequently,
a corrupted message can trigger an out-of-bounds read.

This patch fixes the issue by switching the decoding from
ceph_decode_32() to the bounds-checked version ceph_decode_32_safe().

Cc: stable@vger.kernel.org
Fixes: 205ee1187a67 ("libceph: follow redirect replies from osds")
Assisted-by: Cursor
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 794ad91eae26d..3d91e8092d0ee 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3575,7 +3575,7 @@ static int ceph_redirect_decode(void **p, void *end,
 	if (ret)
 		goto out;
 
-	len = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {
 		pr_warn("ceph_request_redirect::object_name is set\n");
 		goto e_inval;
-- 
2.53.0



