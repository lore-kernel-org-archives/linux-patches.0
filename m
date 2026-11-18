Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027210;
	b=n/uWsgSGY3zaXyx7VTacUGQc2VcqfFXMmLt4ydQDtaHZJdXMZEMGDpKypmkdAzsJfwiA
	 rKfKTZETxOeldyjn3KNR+eZnxwOgWhdOm/yiyzr569/cqA5yRo/bvfgoFQh8sIAsK0O1P
	 FnL5pZkAJ2KSq/UHm9qwYdoC7B0AO3Rdc+Cg3t2W61djKNQJeJD5EAej4GJWSr4ZzQsCr
	 dY3aVq2FWHZiw7vNfyP0ddH3qM5W9ofNzf+AZWJ3iO7NBSZ4NMo+175MCP01+Nfr6G3dG
	 lcjsLSfoh1+yyU+49L6kYfVe/LRFyAo3i6p8Sr0pPbHTeSDkEGIw+G9wzy80UGJmyYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2bRUuJC/l/3KWxMdOCPm/u+Gq4Mf4IIUlXWY7eDmzy0=;
	b=uxiuY0vZjwAXQKUM8TbqVbx9RWpvdDCxdLI2tdF5e+rKFiQ7MNKW/+j8a+uRKUyMC46q
	 uieAvTMEljmUkLC+5ewIOCTR35Fwxxau3o4R/dUPp3kMz4lBzczs6a7eTw5w9haQ6RYYu
	 8AdcVId0AqBDImovvL4JhhBFrux3oO+Cf2Qljc2ijankiE6gBV82ic3OpvmD2y1WXLx5Y
	 fDEEPuYaVagvHvNm0i2XIsH3+Z55SXIlwiWBVXvU3M+qbeRJvWmZBpSj/S6WKnLFIcTqZ
	 bGFY6TAcVLcAM4zkoZHNe5+ZFaTMKQU/OHqBXi5ih6hBCeD44UdSzcyickdpyhSlE5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVyMB3Zr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E3606A320;
	Wed, 18 Nov 2026 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVyMB3Zr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BCC1F000C4;
	Wed, 18 Nov 2026 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027210;
	bh=2bRUuJC/l/3KWxMdOCPm/u+Gq4Mf4IIUlXWY7eDmzy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVyMB3Zrd4JMFC8UU0wwJ85TcscbmEyuK8J3PzYHihPk1AYt+xjs5O5wxF+FtGq7q
	 JlTE+yhL6FZF2Gmw9GceXnR9prrYCThTX1j6E42BIzNHt2dfvrPYa3XYygn5Jcy35y
	 8sL1Y1Ha9RHvuvg4NYo9pwbXEUqNjbTq2xNqW9oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vincent Jardin <vjardin@free.fr>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1709/2151] ptp: qoriq: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 15:57:24 +0100
Message-ID: <20261118150224.076988397@linuxfoundation.org>
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

[ Upstream commit d347ab5cf809365e7b3749dc91d77e89e4b7ec3f ]

Commit 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to
ptp_clock_info") moved the validation of the external timestamp request
flags into the PTP core. A driver that does not set
.supported_extts_flags still accepts the legacy PTP_EXTTS_REQUEST ioctl,
but every PTP_EXTTS_REQUEST2 request is rejected with -EOPNOTSUPP, since
the core always adds PTP_STRICT_FLAGS to it.

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
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20261009-for-upstream-qoriq-ptp-extts-flags-v2-3-0f4eeff2295d@free.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_qoriq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 8da995e36aebf..f817a1c972892 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -355,6 +355,7 @@ static const struct ptp_clock_info ptp_qoriq_caps = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 1,
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine	= ptp_qoriq_adjfine,
 	.adjtime	= ptp_qoriq_adjtime,
 	.gettime64	= ptp_qoriq_gettime,
-- 
2.53.0



