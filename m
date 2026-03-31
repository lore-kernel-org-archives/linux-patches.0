Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FDF3E559E;
	Tue, 31 Mar 2026 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975213; cv=none; b=s582BbXp8GEXPZR08sccOADAvK1bpbjAPB9O6fbg3zsTxucCXVHzVutDXEC3XX3ve1Zzia4BH5LIP2IX/YDbciuH0133hbcU99G2qpGFwgwji3h72kkXtGoX+3/i6GrmmTO0BXoorW2qFPZueLuCbB5cfu+b5Pbf7nXw7QNk/iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975213; c=relaxed/simple;
	bh=gIoKtqJQJkrIV0eMq9z8fzkstMHmgLQIjIotUsIQF3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM5PApaZmu12SG6c39S+sU5/uaQkdCAjDhG0bVJKRMstaMFeC+zJZ62Tzh6WJa3govv4s7cxNsriNy6FbZtsqU2hWD/58mVCMFj2XTEFl5KOomUNC7H0Be00dJj45aeX5WfZqIKwS0r002mgQ61Jdc/owSWnXoPzIAgxp4kI99k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6d0RJJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6d0RJJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A99C19423;
	Tue, 31 Mar 2026 16:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975213;
	bh=gIoKtqJQJkrIV0eMq9z8fzkstMHmgLQIjIotUsIQF3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6d0RJJKcfazpirUZDLElYDnitqOdJe6Cc6Gful4ry5sVGfp1Tj99lkOUeIkpQ8ND
	 7DNpT5qrK+2GAsbmfGzuMt9WLoxAU0uhjOdRGSbOyw74jCIK7kAUDJfAOVrEE0PpIc
	 R70kUX5CCTxGvGnEo96/ZjISkVJi9sgNRFVsu3GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lizhi.hou" <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.19 208/342] accel/ivpu: Add disable clock relinquish workaround for NVL-A0
Date: Tue, 31 Mar 2026 18:20:41 +0200
Message-ID: <20260331161806.634969302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit e8ab57b56402697a9bef50b71aecc613f0d61846 upstream.

Turn on disable clock relinquish workaround for Nova Lake A0.
Without this workaround NPU may not power off correctly after
inference, leading to unexpected system behavior.

Fixes: 550f4dd2cedd ("accel/ivpu: Add support for Nova Lake's NPU")
Cc: <stable@vger.kernel.org> # v6.19+

Reviewed-by: Lizhi.hou <lizhi.hou@amd.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260323095029.64613-1-karol.wachowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.h | 1 +
 drivers/accel/ivpu/ivpu_hw.c  | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_drv.h b/drivers/accel/ivpu/ivpu_drv.h
index 5b34b6f50e69..f1b6155065ff 100644
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -35,6 +35,7 @@
 #define IVPU_HW_IP_60XX 60
 
 #define IVPU_HW_IP_REV_LNL_B0 4
+#define IVPU_HW_IP_REV_NVL_A0 0
 
 #define IVPU_HW_BTRS_MTL 1
 #define IVPU_HW_BTRS_LNL 2
diff --git a/drivers/accel/ivpu/ivpu_hw.c b/drivers/accel/ivpu/ivpu_hw.c
index d69cd0d93569..d4a9bcda4100 100644
--- a/drivers/accel/ivpu/ivpu_hw.c
+++ b/drivers/accel/ivpu/ivpu_hw.c
@@ -70,8 +70,10 @@ static void wa_init(struct ivpu_device *vdev)
 	if (ivpu_hw_btrs_gen(vdev) == IVPU_HW_BTRS_MTL)
 		vdev->wa.interrupt_clear_with_0 = ivpu_hw_btrs_irqs_clear_with_0_mtl(vdev);
 
-	if (ivpu_device_id(vdev) == PCI_DEVICE_ID_LNL &&
-	    ivpu_revision(vdev) < IVPU_HW_IP_REV_LNL_B0)
+	if ((ivpu_device_id(vdev) == PCI_DEVICE_ID_LNL &&
+	     ivpu_revision(vdev) < IVPU_HW_IP_REV_LNL_B0) ||
+	    (ivpu_device_id(vdev) == PCI_DEVICE_ID_NVL &&
+	     ivpu_revision(vdev) == IVPU_HW_IP_REV_NVL_A0))
 		vdev->wa.disable_clock_relinquish = true;
 
 	if (ivpu_test_mode & IVPU_TEST_MODE_CLK_RELINQ_ENABLE)
-- 
2.53.0



