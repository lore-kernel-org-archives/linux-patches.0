Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550AF42F71D;
	Tue, 21 Jul 2026 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670080; cv=none; b=jx/ikh/IzEx+gbnWIJKdxh/gUURKOJcU1uRQWAyPDwPeJ8bjJghsuuFD6Y5E9AolZgZqkkMhq3zFfYcBludaK6h66tj3BeOK7nlsMpGiLpvpvhxu178v0a3EB9PdfJ3Iw4HbfyurT84/hN1SEM3UAPcf4s23i58AYcHXW+IcHHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670080; c=relaxed/simple;
	bh=F3B3+wuZ95pYhkQ6n5vy7ZdY3AXtihZUaCgLzO+2nY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptHnQEJBeSMSyNzJXGoIr4vu2QnQzwStJ7phnsum35FIg5coliIOSJU1NS/1GhC2N2aQO+Pg+cYJ+DX88/b3y9HEJDpmaWy4zqt69PrypIHIkfqFdm8Fucg9Q3EaZimDj2Pi8TmPXdRiDUK3FlK+vYVSIuGhj8uQ4YxfQeUNgHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7uO/8JA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7uO/8JA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA071F000E9;
	Tue, 21 Jul 2026 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670079;
	bh=yibUkDxRWv0Heel7xA/O4KwiPxmSnr0WrwngbXr0HfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v7uO/8JArHx3j9WNX+oa9t47x+0nBgSGcNUyHbB4I5ebPqZ2tU39fzDH8OMD+w+gX
	 Af7CxupSV33wwrZze2gCHHj77EaM+B1Y462I/g27u2CUJT57RqWWWNL+QtgcRcf6Ol
	 LVZwR/nM44Zv4KlgA/FlBoT34XmL9V8i3l+TR+S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Hari Prasath Gujulan Elango <gehariprasath@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.1 0753/1067] soc: ti: k3-ringacc: Fix access mode for k3_ringacc_ring_pop_tail_io/proxy
Date: Tue, 21 Jul 2026 17:22:34 +0200
Message-ID: <20260721152441.418171691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -997,7 +997,7 @@ static int k3_ringacc_ring_pop_head_prox
 static int k3_ringacc_ring_pop_tail_proxy(struct k3_ring *ring, void *elem)
 {
 	return k3_ringacc_ring_access_proxy(ring, elem,
-					    K3_RINGACC_ACCESS_MODE_POP_HEAD);
+					    K3_RINGACC_ACCESS_MODE_POP_TAIL);
 }
 
 static int k3_ringacc_ring_access_io(struct k3_ring *ring, void *elem,
@@ -1068,7 +1068,7 @@ static int k3_ringacc_ring_pop_io(struct
 static int k3_ringacc_ring_pop_tail_io(struct k3_ring *ring, void *elem)
 {
 	return k3_ringacc_ring_access_io(ring, elem,
-					 K3_RINGACC_ACCESS_MODE_POP_HEAD);
+					 K3_RINGACC_ACCESS_MODE_POP_TAIL);
 }
 
 /*


