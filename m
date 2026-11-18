Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033727;
	b=YOs2UzvM4vNucPBqicDqKNp2fAfNt5d/+MIRwdNYhjvECleBw7X0nkKsfeonpsmRj1U7
	 o68zK2U4psfr9Y++8PaJ6hvuwsEQ3JvVxeZ5hYiLENll0lh7XgjjbqcKFJ7UEhJWV+RDV
	 YeGW9tg3Zl9TaTs4JvH4Vc9tlVgKUFrE/SrmzKPAxCqv9DmQ/JDAbOXGCOijLZzGf1CgA
	 lei+csRdI+YrbgCCW0SA4D6EHjh064K5jX4yuF8k/LLzuOb8tXRvaeMGqRaMPo/OohoUJ
	 Aa+IJmwW3KgVMcHd+fk6L5oRK7AACMtOYqbXuOxUNU/CnaR7tfKhZ76uqAJuyGuIAfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3eNopM2N5Mdvf9e42gNm/uLburOIAhu7Ye77wIzNn2w=;
	b=zliu+qkgb+rNp+KzMyxhsJmQazBJHcOAowXQzZVLg+0P4D5CtkGdhJJpoJGOHxDjwiTk
	 YWrb5pQaaU8bjNMAXAwnSsEWapgVsqFBb+9KMb1/GprSHL0lFZbcHQfii4A39f/uZAJ1i
	 VoGJ9emvpFQNiyrj2ELt5sCeX9929iEVlyzmIy8ja8QpCmZhtf7eYGei+FWo1luYRDe7S
	 pzUfDJekQFlrWaRVyiJwcZd3LZsjGJgaki41dspzsYfO/cRBPszv+f//IlDKJNPxnHXWr
	 6T5kTSGzMBpL0w6T5eFdVRocbkrru5BWJT+1RTQOSmcaBQK63D8QxcLLlBzEp47lnEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U8Gs2D7S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6B7606A31C;
	Wed, 18 Nov 2026 20:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U8Gs2D7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801081F000C4;
	Wed, 18 Nov 2026 20:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033727;
	bh=3eNopM2N5Mdvf9e42gNm/uLburOIAhu7Ye77wIzNn2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U8Gs2D7SGjQwxwLHW4b633KiWDSwqwAs2QqpY2ZDWyamUMRTAWYpZjZGmZdoD8KnT
	 kz2mq6NAU+lGzEW4Xq0ayfLRVF3zZK4DUCVSW9bp/7mZ+Dn8ereYK2Ny5Czcs2WM/v
	 tAHq5SjMwrHirEYiZr2F83/xWu+Cd+UOxaLyXoHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0075/3318] nvme-auth: use crypto_memneq for DH-HMAC-CHAP response comparison
Date: Wed, 18 Nov 2026 15:11:37 +0100
Message-ID: <20261118150316.311709398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f1b0a8e7af896..9f2a6472802e7 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -9,6 +9,7 @@
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
 #include <crypto/dh.h>
+#include <crypto/utils.h>
 #include "nvme.h"
 #include "fabrics.h"
 #include <linux/nvme-auth.h>
@@ -368,7 +369,7 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 		return 0;
 
 	/* Validate controller response */
-	if (memcmp(chap->response, data->rval, data->hl)) {
+	if (crypto_memneq(chap->response, data->rval, data->hl)) {
 		dev_dbg(ctrl->device, "%s: qid %d ctrl response %*ph\n",
 			__func__, chap->qid, (int)chap->hash_len, data->rval);
 		dev_dbg(ctrl->device, "%s: qid %d host response %*ph\n",
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 935510c377a6a..25a3a927ae231 100644
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



