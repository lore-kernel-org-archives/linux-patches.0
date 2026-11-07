Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063738;
	b=AvbmXhdUqntUGzj844AOiEma4o+g/JVQFEakj83cOU/3BC5ZWedw78hsz9Sdwi49Yp5p
	 T0YzvW5aEbZsqt6WWFd9911BZARtIaqRcVgWLM+veAJlyx+ayXPdSBn5BphLPk8k4tS7W
	 Qk7duZPqBgVjde2TepahtFJabDMjCfTb/FVfFWc36SZjqGUW+VvTspoyA0H64i4Fgk11l
	 CN0fV6uQ+zRXWYh7YyVL1VQRDyF7qdU0nMn3BMOcfjk/8YOc/LSYycXVavkV1PY4dyKWe
	 NBa8UWgb9SIJbjtM4RrzLKnWexvFiAPMIyaK0TKJXQt9kOE/KIXYhLuP6lkeEEsH6Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzrt1DdHYBJA9Uz6xIxAn8F+L3KndsCjOl+YKY7mA9k=;
	b=3EJjTsqdODkGi+B9heb7bd62QYjcbEd7JiVEAftUAW6Sht9WHRVTXmnvcgVQzl1+IRZf
	 uvL1Dd8Yn0u5lKUZ3W66FLGSSWIIV9vCzySXhXDRI3FMZFsuveuUk4URXY7m+yCxN6cPJ
	 9AkDe/3FBIZvflNBvaKtoXwlZ3XJSN1onbUnXWqyo7ZJgnBFdtS9ppM/6eJU6xMA5xJhw
	 Ml2RYZfWl+nFD0xFGpbsIx61RAye8j2CD1PLlZW8eIK++G22VTgQUcA06hADvcN2OXIq7
	 tAUj0h71fHJqg1RT2NQNb6v243cUuxsBWcFUNIT9gok+vb0oGlVGKyQeJCu04SLyQUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q/4FblIb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0662B606A32D;
	Sat,  7 Nov 2026 15:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q/4FblIb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DFD1F0089F;
	Sat,  7 Nov 2026 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063737;
	bh=dzrt1DdHYBJA9Uz6xIxAn8F+L3KndsCjOl+YKY7mA9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/4FblIbxOJpr2VyqRIdShnzVsiemPppIFpqslBttu2vZKOE05bWKs6TVRcGIGvIP
	 c2g6pktMPulXJjXQfNtGCsDlW8qUo85xfeymdjefafzXoKk21BphW++hdEz+drOIi9
	 q+Fk6nwHyMbWqgFXgCG2XvEl3H+1ekAGmxIBKF/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 833/869] nvmet-fc: Tear down the association when the admin queue allocation fails
Date: Sat,  7 Nov 2026 08:58:35 -0500
Message-ID: <20261107134921.155972536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index ec08992668b99..89edffeb10626 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1710,7 +1710,7 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
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



