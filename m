Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60421403E9B;
	Tue, 21 Jul 2026 18:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658530; cv=none; b=a/D6Qs5sKvZzv0E4D+nC5gRjib7rhdqkPfOUkjDDrLpkM2gknxQtngePipJaFg6/Ax6wPlKEzSHZaGsTm/1Lls22u+QfuCxNUqMDBK1FchJN71aEmZH3tYSeAZIiwUKaTfODPFrprEWXZ7BtSjxBsjJR+xrKvGMP9j4uT58m2L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658530; c=relaxed/simple;
	bh=ZJ7Pw9F64RmEgJ/D/zTK9n/oPqx8YCthwFfmlYoNbAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VS66fvVnEQ8Ob97Sr1iopMj1mA7FIr15uOn5qPPG345IhRQwVVVMwHiUEjA9Fsn3nACEfdOzkuEmBtz8dqjXkZtOVT+zcB5pawsr1Js/jDzqHGjSH1WPVOvJMzQqGmMl9gUeMsbO2Y1I/Y7rJ1wJSbINFX5XObZjQB5tpvyDDKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo9MX5kn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo9MX5kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73B61F000E9;
	Tue, 21 Jul 2026 18:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658529;
	bh=SYJtDGU1/rF6SPacau0wsituwhUXZRPIY5k8LIIQ+/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bo9MX5knjvP5EfAg11fRjw1tlZ64L0pJa2b5xfQqAt6+mUNyqxC69FH6DnvAEWQq0
	 vXInO6iBpmOQeYteTZw+n02xDJJe9oiZiAd6FxPDFVLRPM52G3OiqnfkXNByE/3KJ9
	 QdC789HgwHw+b9TjdkdnxY52hKCKOF45DwfXpz5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Hari Prasath Gujulan Elango <gehariprasath@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.18 1178/1611] soc: ti: k3-ringacc: Fix access mode for k3_ringacc_ring_pop_tail_io/proxy
Date: Tue, 21 Jul 2026 17:21:34 +0200
Message-ID: <20260721152541.929200060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


