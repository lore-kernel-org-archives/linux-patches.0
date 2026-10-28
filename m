Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214535;
	b=1KZQGQjMArqIZKW/90VCLF/3fdlEHCj34tCvChmISd8LJK4xY0VXuR2MnNM+aaBCpY2n
	 ehTUzQfgIYFRPOMm47+p1ZwyfNjK/GaXfjK2wf/8QbsmQSIZr2OfYhCbP2fBu46B9qk+D
	 8oTB5kzw46c1Skm2Iq27YwJeaeRzQ908b8jpsw+pJ7eYR/nNWbUDaLOyy5F3burg8jbKg
	 luIw4wVd3p9cOZTiCfSwfsn28ghaZY3BnfODFTjaakXd00YU2un5bWujygTYrn8YyVB1h
	 UDBSrF3fOmufH8UStBSN2jYQkt1eWQhRgm44XrijytHx1mKR1wBoRI4nJ7L2JQfGs9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KKQH1TmHcqSQKa+XzgdftuDszSCRHgHJX1Q/hc/TiiQ=;
	b=jXGAv+JuNFgt+43LM+FQOXEJ6mOUk4gBf4aQ+HqM3MgUngDsavGElLkvsCxbLiSt/hLL
	 0H73EIUeRDT6lC0OTc5HG4JVTycntu8HvtuG9adk8JHKZhmlMNipnA2e0UzxMK/0rvnBg
	 2cxtrDJwtOORsAZk8O8O+e59w/k4AsXxKTApHFW+W/xXvyf88EvmUoMMO1zqJDIJklBt/
	 7mGrzNoywdHE74svJLl+bbOmjT4XtRtNmyMltk2QJB9Jg+ns8l7RsYZCf1T28pMI2/omt
	 d/MtvmakvIc973uoIAFa9u/wXDwDn41dZ8J6KIupQoyw2MSDjs08GusN7aexypxmMFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVzlZAuB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE4C60A2613;
	Wed, 28 Oct 2026 19:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVzlZAuB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDAC1F01825;
	Wed, 28 Oct 2026 19:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214535;
	bh=KKQH1TmHcqSQKa+XzgdftuDszSCRHgHJX1Q/hc/TiiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVzlZAuBcFkarON1pcVMvJNnOZKJ3ekjnYnrjpI95FkN9XGjIqg9tkKAa5A/r96yp
	 UdrU42xHuwMWtqoe6wNN+BnOy+hkQM0Ff2DbF5HjCnt79AdKGZpayW75DmQ1xcwspG
	 LRI46+JT12sHxAxGPdqU6A4QCtuxa0lw8XC7k2rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0892/1887] scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)
Date: Wed, 28 Oct 2026 17:49:48 +0100
Message-ID: <20261028170519.717625619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

[ Upstream commit 5127be409c6c3815c4a7d8f6d88043e44f9b9543 ]

According to UFS specifications, the power-off sequence for a UFS device
includes:

 - Sending an SSU command with Power_Condition=3 and await a response.

 - Asserting RST_N low.

 - Turning off REF_CLK.

 - Turning off VCC.

 - Turning off VCCQ/VCCQ2.

As part of ufs shutdown, after the SSU command completion, asserting
hardware reset (HWRST) triggers the device firmware to wake up and
execute its reset routine. This routine initializes hardware blocks and
takes a few milliseconds to complete. During this time, the ICCQ draws a
large current.

This large ICCQ current may cause issues for the regulator which is
supplying power to UFS, because the turn off request from UFS driver to
the regulator framework will be immediately followed by low power
mode(LPM) request by regulator framework. This is done by framework
because UFS which is the only client is requesting for disable. So if
the rail is still in the process of shutting down while ICCQ exceeds LPM
current thresholds, and LPM mode is activated in hardware during this
state, it may trigger an overcurrent protection (OCP) fault in the
regulator.

To prevent this, a 10ms delay is added after asserting HWRST. This
allows the reset operation to complete while power rails remain active
and in high-power mode.

Currently there is no way for Host to query whether the reset is
completed or not and hence this the delay is based on experiments with
Qualcomm UFS controllers across multiple UFS vendors.

Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251012173828.9880-1-nitin.rawat@oss.qualcomm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index ecd5939f4c9a6..3d5d10612bfd7 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -590,7 +590,18 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 		/* reset the connected UFS device during power down */
 		ufs_qcom_device_reset_ctrl(hba, true);
-
+		/*
+		 * After sending the SSU command, asserting the rst_n
+		 * line causes the device firmware to wake up and
+		 * execute its reset routine.
+		 *
+		 * During this process, the device may draw current
+		 * beyond the permissible limit for low-power mode (LPM).
+		 * A 10ms delay, based on experimental observations,
+		 * allows the UFS device to complete its hardware reset
+		 * before transitioning the power rail to LPM.
+		 */
+		usleep_range(10000, 11000);
 	} else if (!ufs_qcom_is_link_active(hba)) {
 		ufs_qcom_disable_lane_clks(host);
 	}
-- 
2.53.0



