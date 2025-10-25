Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371D63054EE;
	Sat, 25 Oct 2025 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409409; cv=none; b=qZwYc/4HI5wBKzXS8rvx4BYGSaCLUVM1+TmYb10IKUxmKx0JBa4R1Q9gydPpVZiML3Q+8NaG5kfrLKWjoA2+2ADzisHveLYv5YUJGFR49OJS5AjphZpeB/QeaPTqk520o7gUYJ8UjL2JzDaByHuc2gKMKEeYAT8F6sOcLW5ZBIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409409; c=relaxed/simple;
	bh=8sd6ZvIbwHXgWSyrfjIj/d9CwFax6FAnVASmaZQIAUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iY4jL/S6gOehxf1PDqj8veP2+1aMw36+21rQAb+z+ayx/MtKGG8ozXPAyQIBQ1z8B6HsQoKiXffohU6+jVpNVeRJtxpENKixGcuPhcGqb5c8nuviBbl9Rg+Kv+ldvzr5hMRhT/FQQijXsXwM4Pbad1ORg/bxZSmTa5d5SV38cbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=un/cnnqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="un/cnnqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF92C4CEFF;
	Sat, 25 Oct 2025 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409409;
	bh=8sd6ZvIbwHXgWSyrfjIj/d9CwFax6FAnVASmaZQIAUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un/cnnqn31uNImb968fU4L1aj+VDxeyXVQXOcs/XbgqXS1KZ3l3ZCAKboV+A9ojW5
	 QXakWuN9mZjClnFSqVnkiZoTpmfTOLoJ2ABpEh2bOr1e8VC5loxHP6F3mYgeZ6vISs
	 LcGNO0kXMiG8oc6m6sDs7pSQkDkHtk/OkxL1jBZkcxWDloYJh/tW6dAtgy47CprqFL
	 faTo/o73dXL2EcSEWwizHvPtj2QN/DJEXXieaIAqWWbgSMIENOXhu5Ofrzl9WFXPt4
	 3x2qadZ4l84qFmdtxheUmRWBii/uzza9uqjQ+rP6wyGQBcqBpYHqfqnnBWO5G2J05T
	 LVO8EjEDwaISw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jonathan.lemon@gmail.com,
	richardcochran@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] ptp_ocp: make ptp_ocp driver compatible with PTP_EXTTS_REQUEST2
Date: Sat, 25 Oct 2025 11:59:01 -0400
Message-ID: <20251025160905.3857885-310-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

[ Upstream commit d3ca2ef0c915d219e0d958e0bdcc4be6c02c210b ]

Originally ptp_ocp driver was not strictly checking flags for external
timestamper and was always activating rising edge timestamping as it's
the only supported mode. Recent changes to ptp made it incompatible with
PTP_EXTTS_REQUEST2 ioctl. Adjust ptp_clock_info to provide supported
mode and be compatible with new infra.

While at here remove explicit check of periodic output flags from the
driver and provide supported flags for ptp core to check.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250918131146.651468-1-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `drivers/ptp/ptp_ocp.c:1488` now sets `.supported_extts_flags =
  PTP_STRICT_FLAGS | PTP_RISING_EDGE`, which lets the core treat the
  driver as “strict”. Without this, PTP_EXTTS_REQUEST2 always injects
  the `PTP_STRICT_FLAGS` bit, so the core rejects every extts enable
  with `-EOPNOTSUPP` (see the check in
  `drivers/ptp/ptp_chardev.c:230-241`). That regression breaks external
  timestamping as soon as user space starts using the new ioctl.
- The same block advertises `.supported_perout_flags =
  PTP_PEROUT_DUTY_CYCLE | PTP_PEROUT_PHASE`
  (`drivers/ptp/ptp_ocp.c:1489`). When the v2 per-out ioctl validates
  flags against this mask (`drivers/ptp/ptp_chardev.c:247-304`), the old
  behavior of honoring duty-cycle and phase requests is preserved;
  without it every flagged request is refused.
- The redundant in-driver mask test just above
  `ptp_ocp_signal_from_perout()` was dropped
  (`drivers/ptp/ptp_ocp.c:2095-2120`), because the core now rejects
  unsupported bits before the driver runs. Functionality stays the same,
  but it avoids double-checks and is required so valid requests survive
  the new core gatekeepers.
- The patch is small, self-contained to the PTP OCP driver, and only
  supplies capability metadata to match behavior the hardware already
  implements (rising-edge extts, duty-cycle/phase per-out). No timing
  logic or register programming changed, so regression risk is very low.
- Failing to pick this up leaves the device unusable with the new ioctls
  introduced this cycle, which is a clear user-visible regression.

 drivers/ptp/ptp_ocp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 4e1286ce05c9a..794ec6e71990c 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1485,6 +1485,8 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.pps		= true,
 	.n_ext_ts	= 6,
 	.n_per_out	= 5,
+	.supported_extts_flags = PTP_STRICT_FLAGS | PTP_RISING_EDGE,
+	.supported_perout_flags = PTP_PEROUT_DUTY_CYCLE | PTP_PEROUT_PHASE,
 };
 
 static void
@@ -2095,10 +2097,6 @@ ptp_ocp_signal_from_perout(struct ptp_ocp *bp, int gen,
 {
 	struct ptp_ocp_signal s = { };
 
-	if (req->flags & ~(PTP_PEROUT_DUTY_CYCLE |
-			   PTP_PEROUT_PHASE))
-		return -EOPNOTSUPP;
-
 	s.polarity = bp->signal[gen].polarity;
 	s.period = ktime_set(req->period.sec, req->period.nsec);
 	if (!s.period)
-- 
2.51.0

