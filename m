Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027800;
	b=pycVRi+igiAr4jAElxLVAIJOBrJDg1H5GJJIhp7WrD0HW1MninZ1nRFg2MQJbkSgL7Bd
	 4nlTA8Bs9Cfp6gxYd9Pj48yA8o4mGH0mTUjvGySHYxaE23LRgwlYvo1z/DwSwaD4qC8kS
	 JK2RNOdzyOePc/MMtS5hV3Uf7FRZbMdmkA24mJxArmlbKbBgQhM2EtZ7QK9l8J9eIuJAo
	 /jgyZJonaFfr4JaVzmrHK0GcSbMr3LnaVefVA8BVF2X3BhEkWmRplee29pGiSmby2EpxY
	 VrJgqgJoeSeOLdbclf6AeMTvsPryI00ItZTSBQ5WbqwZ7HGdoCxiLTkM0kGhDgOGOHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PGM9Gguu8i78Wq2mURp+7hG4GBzn/DsX0sPGEGQ2YG8=;
	b=RLBIKkNRPTJvni8HsyeHkUajRWiiGTAYZcNB+mwRbqRprXoVrhoMqXFOjQQBAJaoNyIc
	 TA78AIz4+nlfVS/+bHXykIojCyK//1M/nOKJN1Kt1EuL66JiFj+Xhw+rnCKjuc14h4tRI
	 nqe5s7uT/TqRpqveAlyKEsPqDb83GkzDjE/QVr6IT/8fwZIzmwwh+kk9uLJZdpoFtD8Nj
	 sqP/xDyyprxkn0ZLGZ1AeBDRpQJoWfZU7yU2kWd+EkEtYcZ48T21RQ4tHheQL+QMIjQ4z
	 6duWNRNIJ5zKaaJP/+DtP35nwqjItUYsqhmy9YGpi7npI26sK+hVLeblvUik6c7xzCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQLLu1H0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8BB606A325;
	Wed, 18 Nov 2026 18:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQLLu1H0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1177F1F000C4;
	Wed, 18 Nov 2026 18:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027800;
	bh=PGM9Gguu8i78Wq2mURp+7hG4GBzn/DsX0sPGEGQ2YG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQLLu1H0N2/vUIM4oLOdY70vhBz3uBAa/w/8VlriqTgVUaOK2OCTyMyFlFgbBAaPQ
	 DwOvUpfvr2DdOyxis5RzxJatCnOdS93fuJhss9Jtox9kP7FSmCmq53MRGZoDTcZCGj
	 8H1xxJQnvb42/edTgcOrPd9eNQwlmH/iIhDrF7Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <jjc@jclark.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1919/2151] net: ethernet: ti: am65-cpts: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 16:00:54 +0100
Message-ID: <20261118150231.687536216@linuxfoundation.org>
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

From: James Clark <jjc@jclark.com>

[ Upstream commit e3aaeebbef56ceaa27001d1d5a0c1d73d648e6f4 ]

Commit 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to
ptp_clock_info") modified the PTP core to validate the supported flags
of external timestamp requests, rather than relying on each driver to
check them.

am65_cpts_extts_enable() ignores the flags, and am65-cpts was not given
any .supported_extts_flags. Since PTP_EXTTS_REQUEST2 always implies
PTP_STRICT_FLAGS, the core now rejects every PTP_EXTTS_REQUEST2 for this
driver with -EOPNOTSUPP, where before that commit the same requests
succeeded. Only the PTP_EXTTS_REQUEST ioctl still works.

Tests on a BeagleY-AI (J722S) show that the CPTS hardware timestamp push
inputs timestamp just the rising edge. Encode this in
.supported_extts_flags. A PTP_EXTTS_REQUEST2 for the rising edge then
succeeds, and one for the falling edge or for both edges fails with
-EOPNOTSUPP.

Fixes: 7c571ac57d9d ("net: ptp: introduce .supported_extts_flags to ptp_clock_info")
Signed-off-by: James Clark <jjc@jclark.com>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20261020003525.1237742-1-jjc@jclark.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 8ffbfaa3ab18c..73adb822bc075 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -779,6 +779,7 @@ static long am65_cpts_ts_work(struct ptp_clock_info *ptp);
 static struct ptp_clock_info am65_ptp_info = {
 	.owner		= THIS_MODULE,
 	.name		= "CTPS timer",
+	.supported_extts_flags = PTP_RISING_EDGE | PTP_STRICT_FLAGS,
 	.adjfine	= am65_cpts_ptp_adjfine,
 	.adjtime	= am65_cpts_ptp_adjtime,
 	.gettimex64	= am65_cpts_ptp_gettimex,
-- 
2.53.0



