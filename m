Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC801E9064;
	Mon, 21 Oct 2024 10:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506971; cv=none; b=CdTpqqVgBjwSttFqrJG7dtVhp1vvegrK+wYYGoi4qkfOQnJE2BIe6gB9DlGC3V6WWPk1JMGxTjjc2dL4A0qHBLzeij/e01uxlJ6kQiJJ760uPkE+Of5yLgu7NASTaRzQ2+BCDMhV/jQTDDpfrVoYx+EaSt5tMiwC+9bzOfanwJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506971; c=relaxed/simple;
	bh=DP82pCz+eWbKGnPmfsFKUIFa8bFamylh+dlJKRrksvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kMcNIcTQ9DWPdu6m7LiXkKAzAhlEdV5I//S4jYbLGukwpKZhwQMH8D+di2/oceKGeBko5VRG4HsNMr8YkDqHnunKIayqGcU+BAxxaX4wL1ZR+wxuW3GGV8KJoyt3CS+oCdARxpuZgS+F7PlBgoiszJ/yb+vzSh2GEeSwISZFt/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EZ9uvRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EZ9uvRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F058C4CEC3;
	Mon, 21 Oct 2024 10:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506971;
	bh=DP82pCz+eWbKGnPmfsFKUIFa8bFamylh+dlJKRrksvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EZ9uvRSnkMA6z88E19Aodt5iFUxAwOxhWguxGuvPQ2+g5DhOhP/4VuM4zeDrv4VB
	 SicFSC6pRB2gMBbY5y19yWAUK/uMgJD7pcmVdLagO9GpklTlLCHMqy+dMy28xxAouq
	 SBaWXfFmBZM4Oue+i8jLArqmzFpd168kytvupIek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.li@nxp.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 046/124] net: fec: Move `fec_ptp_read()` to the top of the file
Date: Mon, 21 Oct 2024 12:24:10 +0200
Message-ID: <20241021102258.509354184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

commit 4374a1fe580a14f6152752390c678d90311df247 upstream.

This function is used in `fec_ptp_enable_pps()` through
struct cyclecounter read(). Moving the declaration makes
it clearer, what's happening.

Suggested-by: Frank Li <Frank.li@nxp.com>
Link: https://lore.kernel.org/netdev/20240805144754.2384663-1-csokas.bence@prolan.hu/T/#ma6c21ad264016c24612048b1483769eaff8cdf20
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240812094713.2883476-1-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c |   50 +++++++++++++++----------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -91,6 +91,30 @@
 #define FEC_PTP_MAX_NSEC_COUNTER	0x80000000ULL
 
 /**
+ * fec_ptp_read - read raw cycle counter (to be used by time counter)
+ * @cc: the cyclecounter structure
+ *
+ * this function reads the cyclecounter registers and is called by the
+ * cyclecounter structure used to construct a ns counter from the
+ * arbitrary fixed point registers
+ */
+static u64 fec_ptp_read(const struct cyclecounter *cc)
+{
+	struct fec_enet_private *fep =
+		container_of(cc, struct fec_enet_private, cc);
+	u32 tempval;
+
+	tempval = readl(fep->hwp + FEC_ATIME_CTRL);
+	tempval |= FEC_T_CTRL_CAPTURE;
+	writel(tempval, fep->hwp + FEC_ATIME_CTRL);
+
+	if (fep->quirks & FEC_QUIRK_BUG_CAPTURE)
+		udelay(1);
+
+	return readl(fep->hwp + FEC_ATIME);
+}
+
+/**
  * fec_ptp_enable_pps
  * @fep: the fec_enet_private structure handle
  * @enable: enable the channel pps output
@@ -136,7 +160,7 @@ static int fec_ptp_enable_pps(struct fec
 		 * NSEC_PER_SEC - ts.tv_nsec. Add the remaining nanoseconds
 		 * to current timer would be next second.
 		 */
-		tempval = fep->cc.read(&fep->cc);
+		tempval = fec_ptp_read(&fep->cc);
 		/* Convert the ptp local counter to 1588 timestamp */
 		ns = timecounter_cyc2time(&fep->tc, tempval);
 		ts = ns_to_timespec64(ns);
@@ -272,30 +296,6 @@ static enum hrtimer_restart fec_ptp_pps_
 }
 
 /**
- * fec_ptp_read - read raw cycle counter (to be used by time counter)
- * @cc: the cyclecounter structure
- *
- * this function reads the cyclecounter registers and is called by the
- * cyclecounter structure used to construct a ns counter from the
- * arbitrary fixed point registers
- */
-static u64 fec_ptp_read(const struct cyclecounter *cc)
-{
-	struct fec_enet_private *fep =
-		container_of(cc, struct fec_enet_private, cc);
-	u32 tempval;
-
-	tempval = readl(fep->hwp + FEC_ATIME_CTRL);
-	tempval |= FEC_T_CTRL_CAPTURE;
-	writel(tempval, fep->hwp + FEC_ATIME_CTRL);
-
-	if (fep->quirks & FEC_QUIRK_BUG_CAPTURE)
-		udelay(1);
-
-	return readl(fep->hwp + FEC_ATIME);
-}
-
-/**
  * fec_ptp_start_cyclecounter - create the cycle counter from hw
  * @ndev: network device
  *


