Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062644;
	b=qdFSV0VEqtQCjlQW7qoaMH/9LHZqMg7ZQ9EDqkCdwx3D2mfO4DA120gs2LzyyfDBF/3F
	 vUNXToutDDvku/PKh1JOhdTtH51dZZP+hrY6ir3IxwYqJKZNUQ+J02t8SEPq0VQJL4Rs6
	 F8cFRq/sXFKkSUT4ExEiH+NvjeRrIXTtlU8SeE07KZRccFH/oelF+YcjfF1wHJIholLdr
	 J9PtE86RejDg7B85AQ3mdy3ihBX+Buh3uEtGjthJit3gT4ae2dnd4bCE2HWYs+DnBcdc3
	 vyxl+9xJRqB9ShPxFE2EBBHcC48ml/GjTx5JeOqdn10Ail/5rCzIGIq8g6TpT+oMs3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8NHQXlwfOC4cGNy0eK7D6fiKG0GA/hEI2nqpZ2RI9vc=;
	b=dhQgACLJfmphJL1AFrwq2qPoWJ5NPpurfIvqaH1Du97qe+3R9ITHn1EbQcnSjkiX/UGV
	 Dt+OUlZzFYND7dtDCVBjFgCylD9oEzH7zlIbYD7Qs6VB8JDjgdg48wcxvX49LDhDzuJIr
	 ZHv7nQoWSWQkxAkMHjmpA3GvljHVGexoT4f1jyTvIrLKjyBS+LJS2HH2OgD7mDg3twcnt
	 vy6P0KZK/u2/9wUt/L7egLA5gekLW9UvxdSTkjkU0hWgr/pBJhlyCtFwKFb9o2Lnulqh3
	 6kjAJzlomtwaciph0Ieb5/9wXVMbGO5gUDVglYOaz3wvYuhYbcIxKxv0/EsTwbhrEJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlfvZIx0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B3D606A32D;
	Sat,  7 Nov 2026 14:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlfvZIx0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DE11F0089F;
	Sat,  7 Nov 2026 14:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062644;
	bh=8NHQXlwfOC4cGNy0eK7D6fiKG0GA/hEI2nqpZ2RI9vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlfvZIx0+0wWMUoG7CuQg04/bgbumdBrwdbkCiqLorP13W668uFqbzADVU2uBhmTm
	 H/w39jPKgiZ200TXhj2a/gJ8E78OmH6EWqfxnjck5W1vKEv673vbXJk/xpZPX9n1ww
	 +drKk15eNWPVz9z1L0p2/RnU00tFN0CVesSD/eXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1511/1536] nvmet-fc: Tear down the association when the admin queue allocation fails
Date: Sat,  7 Nov 2026 08:58:47 -0500
Message-ID: <20261107135040.302986163@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 11db8ab55e1a7533e9cfe57687ab142ba67d3c84 ]

When the initial admin queue allocation fails after a new association
was created, nvmet_fc_ls_create_association() only drops the
association reference, which frees the association.  By then the
association is already on the target port's assoc_list, though, and
removal from that list only happens in nvmet_fc_delete_target_assoc(),
which this error path never calls.  The freed association stays on the
list, where later lookups and the port teardown can access it, and the
target port reference taken at allocation time leaks.

A remote host can trigger this reliably with a Create Association LS
requesting a queue too large to allocate.

Schedule the regular association teardown instead of dropping the
reference directly.  The teardown removes the association from the
list and releases the target port reference before the final reference
drop frees it.

Fixes: 0cab4404874f ("nvme-fc: fix a missing queue put in nvmet_fc_ls_create_association")
Cc: stable@vger.kernel.org
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 90948e09b5d2a..f20338e7b669e 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1685,7 +1685,7 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
 			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
-				nvmet_fc_tgt_a_put(iod->assoc);
+				nvmet_fc_schedule_delete_assoc(iod->assoc);
 			}
 		}
 	}
-- 
2.53.0



