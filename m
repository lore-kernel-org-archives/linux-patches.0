Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFCD146A87;
	Fri,  6 Dec 2024 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496410; cv=none; b=aqtkVGbIjEP2oSAGTH0vBxvE+urGoKkPL8kURgZ5kA0HM2GTLNHouCbW+upnCqwAJl6NI1V30h+XKYFWbFOXGk3Dfdsf2eOwVasHxj3FJTeJaPwvOAliky+NnhPxztQMmVTAcnA6T8A+MOFFh+3OO0yrfbtVoYcVrUsjGP1QzYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496410; c=relaxed/simple;
	bh=MEs5WRcJpqcNhz0IGYqyphEWzvay+QcptAw6e0bhihs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OoIRWlL+R4r93MqSdiMrKD7AihIrqKYFFBIOp0jF/PR0S2Uds4oZEZrmTQwz+iAG8quJjQtsoztR/kk89PNgPe6cWI6oL494wATPNHxPo2XZNII2LZr6AMprKFjUJsUxjd/VkhnzStdLkKwU6n49NorobkwQkS/CJKbA8XrEfTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCyPIvRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCyPIvRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27257C4CED1;
	Fri,  6 Dec 2024 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496410;
	bh=MEs5WRcJpqcNhz0IGYqyphEWzvay+QcptAw6e0bhihs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCyPIvRzfD384Ef+UxZnIZ0Lu187nwD7yZlh70AtiU59bKciOsdhsG0mZn/5sZirs
	 gQci5rMbGH3LYIODLvcaBSqshEAbd7lbAKrwfuW3z53o+52xPYFAeffQsLlE+a8hMV
	 OAL/QntS2xLMpaMJMAsFZEA/PJ5rFhrcFJJNZvfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 117/146] net: fec: refactor PPS channel configuration
Date: Fri,  6 Dec 2024 15:37:28 +0100
Message-ID: <20241206143532.159107182@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit bf8ca67e21671e7a56e31da45360480b28f185f1 upstream.

Preparation patch to allow for PPS channel configuration, no functional
change intended.

Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Csókás, Bence <csokas.bence@prolan.hu>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -84,8 +84,7 @@
 #define FEC_CC_MULT	(1 << 31)
 #define FEC_COUNTER_PERIOD	(1 << 31)
 #define PPS_OUPUT_RELOAD_PERIOD	NSEC_PER_SEC
-#define FEC_CHANNLE_0		0
-#define DEFAULT_PPS_CHANNEL	FEC_CHANNLE_0
+#define DEFAULT_PPS_CHANNEL	0
 
 #define FEC_PTP_MAX_NSEC_PERIOD		4000000000ULL
 #define FEC_PTP_MAX_NSEC_COUNTER	0x80000000ULL
@@ -524,8 +523,9 @@ static int fec_ptp_enable(struct ptp_clo
 	unsigned long flags;
 	int ret = 0;
 
+	fep->pps_channel = DEFAULT_PPS_CHANNEL;
+
 	if (rq->type == PTP_CLK_REQ_PPS) {
-		fep->pps_channel = DEFAULT_PPS_CHANNEL;
 		fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
 
 		ret = fec_ptp_enable_pps(fep, on);
@@ -536,10 +536,9 @@ static int fec_ptp_enable(struct ptp_clo
 		if (rq->perout.flags)
 			return -EOPNOTSUPP;
 
-		if (rq->perout.index != DEFAULT_PPS_CHANNEL)
+		if (rq->perout.index != fep->pps_channel)
 			return -EOPNOTSUPP;
 
-		fep->pps_channel = DEFAULT_PPS_CHANNEL;
 		period.tv_sec = rq->perout.period.sec;
 		period.tv_nsec = rq->perout.period.nsec;
 		period_ns = timespec64_to_ns(&period);


