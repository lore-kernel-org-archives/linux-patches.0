Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063514;
	b=enYNqyieCDoEmgi1sbHU+MEZIEP3D4+zNHOFBr2G90tIzJxZJpBpzW9HUZrx0XT48cfI
	 9tVhvLV2x6HZ0hlD7qA9+rdwXKPh4TnpUstDfeWINI9JYs4TOjysN+DB5PWCUTuaJ9ChR
	 lYiaWITh67zSKbsycCY6YkKxqLrgP60EMYDkX324ElFS/EvdW4G0tDdXx/7AOTRXlxueS
	 /fM5G4RGhBRnchmGsBG8WG9DUBpaX53xUoG1j9C7FxGfmO+aFYoypkMUp9OiKDJL/C4sm
	 OC5OUXFMmgaQXiQF4Cwx00c48k3gluNYL9G2dUjzrVtcESX9A0q+Lbvhtc0g1a+ypOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f2i6gcwO5rqlD4U/5ptAnjntY+qMkXNmzM/lAsqdJVA=;
	b=29DwOKBMUHPqXBLlgQuYGA5uxzdZTW8zTIpYtEFIcUTFVdsqSS7LormSZYdQ+7llXCVq
	 cAJYdWzxcxpzQonUXYnoyVljSZaOZ4CxBaT1WGdW0fgW44YGGdsFm+fHCDK/wrExvzu1r
	 mWAMxkPKulsW+Nc32g158gXQQtIA5WFYnvx2LHLBiAx8mSN++DisteU4oeDdeYb5linJH
	 QufkUUT8PP5szAkOq+K4L8vAL9gGLOL43rqRSuxu8nohV8jfS/6CGzSFq7KiU0dsbDlX6
	 3aTtTUD1W+h6ZMPEQrtFVa8vjJHecNIaqSIhsypRL7CU38+iGe8L2qv94hY/4zufIbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGEIIGUL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E57606B8AF;
	Sat,  7 Nov 2026 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGEIIGUL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F571F008A2;
	Sat,  7 Nov 2026 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063514;
	bh=f2i6gcwO5rqlD4U/5ptAnjntY+qMkXNmzM/lAsqdJVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGEIIGULj96xLuX41W1wQCIkU1TPBzdv+MTu/dd//nRUvOyIWfd0jpvOvYOhubBkq
	 okmhYPLr70us87cYUAFw++uB1wHUtyb1w7L/++7q8IP9Zirk6FuhDdRyMj4dE5gpbI
	 CMqpxs7rLiVe53Mg8k18MvWG+LeFVOdP4znFeijY=
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
Subject: [PATCH 6.18 657/869] netdevsim: reject cls_bpf programs bound to another device
Date: Sat,  7 Nov 2026 08:55:39 -0500
Message-ID: <20261107134915.361888754@linuxfoundation.org>
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
index 5f17f68f3c083..319f75e42f7c3 100644
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



