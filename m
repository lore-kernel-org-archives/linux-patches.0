Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027202;
	b=XfYEdPyWPeqcsc3F6Bfss+3mTOyb/jXABG3PdovsNcQNgFZj307sd4K9sTWO0MM4aziF
	 NISOpp4lwk7KCOEEpi7t8fsgHunbK+fFo1lg/UflaTeJ7KyLdWYZQIzCFhEo0FXADFOKZ
	 ZX7FLfTYxzim37so2UASTHbR6hWoFzUI+PTPZXi4VKnIgLEFnNsigOt016ptwNFutdPGa
	 UMnzzUD6sMBdoSwZbxwqlGc6KqkLPakzTzqzo1SqBbckyuyxBp91WQ0HQovFJDXPb0sPM
	 mHCxjHgy/QaoRCYKbB/Ol9fqshc9ROxwxSk7+4l9wI7EwtgXbFItkVFl9kpZ+/Cv45A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwPEb48Ldv5fejljZxCMpqrZd3VTp+YLXXb0pm0IY3k=;
	b=fvx+xirKBN+0Pf8xJ0tQVmehUSrBoPmZIkfgFW++MOXb19IPLI0H8KQmEiW+nHI2RYQt
	 EXqXCiqmOkQmTdrVbdWLpMTjwDQ+7bQRmwGHxeM48sobV02XJJAKNsTD0ea0/tUUlROdg
	 wuTWqz2FZ95V9qvJodJiMJGm63seQpcCC+NypHD+sF9SITxR9O1Rf/KtM89ei0QsquxgZ
	 uE/1OBPNd9UH7/0qSAHkO066HE6jlUVDUiglIh6f6UdJ1anYm2XgaqR9vE7YKxWeREeDi
	 QXIzDv8vK10gNpbW8CvDxZ1oUG9hdIX21Q20g3OQG0Q6MuT8fSBhocxfHgKplP+rV8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvLmrLd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0519606A31C;
	Wed, 18 Nov 2026 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvLmrLd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BC11F000C6;
	Wed, 18 Nov 2026 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027201;
	bh=AwPEb48Ldv5fejljZxCMpqrZd3VTp+YLXXb0pm0IY3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvLmrLd5PBYoujgGbi6IE8eRCVehC0G0MxN358mSLe5KMCEvmFFy3CPhLPD2KdeXr
	 7tHnI5O2lg2rBKDXZdgRbt0cUsMopunpOzbou+QGGsRMCmq52bOA1SCZGuh4ESA4AI
	 rk0idBUqV/KJEjRwOBuDlEKr9UNecxBYXjk/pgYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vincent Jardin <vjardin@free.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1707/2151] dpaa2-ptp: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 15:57:22 +0100
Message-ID: <20261118150224.003295238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit 86a30c4348497bcddcf2796258955bbaaf58c9a3 ]

Commit 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to
ptp_clock_info") moved the validation of the external timestamp request
flags into the PTP core. A driver that does not set
.supported_extts_flags still accepts the legacy PTP_EXTTS_REQUEST ioctl,
but every PTP_EXTTS_REQUEST2 request is rejected with -EOPNOTSUPP.

On an LX2160A board, linuxptp ts2phc arms the external timestamp channel
of the 1588 timer with PTP_EXTTS_REQUEST2, gets -EOPNOTSUPP and exits,
so the PHC cannot be disciplined from an external 1PPS.

ptp_qoriq_init() programs TMR_CTRL with ETEP1 and ETEP2 cleared, so the
timer timestamps the rising edge of its external trigger inputs. Declare
that, with PTP_STRICT_FLAGS, so that a falling edge request is rejected
instead of being timestamped on the rising edge.

This also makes the legacy PTP_EXTTS_REQUEST ioctl strict: a request for
the falling edge, or for both edges, now fails with -EOPNOTSUPP instead
of being timestamped on the rising edge. That cannot be avoided: the core
adds PTP_STRICT_FLAGS to every PTP_EXTTS_REQUEST2 request, so a driver
has to declare it to accept them, and once declared it applies to both
ioctls. Commit 3200fdd4021d ("broadcom: fix support for
PTP_EXTTS_REQUEST2 ioctl") made the same change for bcm-phy-ptp.

Fixes: 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to ptp_clock_info")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Link: https://patch.msgid.link/20261009-for-upstream-qoriq-ptp-extts-flags-v2-1-0f4eeff2295d@free.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index 4497e3c0456d1..ac2b873dcf8e6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -78,6 +78,7 @@ static const struct ptp_clock_info dpaa2_ptp_caps = {
 	.n_per_out	= 3,
 	.n_pins		= 0,
 	.pps		= 1,
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine	= ptp_qoriq_adjfine,
 	.adjtime	= ptp_qoriq_adjtime,
 	.gettime64	= ptp_qoriq_gettime,
-- 
2.53.0



