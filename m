Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062508;
	b=s9ZZ6BxNDZpBxR8LeWLGjub7PY36TD4smz+SjRzNazn/ToMe28EkLSb+TlutwZ9OuHJa
	 HHho7G3DPOuSx9ZZu3xjZZuEXcv+aL6Tw5hZNddKG9qv7AiLHxyBaFW/LzeLAQKlIqrOK
	 1dKGfDRyjZT5HETaxMBW4SBxvrdpVe1Ij+zrT31O+jTLypbOr7ho+TQHy0te1Hp2QAJ+F
	 RnoYv4v9WzY5LQn9+HChcZv1U1arWDnPO3J8yjLuHgusSNeIPD3UPZDHQbIR0HsgJSAbB
	 i7bRxBdhvyHQ41Q0UebRFRHcMAlM6lLwB2E7Q5muk8m+9HhjJf7okVmv9EaSREfL5mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=acyk3dfD0YDzSpPl9bmnVL/WPJJr13cS//t46AoYTyA=;
	b=n0A98hcCdZZtqeFXsmhefDD36C4XWG9zxzk7MWK/saI0KnMHe5+5iIvyc6jIdniC3VkC
	 47lct5Ipp2oJnWWpCJd8iXlU8EvJKnECzq3YS1Ew4wW4z2+rf6EYjJq+u38Yhw9qAnDKA
	 eJeCIbHgccBN7GAALak0f8W0BrB6QNwyd6dSD5ZsZgMu2B8LSWRnEVy4x0XIKj77Nj+LB
	 W9SM1iDHDDaTaNu/B+2zHy5vf1Q2TjaKngPqT0vjxr3GDN4dHJrvhEXzbme/QCwIQ/lrW
	 mmbiOUeFqVN2eU0pHfBvXOTkuqUnDNblPOShk1iMLthWSTYNvLvqAPqPvhbhBHBG+cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J2+fo/D9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917B8606A330;
	Sat,  7 Nov 2026 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J2+fo/D9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D411F0089F;
	Sat,  7 Nov 2026 14:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062508;
	bh=acyk3dfD0YDzSpPl9bmnVL/WPJJr13cS//t46AoYTyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2+fo/D9SKM/cTxzA4wou0vE6F26js9CIy6PuWG9v16HLGFOIKubtXUijKRuxY8Fa
	 Bj+c55n3LHjSRkzCzNkxLgj0LNrYkcUn3PXgFSoQq8p72SGem5Ti3ZB9k++0D/CHzI
	 OPjaSlGMO7wXB9UMdS3wF4pv3Cl3CcDg1B7dQG5M=
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
Subject: [PATCH 6.12 1367/1536] netdevsim: reject cls_bpf programs bound to another device
Date: Sat,  7 Nov 2026 08:56:23 -0500
Message-ID: <20261107135036.235602889@linuxfoundation.org>
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
index ca64136372fca..ba4a0ce5864fd 100644
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



