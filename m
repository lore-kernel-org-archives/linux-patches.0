Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045884;
	b=bfxc6tKSrxBs7nrR7mG3DcJaTGsH7zVAEBoUKU+wGm1uUiXxjiIrZpNecc1w3gl6Na+a
	 V5Riw0z3J4rpHMqUKmuedOc+fsmia8XQ2CKlZ8jRh22+gK1vPJxrQnocD401thWLAW458
	 NYEhxhytoDdkqT3UUVHv/EVvd4RKQDrTItdVf50DfS49d4OWa31KFJur+RB+XPqFVgFgq
	 i2p4BcRWbJP7B6SmjdBLUwJzzwnx7NJF8QmMtimMHfaWxQMtgAPUzz85WNr+PYw3jh3pl
	 xo74wVSZY6OAjWD0itB9EHVSfW2+FwN9j3xsB/amPcWuZQTr5U+ioSTgF9aDFghweJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OPafjy4iLuOJURUmkVyg/cCoSufuaiFQ+/9T6fnE9ss=;
	b=y9pybEeLDzsXE94k1cuhizOBMHTn13bkvfC8MCoCgnr9iKzhrlqZlQh5FjRJf9fy6Vig
	 d+JoXhvEbqtfUSS5WH2Qsre1g6VRmNEJo7TeLwh6CR49XKXJqn6goJLBqolHKh6dxttsX
	 VJM427KApwPLR1iNy4GB2s2I8RDmJmuhO80oBdSDr4RBJh3DEHHPrWU1lM5foAtmFxFDU
	 7UQXtDPvCloelx9M3D9J+pskxkoNhZC0TltmRYzglEWI370hkzL8RGSmL75CYh69/rjGu
	 sv7R9+W0nMlN8MkT8eV3I4AoAc/3kn3NUcv/+VefgyweOp1azyOkGnxEYCrv3Ay108Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yE0lcTHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD83360A2620;
	Wed, 18 Nov 2026 23:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yE0lcTHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA351F000C4;
	Wed, 18 Nov 2026 23:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045884;
	bh=OPafjy4iLuOJURUmkVyg/cCoSufuaiFQ+/9T6fnE9ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yE0lcTHKJgEby7hfXwRG2ATMxq83nSsFKdg2FyVFhjdZ9pe7y1GX+CrnlszQGmxpL
	 YJefjEPmJkQHZ1rr9lJJAe4Fy23klXRy3iVJ7Ith2hZKszEb26Fog3uXjjt/c6qr8W
	 J0rtmv49u8JrkDRbIPtPFK6sPE1QE/rTurHJlMy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1084/2857] nvmet-fc: Tear down the association when the admin queue allocation fails
Date: Wed, 18 Nov 2026 15:35:18 +0100
Message-ID: <20261118150240.651586655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 217637d2f8ae8..224287ca9039c 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1681,7 +1681,7 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
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



