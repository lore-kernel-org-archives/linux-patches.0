Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883FD30EF7E;
	Tue, 21 Jul 2026 19:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663566; cv=none; b=uiylmA9ReL0uZ4Bm6dJ0EutTG8O2p4X27r3tety0fox02IPNLKBF5R9Kia/aOlmGJT0Gr+RoCmdwTJkoUzkOo5ztZNyNy/G3QI9ZC/AalKIDOA8wYMbRqMNYMFclYRSdSITO16UoIg1JgjvNp+XMnQZOr5jaEdMwSKKabRz9YQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663566; c=relaxed/simple;
	bh=QchNSG93DKgktbiXG6gJ/zzgqbYo8og2gX8vumg25y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siYn1qK7Ao1ilTgdtm8OENVjCi7uRU12kzfuiOWq/UJWEwL3qdQ6l1xMACoQdPG7OnsmTxCZ6lF6kXuLxBUCZleuQD2wjT1g/+3n9NuTzH2bt6efhNIBOQVvhqsaIBgjjteIY+677mhE+Plf5MyJkkpRKjOJIcPUg5ozL12bRgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smkqNG3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smkqNG3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4E91F000E9;
	Tue, 21 Jul 2026 19:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663565;
	bh=/qttcv9cJIacCFLYAY+AagI7PDvmN1LqM6OTDl/4C/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smkqNG3ab5UVuaz0i1LStHwH47eGdpSjqV2SE6hNdit7KptObeh3KIMWMXASBQhnP
	 yYrDU7u7Mn7RK2e/Mu7QRppU5mgK7B9X27XkN6Rx1JZ65J8VJJAG4g+aFTF5+CNQeg
	 xEntPakYa0T7pOcD5KVB34l8ebNl0UigagK94ttY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Hari Prasath Gujulan Elango <gehariprasath@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 0869/1276] soc: ti: k3-ringacc: Fix access mode for k3_ringacc_ring_pop_tail_io/proxy
Date: Tue, 21 Jul 2026 17:21:52 +0200
Message-ID: <20260721152505.498329774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1012,7 +1012,7 @@ static int k3_ringacc_ring_pop_head_prox
 static int k3_ringacc_ring_pop_tail_proxy(struct k3_ring *ring, void *elem)
 {
 	return k3_ringacc_ring_access_proxy(ring, elem,
-					    K3_RINGACC_ACCESS_MODE_POP_HEAD);
+					    K3_RINGACC_ACCESS_MODE_POP_TAIL);
 }
 
 static int k3_ringacc_ring_access_io(struct k3_ring *ring, void *elem,
@@ -1083,7 +1083,7 @@ static int k3_ringacc_ring_pop_io(struct
 static int k3_ringacc_ring_pop_tail_io(struct k3_ring *ring, void *elem)
 {
 	return k3_ringacc_ring_access_io(ring, elem,
-					 K3_RINGACC_ACCESS_MODE_POP_HEAD);
+					 K3_RINGACC_ACCESS_MODE_POP_TAIL);
 }
 
 /*


