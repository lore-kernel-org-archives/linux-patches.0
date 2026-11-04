Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829406;
	b=huTGCAdAUNa/JogngCyfyE3fDlh8xp/D9/pRRPzN09F6VkYmL5PITQqhRZcemCAV94mW
	 MhadNgOJSf5lj/9knENgwR2PVYqD+wgAPFm0bqkjCDtmkBcmyFkzcbQNasCG5Zd01Yrrn
	 n7L2ChbUyYg8ZeIYwugBo9k9l06oEt9EDQZjCRXitUFPh8bZ+MTTGFsFJAa/Mt8XmvI8G
	 Thbm8gBgxTh9++d9TqEBOSoux8+BWYmrp3+5TzzumyPQw0rivxalT/goDy0VTviLbFm//
	 oJab78Mt30wl0IZGZvYC8nHXXnsbCrqFutxPFbO1dwGtp82/U+6wvyzAhfh95khDN/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AfPMIVCAykG8c0nJZBUiHFlk9U1SscROT2qVovLV8TQ=;
	b=VYrqw3psgYwce+26wvOixr1DQnyno1ylF+FGf43vUlWVwCQiwi6YVvNdT/02luk+sHpu
	 PradoKn0JknoE0M01aKbhuQWuX4aoYJHgPrvzLgV8d+g2d72phzrMCMKIrqH/e+JBAT7v
	 yrbXwhn/TprYmtPP+6TIOLQjLxKRaHTntsurWYNDq5kS4ip7toWCZicF8I/xyQSDcG+sh
	 uZGK2QsEwWhBjTOM4JeubOeyU2sdjEBK9IyeXkllhwAEax3AhkoqEYqF69tNKKDQRVdc8
	 2bC1tgfdZ3/Ce7kmGyeacb9V+ZHnZSTKpVldGF5vfzFKyMkwJFCxTPSQ7BATQRMDSIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D/x2bXA0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B8660C0169;
	Wed,  4 Nov 2026 21:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D/x2bXA0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7652E1F00919;
	Wed,  4 Nov 2026 21:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829405;
	bh=AfPMIVCAykG8c0nJZBUiHFlk9U1SscROT2qVovLV8TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/x2bXA0D6yOHUuSZfPPi4YXBI8qO0YZBWKYToiIghmQ4qklAqnOvkyWThN92XIvZ
	 ebhAYqtFNrFck7ZxvvDnvfRd6BJexWJApP8L9rwwkuc8ijXfnQ0tSbEPKWTjkJ9rcN
	 ShQ+XEjOwXZN+IXhWQOA9udyTbDMbW76x53AGxeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0107/1005] nvme-auth: use crypto_memneq for DH-HMAC-CHAP response comparison
Date: Wed,  4 Nov 2026 15:57:20 -0500
Message-ID: <20261104211046.649951525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 3a6d89836ab09d53f4c32c57588689a378ce4363 ]

DH-HMAC-CHAP authentication compares HMAC response digests with memcmp().
Standard memcmp() may stop at the first differing byte, which can leak
timing information to a remote attacker and allow incremental recovery
of the expected digest.

Use crypto_memneq() for constant-time comparison on both the host path
that validates the controller Success1 response and the target path that
validates the host Reply digest.  Other memcmp() uses in the NVMe auth
code (e.g. fixed string prefix checks) are not security-sensitive and
are left unchanged.

Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c               | 3 ++-
 drivers/nvme/target/fabrics-cmd-auth.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 8f3ccb317e4de..9d73713d6f828 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -9,6 +9,7 @@
 #include <linux/unaligned.h>
 #include <crypto/hash.h>
 #include <crypto/dh.h>
+#include <crypto/utils.h>
 #include "nvme.h"
 #include "fabrics.h"
 #include <linux/nvme-auth.h>
@@ -381,7 +382,7 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 		return 0;
 
 	/* Validate controller response */
-	if (memcmp(chap->response, data->rval, data->hl)) {
+	if (crypto_memneq(chap->response, data->rval, data->hl)) {
 		dev_dbg(ctrl->device, "%s: qid %d ctrl response %*ph\n",
 			__func__, chap->qid, (int)chap->hash_len, data->rval);
 		dev_dbg(ctrl->device, "%s: qid %d host response %*ph\n",
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 35bf1a2357d49..5b010318286e4 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -10,6 +10,7 @@
 #include <linux/nvme-auth.h>
 #include <crypto/hash.h>
 #include <crypto/kpp.h>
+#include <crypto/utils.h>
 #include "nvmet.h"
 
 static void nvmet_auth_expired_work(struct work_struct *work)
@@ -187,7 +188,7 @@ static u8 nvmet_auth_reply(struct nvmet_req *req, void *d, u32 tl)
 		return NVME_AUTH_DHCHAP_FAILURE_FAILED;
 	}
 
-	if (memcmp(data->rval, response, data->hl)) {
+	if (crypto_memneq(data->rval, response, data->hl)) {
 		pr_info("ctrl %d qid %d host response mismatch\n",
 			ctrl->cntlid, req->sq->qid);
 		pr_debug("ctrl %d qid %d rval %*ph\n",
-- 
2.53.0



