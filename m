Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7B244AB8E;
	Tue, 21 Jul 2026 22:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674303; cv=none; b=ju2Q/z5gjqCSap8wDbyW10Ntza4W7Qz5womp0Q/boYU49E3L9SRQHSQgfVE+IeGAYhgzMp9djmIxYF+oMiCj4Yr817Q4dFbmvi/MHE3mcoyyuUJNO/g3JJidPwvwni78Ew61SQnKYTNEKkHl+RQWOtIgDw4WYng4g1MCp8rudLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674303; c=relaxed/simple;
	bh=BqUrD1+9kGtFVD5pjp5Wt+SpxxlxjB41g5vbmuCY2D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZbr+OG3u37TgU3CaGsRB5dAALulzk0ymhUawc11uV0YxJfJDK2CYJABS3znLzN6gZKW/65j9ftBYW/HXjbSaz2A4MbTokiZfWdWi24gIbXo0oXtV2RsLWRWxJrEs4x6SL4g5n1mSjsONuajFxYRjk5ykkDasw+HnE6R4NUIiTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEuc6RfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEuc6RfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A3E1F000E9;
	Tue, 21 Jul 2026 22:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674302;
	bh=vmvuxIb6kEhqN0izzrBpeMw1w85xvo+ZhZcnkdicYys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEuc6RfC8UUz8bYGSnGPzKaHh0AxtyqNOq9SbUGBPtyEzxZh2YjHnfavtqPeT5R2F
	 Fllj9AnmKXDl3l8m42EO56oTkEmHIqZFAblhPUb1b9HND1q8I/1LHst+Bzmtf/M81a
	 m3PD6oFRI6hq1DX2saoh0SJe6xHdhhHRbOvNsQg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Hari Prasath Gujulan Elango <gehariprasath@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.10 453/699] soc: ti: k3-ringacc: Fix access mode for k3_ringacc_ring_pop_tail_io/proxy
Date: Tue, 21 Jul 2026 17:23:32 +0200
Message-ID: <20260721152405.920314902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit b920352cfd2b0fcd1249ff006618c939b64fc8f7 upstream.

k3_ringacc_ring_pop_tail_io() and k3_ringacc_ring_pop_tail_proxy()
incorrectly use K3_RINGACC_ACCESS_MODE_POP_HEAD instead of
K3_RINGACC_ACCESS_MODE_POP_TAIL. This will result in ring elements being
popped in the reverse order of that which the caller expects. Fix this.

Fixes: 3277e8aa2504 ("soc: ti: k3: add navss ringacc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Hari Prasath Gujulan Elango <gehariprasath@ti.com>
Link: https://patch.msgid.link/20260501124129.362192-1-s-vadapalli@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/ti/k3-ringacc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/soc/ti/k3-ringacc.c
+++ b/drivers/soc/ti/k3-ringacc.c
@@ -824,7 +824,7 @@ static int k3_ringacc_ring_pop_head_prox
 static int k3_ringacc_ring_pop_tail_proxy(struct k3_ring *ring, void *elem)
 {
 	return k3_ringacc_ring_access_proxy(ring, elem,
-					    K3_RINGACC_ACCESS_MODE_POP_HEAD);
+					    K3_RINGACC_ACCESS_MODE_POP_TAIL);
 }
 
 static int k3_ringacc_ring_access_io(struct k3_ring *ring, void *elem,
@@ -895,7 +895,7 @@ static int k3_ringacc_ring_pop_io(struct
 static int k3_ringacc_ring_pop_tail_io(struct k3_ring *ring, void *elem)
 {
 	return k3_ringacc_ring_access_io(ring, elem,
-					 K3_RINGACC_ACCESS_MODE_POP_HEAD);
+					 K3_RINGACC_ACCESS_MODE_POP_TAIL);
 }
 
 static int k3_ringacc_ring_push_mem(struct k3_ring *ring, void *elem)


