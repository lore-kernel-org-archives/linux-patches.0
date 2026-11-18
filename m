Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020779;
	b=bj+dMqJ8pgtBqOnP0TWfkCyw7GFhbTJgf59DE1arvkOSwcfP0en2cpIDbWIYCyZu4Cw6
	 lPoIPILjY13AVN69WKomjUSyPBLQyTAIi+XyDMoYTY2Wxe2uONwh+u260yKUPvTD5VdB9
	 I6Wh9gEXIkoXoJXWyvlc1Vrhkyq7Bis34XZ+p0q7qvxPrs58VoE8jYI3jgRg9pMdM0x2o
	 m0rybzEqVvqbGrswKYmzUeUlJdv/QrP/btK+buBgZIYVjguavkRADHqeOr6rBPX4kNQ2r
	 6tueAH+VHzs3dvfNj5Cp9+bT9cAGFKQWfhriJpDOPq/6X0u10Ud6lkViaRSG5DCVBJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5cPkuFbynq+PvRq+xdJb/VuJiV1RdaebezRkgKjGVUU=;
	b=xooYyPZ5a7UjxSkSmvDVUXCLB48i3EtaJJoOnqiXuyB9QWMFcz66sr+e2Q/03PlKBnkP
	 cqCi4rzRmfm5IVKNOqec7inrz8O8kSH/kiAjvAbEG4gYtIqwFeAb1PGi/Nwdckifqt29U
	 I8nKpYYhuIXvmbxu7u/iVR0MMDS5T7UJn7/cS5reL1YjwAJa1GY6l05bdazH3xkByQCeZ
	 dA1/BWxDmJkl4NUr3yEmSQVtv1+GJJ2r1U3Kk+RZ4npfdoX8ooZ8RVm2Pxl9F7+xHZJnK
	 pZSZ1OYuaofUq3K7Y2ImRH+9kgXkPacjyBiozkMzjiR66LNTKi3qsVJKcNpgEabiWlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0cuK0x5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1512606A33D;
	Wed, 18 Nov 2026 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0cuK0x5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF8D1F000C5;
	Wed, 18 Nov 2026 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020778;
	bh=5cPkuFbynq+PvRq+xdJb/VuJiV1RdaebezRkgKjGVUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0cuK0x5itf5MgkGce5+PNipO7cVwFS/cxHWABcZXAW0bqDN+ARZ1nPfo8kIShjFP
	 puvaT2ht567WIzE2zq5FtHmlBKFhPexS5tB2OEYP78zi7k6Gbi66r8wdP9iIo6obVE
	 cp+OCYxZGAkIJ0/OrdkKcWAin0Sr6Gn/i0dYsMKQ=
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
Subject: [PATCH 7.3 2073/2651] ptp: qoriq: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 15:55:13 +0100
Message-ID: <20261118150400.673065332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 76272e5ac5b85..bcd29104effe7 100644
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



