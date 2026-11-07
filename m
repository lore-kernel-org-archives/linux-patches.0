Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065585;
	b=ZchMCKky+q5OrQZmVPYWdjH8cBjJcJv82tKL8KsLBfpNPORtYzPzgMm9GvFTx/aigv4R
	 T0oxDqxEV1lJm6gfcGbPMBQVbXCXfht1VqJiiC1HhUgz62fmq902P4ayrXRl8/dWOk3fT
	 EZFbMI8MT8bwCCmpbSxa1wtzqnm/SFsKJTr3YRCAjlTE/WGCGjGb1gA/Yz8Tu4ytY2CpT
	 H4Rvutyyu4433+gBkMrqJeSe8UcVhVIC/g/6GDVIRrmrfd6l1uGA6bqdEskqVWozwoKb/
	 2vaSbb76j++wXpJL/X9hPQmjxTWQ0G4Ct1TUCtAUzMAxm+bOtQU6CVUbVHRDpBxjfVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9QxaXnfKiKn025/pCZocNA0U0gcaJrxzydspq4Wl3HQ=;
	b=mqzfma9RFD5J22j4ZFgeSKE4Q/8BvEOfHmF83a7wykCk/HNu9rV6rBfu3ig8JU5szIbF
	 JBWLPN4wGzYDK+0NHacJ2rNft5meeWheNgTRDuRIpAm1dtCUc3k5jI9PTwY76oQDWgoqq
	 qHkg3wNOuOdYOWj6L2mHCxCR3NKZw0NmjAVlK0JHdiVsgTspjACVZV4s4d46HIl7RAVQy
	 rSBY5HW+CIL2wvYLDkOzzuMgSW02zwq8gWAKSZFniXHe7IdQzj0RNZ8roObB5HD1lh6Pc
	 xKwSYYW1aPmkGVo2sRAjaj92ol5yK8oELB/p7Yz7oTqVwhhG+Alno3kr9ND0vV3Ea2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQg2uYKb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20433606A32C;
	Sat,  7 Nov 2026 15:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQg2uYKb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA591F0089F;
	Sat,  7 Nov 2026 15:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065585;
	bh=9QxaXnfKiKn025/pCZocNA0U0gcaJrxzydspq4Wl3HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQg2uYKbCPpFk3kYYJnRJMxosDpDrczbM+KYty7OMOkGuRrcNy/GWYCKULAjB9L8D
	 jNp5+enAgacBAbYdfq8HW7oTgdzkqJznpdWifjAUNldMYkB2AEI5n0BTzejn+r017Q
	 nIoqVG/rCGxBpHsrCMAFPz2x1ybcxUPnFF48JkqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1207/1257] nvmet-fc: Tear down the association when the admin queue allocation fails
Date: Sat,  7 Nov 2026 08:58:23 -0500
Message-ID: <20261107135012.680386355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c45a98cc094bb..9b46e16641ed4 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1705,7 +1705,7 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
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



