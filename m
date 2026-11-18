Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020773;
	b=mqNDjtPGxCl6+TLn0KLgQ3yoAulDTVd/JINb8Vz6i7YkGjG9C2Rqab+6lDSXmg6r1MFl
	 1wbEXEyI4U1t1umT7mBiUS6CxP7xU4Mx78iL7hqJrjnJrmGNlYrjnEHrEwcpOVpk/yqxc
	 7qa4ZmLSTsfGKFwpDWDT0F2emmotVpqzbAWmbAXMKUHb9jtO3Z0t+aZFKMrUv41HGOuOI
	 hdRzjBA6N8zVcO/62HBrnJGoIUWkd5w2LunWF9iwaOmyj5HCVX2TizYM/Q5snEEqgJuzX
	 Qd4vLWSii0D0i9Kpg9RbeJX60YxxLFjilaACaUhSzTvwJbzX0hIDIXX+qdRa3uPEXiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3+Oed55GboZ5pgC9R4Eg1lq4px7yyrlVYLKCelUAVYo=;
	b=v2FoaG3hXsWOWe5qVabLm25iXS0o1bghuAIl5husQ6J9q6q7PpntiK1iiDybHK08GsmU
	 QI/ScnbhnsCYkw9QiL3v0swL2oi6px9lp7sW3gIbsxS5NYk3s00uyErVvk1JNsZgI+n23
	 Uy/2qM9r6oIeHvgOxTUUfUHMNFMjvw4FDC+QZww5BLinJWkjudnavMKzUoLG/4wUCb8KE
	 bQyoh+TVTfAA/PzJaKN+suftZCUVTP8kvQwCgpMjPpgCqKSQ7OpjHYrYFZeF5pJntFLhT
	 +6Nk3AHF47aUG4P0fathLCix6OKleg30KLHlrVGNCQX/NEL95RrMja/D8KJDVqQ1gjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIWC7xS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A89060A5BD7;
	Wed, 18 Nov 2026 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DIWC7xS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B40A1F000C4;
	Wed, 18 Nov 2026 16:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020772;
	bh=3+Oed55GboZ5pgC9R4Eg1lq4px7yyrlVYLKCelUAVYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIWC7xS7FZLnLZAm1Mc/tdP3qu1glEtQ9+Q7zukV6/wEWeoUx4ts7nPjRQrtiHDDo
	 LJuSLCUE26Ltk0NfrYLlwACfR+TqyhnN3e/iXPtci71RLPvCXbM0vOdCp9YzvkRbMC
	 ZLwr27FLCiupZ1ewzWVkrojywikz/MjG+ikxF9DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vincent Jardin <vjardin@free.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2071/2651] dpaa2-ptp: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 15:55:11 +0100
Message-ID: <20261118150400.609089800@linuxfoundation.org>
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



