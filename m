Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021614;
	b=M53LBqKqIb2ifnGzWwT7yesflPZKS901OsskCscLZSEdnxKBVVTJUGCN9g2Kyu51krP4
	 7fRknpyplF7LpJCMzKlifax5czMjuadTC7awG9US8DkX3qB9jRtE+AeejBwd4RGreQ7n+
	 YluoBsh+HOznhUhX+oN3PWKPnDdLA0lubbhqd6cfDEgazvfrtOSQHJ2EMeRImzv8N3gpY
	 r4ImgHtOSjBpI8B2O1PhPourNEtU10djGk8Pv22dBKO+MgIXpab+wGxQJ1WHdCPB0PNRJ
	 uQWNMY7j5aIi+jZ5hZ7wYv8KthgRVmmhDTxXR51dElz6kqK4ZuNPb2XY6wkCWtOX1ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qbuUCJArvmnS3vOZSCgOVZSEJZtU47LeAJ4axgW4Z/4=;
	b=VHKGX6yZyU2Nnth2w5oNsZr3HECvkrLNb7Fq/aXX0y1W73xC5Kr/3fHSiAl7xZJ9TMhq
	 KB+zsVZG4mtZ5/6JASB8raIZucOnM6u28AH7TjdjD5El43EKT9AgIlV6hcFPnTfTX4Pep
	 MOSZwTEolBUNHphbpIKLHQm0jkoTzx6/PTE+VKyIo8VhmqC0E5xPGIhT1OjMnAVtf5MeV
	 vk9kDPRT6OHh2qwfkJUKXYgX+fsoDApQRxYWo2kulvJjAdeoruDl6ED7DlOaG8UYb/fV7
	 qZsYP5WCb4sZNeRmkPq9L7slazKGFOsbBH0U2PY9q3HP5Bo2duivJ97+FU+tZLvSCmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnvoJD+8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE3260A2626;
	Wed, 18 Nov 2026 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnvoJD+8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA45D1F000C5;
	Wed, 18 Nov 2026 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021614;
	bh=qbuUCJArvmnS3vOZSCgOVZSEJZtU47LeAJ4axgW4Z/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnvoJD+8E/s1TGSglxZ3+CIohpVZU/lSs2w0BhaKtxK+r8+j9xbmCFM2ZHFFqaYqc
	 x5LgEHzYq7CNSoLv8go1XtiXt9eGMflUloX6gKAaw3gX/pM779hzTdKdKTGUbkvl6l
	 jjFzk7Gn3SDeIfX/bjJtaKiRLtfxByebqF1+9Br0=
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
Subject: [PATCH 7.3 2371/2651] net: ethernet: ti: am65-cpts: fix support for PTP_EXTTS_REQUEST2 ioctl
Date: Wed, 18 Nov 2026 16:00:11 +0100
Message-ID: <20261118150410.873447262@linuxfoundation.org>
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
index efbf2ef976a32..df5659ead72f6 100644
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



