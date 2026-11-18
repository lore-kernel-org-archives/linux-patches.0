Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052744;
	b=1m4sLs5cCnXCEF1caiZBz0txIEvMhNYk0OEn4U888EB1ceukfkRF46qBdSzzGk3sfrkU
	 XqJc6c42asrCgdy4R/LFKC7LRWkXJEEAs0OQyn/lzynQ+X1zyBp7uqCewYUzjozx9Yo7Q
	 KzP2056imh5Vhke6ImJaLq2J4T6DboH6LtW4+VgAh1lDJ9lJ+LKkfOBXFJqpv2CtDsqk1
	 NghObZpI1dpNlCsoNKKF9t8JUQehSD4dO8h11s+TmWN2Z21bHl6wdteI+XsVXTcOhdZfI
	 XHsa+w2VUYpTM6ZsfF3kPk5yNwt7fPZ7xkN8tnAyiiJQeFsBeRqEqxboiDfI/SOmFTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0rjXLiYMKMIuigJiykhhq/s434gnBGU2dm9eBKl5FyU=;
	b=ZIy15pSRzXGC/G08Dn6LXbCi0zZbr4lUHOEtZdKDEzyqlsZM0zUbOS2MLDciBxCJWbok
	 x0i7Go42DwXvXNy0N2Czu8gdzQcp/xCuM083+XAN/QciGmcBzKrjl42ANRqNXk3bHMw/q
	 M1gWn79CviX/bHopoSpg/xEwD6EiHFqQn7cZFy+Tu8orVuihBCEKFSi34eYZWkYPsqDnM
	 FJhTuqhK4L5Fz1koz645oa3VVXw2sCr4WTku8R+W9PkwnGM7t68Dyqoa9SxezOa7tEo41
	 FjgdTTkx574d+PZ4q20CMjS8V/O0va/EyOvsKv32khMNG1rkj5b6kS+iOOPeKyL7sJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tYVbaxaR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AA0606A32A;
	Thu, 19 Nov 2026 01:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tYVbaxaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB151F000C4;
	Thu, 19 Nov 2026 01:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052744;
	bh=0rjXLiYMKMIuigJiykhhq/s434gnBGU2dm9eBKl5FyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYVbaxaRUn0sDHVg3K05P/KgrPlsyhpuLlXJxz1VECMLGbuGoOt0nuaEUXvMnW1B6
	 f2Tzk5jRapuIKIaUOe9Lyyoodrl08Pq0xB85wdwVU3z7TKnJ2wv76QB7ZQfkOVoVQ3
	 5WBXXwiePEwmXxhI9lnlMhLEDdMDIx5OxCtEBNCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0671/2214] netdevsim: reject cls_bpf programs bound to another device
Date: Wed, 18 Nov 2026 15:39:07 +0100
Message-ID: <20261118150038.669124564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 5820ca58b409402505b9e904d1ded4908e0b6b81 ]

The issue:
nsim_bpf_setup_tc_block_cb() installs any device-bound SCHED_CLS program
without checking that its offload device matches the target netdev.  The
core cls_bpf attach path rejects a mismatching program, but a netdev that
joins a shared block later is replayed the stored filter by
cls_bpf_reoffload() before it is inserted into block->ports, so the
attach-time check cannot see it.  The driver callback is the
authoritative per-device acceptance boundary and must enforce the match
itself, as nfp already does in nfp_net_bpf_offload().

Without the check, replaying a device-bound program onto a different
bpf_offload_dev installs it into that device's netdevsim state, which
trips the WARN in nsim_bpf_uninit() (ns->bpf_offloaded set on a foreign
device) and can dereference a NULL prog->aux->offload in
nsim_prog_set_loaded().

The Fix:
Reject a device-bound program whose offload device does not match the
target netdev, with -EINVAL and an extack so the rejected replay is not
silent.  The check is intentionally narrower than nfp's: it fires only
for a dev-bound program, so nsim's bpf_tc_non_bound_accept mode (which
admits an unbound program onto the device) is unaffected.  Teardown is
never blocked: the guard is on the program being installed and an unbind
passes cls_bpf.prog = NULL.

Conditions to recreate the bug:
  - CONFIG_NETDEVSIM=y, CONFIG_NET_CLS_BPF=y
  - load and pin a dev-bound SCHED_CLS program for netdevsim device B
  - install the program on a shared block owned by B
  - add an independently backed netdevsim device C to that block; the
    bind replays the filter to C's callback, and C's
    ports/0/bpf_offloaded_id takes the B-bound program id.

The reported Sashiko review is at
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260809094418.901607-1-jhs@mojatatu.com

Fixes: 31d3ad832948 ("netdevsim: add bpf offload support")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/netdev/20260809094418.901607-1-jhs@mojatatu.com/
Link: https://lore.kernel.org/netdev/QDISC-PYC7.v1.20261003103747@mojatatu.com/
Cc: stable@vger.kernel.org
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-PYC7.v2.20261010165947-2@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bpf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 50854265864d1..879ac48027af3 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -150,6 +150,17 @@ int nsim_bpf_setup_tc_block_cb(enum tc_setup_type type,
 		return -EOPNOTSUPP;
 	}
 
+	/* A dev-bound program can be replayed here when a netdev joins
+	 * a shared block, after the core attach-time check has run;
+	 * enforce the device match as nfp does.
+	 */
+	if (prog && bpf_prog_is_dev_bound(prog->aux) &&
+	    !bpf_offload_dev_match(prog, ns->netdev)) {
+		NSIM_EA(cls_bpf->common.extack,
+			"program bound to a different device");
+		return -EINVAL;
+	}
+
 	if (cls_bpf->command != TC_CLSBPF_OFFLOAD)
 		return -EOPNOTSUPP;
 
-- 
2.53.0



