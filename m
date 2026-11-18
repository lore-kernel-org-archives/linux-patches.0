Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045747;
	b=KCwaRA318nPjTTrzlj+vwstlBvy3fgmkCGFUCnEN95Ta98oHTjnsLmgVTGwagqVEfokE
	 0Y56P7/WML6KQQo+bYl2YSpev6Uw+6sm4ZmikqQQNcJxCKhiGGPCkrrbr91ABnuGYXk4s
	 A4S9q5Rf+5e0oGXq9tC17sNR0wWmJgg0YyuG8Riztob9hJj9Ak9OgPBZYKLYrChydwSfe
	 LFvIDpn5cmfR5SuEl/2TeVbe5WykK8bBFlJ86QdnHvuGgRQQz6B0Pfnn9Lm5XGuzhGFta
	 FXXDmlw4naD69fekRQiTr5m4pfzy4by65Mz2mtArN0ed5WAMIgnt4d6ABF+/arpWPEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+F9lrB5UelDObGy+dlsen5MB2HVuqp2QbFJy1Bc7udI=;
	b=OPxRJVxO8bYrSKiYeAYe5OBGFpSEtzRQ9mfh5r5YeajWSQf2PRcyDJqUGUC88Sr5VBWa
	 sZb6+FNUXO47itGO3Gg3hCOdaIyWegr4+8oevm6o6D4LFp0luH+18zvbC7o7FNN3EsvYQ
	 /oSNLlihomi0CfoLB6m5rcOZM7xFuiCDDH9R+lXl4w2dfbl3r+z9OLxYw0AAY2sRThZc7
	 EGaLhyQ/kJJd4qjffwr7PJkDGmPtOaw8issRxEkgN2TaGPHbUEdFs52bcZdqp7fXLeTul
	 N03PvbczyDGvDqkye9Rx3/Ny81fDWlatYpZ+yQlxO+WsogDZoyaV4TMXQ/xy73CVkKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVXFZ2Qo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28637606A31C;
	Wed, 18 Nov 2026 23:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVXFZ2Qo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F62F1F000C4;
	Wed, 18 Nov 2026 23:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045747;
	bh=+F9lrB5UelDObGy+dlsen5MB2HVuqp2QbFJy1Bc7udI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVXFZ2Qoh2KGuElGUdJqiFdVyjGSZWAmZZJxhXrRaq6x+BqxF5XiDeaox1ZBSUesa
	 vAkvI6s4oorF4m5BhMs3RbfDk79CQ71S6NmCMkvYDrxBFOpvH1b79l/zWaAo2ZAJgg
	 Btb66Z1u6d+2EclLgOgeP6oBDLFOB2W38OxKlVdM=
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
Subject: [PATCH 6.1 0993/2857] netdevsim: reject cls_bpf programs bound to another device
Date: Wed, 18 Nov 2026 15:33:47 +0100
Message-ID: <20261118150237.357005493@linuxfoundation.org>
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
index 7064a3397be23..a416266ac1174 100644
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



