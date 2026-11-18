Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020776;
	b=JxO6iawNamqxjgJKDVLN725dxvgxYmWfoxS2G22chOzjImElY/vgBV5VsaUvF+xfgAwP
	 rTm4l4k4gCy3n2uJT0n02fAOu7r8Otxh9GqAoKUGus035+bI45S71i46bPl8VlvCChC4+
	 O3Q9gJsLNHNRxv5enhqP8q76H3ctJ/3OgDdR/k6tyAv45csojHqPlzlsvDie6pjUaJoN/
	 fzzRp/DIKZmYIYevhmmjysJqfigwfTmTNcpC11sRLNWzWotSGlx6eNX105GxdYJTmByB7
	 JQX7jEObK6lBUuSvunrvY+EcUx+QnFI3G2Dk1nP7w5pGJEzjrkPuYYDY9nQbn3oGenQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bGYtcpMtE2ChDvXZ3m3W+CNxR9jItkPSSBEYzMLCXUo=;
	b=TbJswRkxzj+qIEN+ooJ6X2yMZxY4ZZiUDvf2nEu19YY3W4670kMMhjme1mh8eb/+88yC
	 L3+FieOQ0ZiJzlV2oL95CI4qRx9Ul4PK+3La8Mol1SIcV062G44hIMHvK/IgCzYdI1d1W
	 8J3Kj9HJO+6oPBAZvaEj+6gf5nBTLdr6jFcdVmg0a9+MTQJCv9rDZtZqdBx1xr5Q+5lEk
	 +uQWqeoWmQN5cOB4WZfSDfRdYbnohbWjLxbKsRyD5CPC4ZySMFyZUe6EowkApBjr3eKFj
	 NSfZszblEJ1UvqzcPzuRbAxcXqr9tzE+k5Gluqq7B9LKooytca9oVvywBvB8g522aNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJ9Ucc4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30F160A5BDC;
	Wed, 18 Nov 2026 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NJ9Ucc4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453C71F000C6;
	Wed, 18 Nov 2026 16:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020775;
	bh=bGYtcpMtE2ChDvXZ3m3W+CNxR9jItkPSSBEYzMLCXUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJ9Ucc4VpAdF/RWwATURcj+KDt1BGCkORUUl2ITPuvE+KdMMC5a/3sVRKF90F+tJi
	 nswL2K6wvJAvMCPSKs9g6+l5Lweb3gtzLh/ylpz4Kw17HyfSdxhKNzaTbYGYvrGTxR
	 tjR1HGCHkHd2HPWc/eCfv1F0OzsKEEkKNx6S5mKI=
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
Subject: [PATCH 7.3 2072/2651] net: enetc: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 15:55:12 +0100
Message-ID: <20261118150400.641314632@linuxfoundation.org>
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
index 162cbc8017304..5ffee882d6241 100644
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



