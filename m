Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027207;
	b=HOhUhtXTjAojSFgws0oSjgH1hwSdtnN6J2fdSKITqzxMDLvpTHGZHM0jGmWRPEf0Sl3/
	 XKpUcy6bWaT5ereRXoJCZ0KQG1mP0w6DYF2heSNAjJREXfIAoHLIRADpkUVagRCAIp6l0
	 NFSiMv08Bd0cPmPoAQKh4Mb5aGXaAQfyKaVhOzCKrhg7/PBg0GJfLMkdRTk/JWIvNDOxd
	 +PQvQ8rQpdwAOaFzB6qnz8/kq3uCgjP4I84JlYcaFFYno4ib3LGUrC3++ONJ09H0+nd8L
	 eXfmvmBpGlHNQhK2As+H0FnnjomM9vUE6IHOQTrGeSFYOGIJp43imL7KAOHXgVfYmjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FUHf3eoKh+8NQgyMNxG2B0doIZQ0f9DjL5X69KY62lE=;
	b=iYUBWJanZ7UoT7tCk62mSWl1h7ow964beR8YQiZ9GvXm3lUjETn4UAdoIgdsJW9gPNg0
	 XXYUD2ZjUfW6yY9Yap7iIReR0wEuVwN3o9CiqO5HyBzhueY2/8QHpmzEC3ltRa90xECVO
	 85AsPJk69wxIQP0Z3/FhQZcGKQnkrDYGeMLv9viPIiyYdm8Ofbj6q0TRjjtVFRX4qzU54
	 2lAIKKKIm6uHL8/AxlnuovMYfHfbUjyrvbN6GZUJWY+alMv2zNm1JZDDdiKe90VEjTFwf
	 MxaQfJhGeNZ0KjkJ6VasxhQgqyJL86HgBr+IJpZYUU5UsIsx9Ch2L+aPcY2W93+nA7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KrDotC5k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878C606A31C;
	Wed, 18 Nov 2026 18:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KrDotC5k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00811F000C4;
	Wed, 18 Nov 2026 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027207;
	bh=FUHf3eoKh+8NQgyMNxG2B0doIZQ0f9DjL5X69KY62lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrDotC5kdIj3dxdScyBFCXy2lRnbBJGx4NR7UxwjWSvaZyRwNlF6aTFLFiDS1FOqA
	 SgtEWbqTUkvRKWSSHKHmQ4yxqZniz/RSVOjcuossoOLZX4uG8DpELT34WfVC+2WIuM
	 2goFWgGUnxVaZRSpM5fepe4V+W6akLLJ+ZBif2Ck=
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
Subject: [PATCH 6.18 1708/2151] net: enetc: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 15:57:23 +0100
Message-ID: <20261118150224.039451594@linuxfoundation.org>
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

[ Upstream commit 8e96c4d393168661704d850bcf818e46efb8ef24 ]

Commit 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to
ptp_clock_info") moved the validation of the external timestamp request
flags into the PTP core. A driver that does not set
.supported_extts_flags still accepts the legacy PTP_EXTTS_REQUEST ioctl,
but every PTP_EXTTS_REQUEST2 request is rejected with -EOPNOTSUPP.

The ENETC timer is the QorIQ 1588 timer, set up by ptp_qoriq_init(), which
programs TMR_CTRL with ETEP1 and ETEP2 cleared, so it timestamps the
rising edge of its external trigger inputs. Declare that, with
PTP_STRICT_FLAGS, so that a falling edge request is rejected instead of
being timestamped on the rising edge.

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
Link: https://patch.msgid.link/20261009-for-upstream-qoriq-ptp-extts-flags-v2-2-0f4eeff2295d@free.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
index b8413d3b4f16e..219c8bc5b7f16 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -16,6 +16,7 @@ static struct ptp_clock_info enetc_ptp_caps = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 1,
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine	= ptp_qoriq_adjfine,
 	.adjtime	= ptp_qoriq_adjtime,
 	.gettime64	= ptp_qoriq_gettime,
-- 
2.53.0



