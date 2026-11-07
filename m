Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060651;
	b=Hploqp0qRcBXpHy4+YIlPSfC0n0P4T693kGxYdoCoDmW1EW0XvuMq5fCmm5Ph1cyjQ5L
	 vkP73YQOccrp4c/rw7SBt5G8msCYzYFlKa6rRpGD6JmhX213DeVAdsiri4vtOHU9hir+Q
	 ArudbWQ3pdHImTbQv1gtbWluXRKNxqJatkTG+m5ZlmBjEzQJ6oiQH8pTNloKzNBv7O9cV
	 CesSP2x8W8miyscjoE7eh3VdW+/JXuv6+RbMUS8mwOx7OPbRWyFWsvRLle4nJjHMLP6Er
	 A2By6oxvnJKlgHZz11ew70l+7lBCCD63rWT/hSx72zsCK8fzosPiHN7ecqHekIXGc8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G8fQ+CYuuqb6mlkXtqoazG3kFJo4HWSDpbTq37Kjmlg=;
	b=rjDgrrIvvnUoDhIVK+xmBBe/G1vFvSkN4tIypC/qZzgmY70f0OpQ+AdMjhodGI79Ewfy
	 9/WjGa7g8RJCjMfj6Q+96Mbao61hST/6lp3q/4UczCJ443S4IVeu3HirT6rNvjmaTVdqs
	 41eqUqvGHZgD2kqWkzWX/PVaxl/KlIvGK6M8Ry6KZaMMcUPvMR8vvyeoAlfKir+gGzxeQ
	 swVF2xKGK3cF5oDPf/NF3X35D/MOEBrrv0o/pXGOplqA+gmg2cFwFTuiekz2EIwa/t0or
	 Wotdr+yOOTevJ8pLhNWk1W9pK18kkPKt2+TIP7LqUzVwpHV0B9LjQqKHY+HEhAlMC7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eU7axOZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBB6606A326;
	Sat,  7 Nov 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eU7axOZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9641F0089F;
	Sat,  7 Nov 2026 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060651;
	bh=G8fQ+CYuuqb6mlkXtqoazG3kFJo4HWSDpbTq37Kjmlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eU7axOZB6ZRDXcO0ufozsA9BMqT9xTCqAmhk0XB7grD/P9ExjGhFE+Ai5LMtHigYx
	 9QnNrmfYFi1zbSu1DqhptWmD7pIYMBE4w7UU+NN9XgNobj4T4vKSUk58v+HNEVXRU7
	 io+FnNfuRxPIAZ2qxoWzHEMcMTMPJYZ/Al+4PREM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0092/1536] nvme-auth: use crypto_memneq for DH-HMAC-CHAP response comparison
Date: Sat,  7 Nov 2026 08:35:08 -0500
Message-ID: <20261107135000.250144228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c2fb22bf6846e..3812448aa9864 100644
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
@@ -365,7 +366,7 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 		return 0;
 
 	/* Validate controller response */
-	if (memcmp(chap->response, data->rval, data->hl)) {
+	if (crypto_memneq(chap->response, data->rval, data->hl)) {
 		dev_dbg(ctrl->device, "%s: qid %d ctrl response %*ph\n",
 			__func__, chap->qid, (int)chap->hash_len, data->rval);
 		dev_dbg(ctrl->device, "%s: qid %d host response %*ph\n",
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 634793a9a7284..83571f5a50d99 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -10,6 +10,7 @@
 #include <linux/nvme-auth.h>
 #include <crypto/hash.h>
 #include <crypto/kpp.h>
+#include <crypto/utils.h>
 #include "nvmet.h"
 
 static void nvmet_auth_expired_work(struct work_struct *work)
@@ -162,7 +163,7 @@ static u8 nvmet_auth_reply(struct nvmet_req *req, void *d, u32 tl)
 		return NVME_AUTH_DHCHAP_FAILURE_FAILED;
 	}
 
-	if (memcmp(data->rval, response, data->hl)) {
+	if (crypto_memneq(data->rval, response, data->hl)) {
 		pr_info("ctrl %d qid %d host response mismatch\n",
 			ctrl->cntlid, req->sq->qid);
 		kfree(response);
-- 
2.53.0



