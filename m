Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034652;
	b=E/HfrUxUyA1z6gLN+4S8iIG+yDDQeNwYuqD1Dool3mHQGlHA7eph/ra2qVmk2IDwlsQz
	 Oy3IgJ09Zjiz7XnLawlpaktoP2qN2tAiZpNBYTeqRZDUiGrqBz3JReNx2MGvvPqCBGc3B
	 K9mEG5wdjJCw7hK3v6nAuDDIaDqp2Y8QIHN+wYJW8/NXWDp8NCoqfiajvZDPtOgMkWUa9
	 ArQhLKQxFRxMIrWBwfRxdDD7PL3Q80XQksuJazFopHS+SiH/fGGwCc3ABhCDxvDdaZgkd
	 LvJi/w0GoCZPZZnpR4V0cz/aiTkM+1IXfPxlRsqn8t63DKp+R3BPbdlcSCxYXOlpo0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JvixRwcztoCacmqizMrSuTLgBzes0vwryWYgGCm+Bmk=;
	b=wuuNlEowQuvLT6esQp5By0/DoRPVyhERx0/lh56PYdPoCzAMkksXSD0q2PhjsRdn9sFF
	 F+/Eziw+s2L6M+lOQC3WCw5LscRQjB0ZCAexmyXlk+s0uWVL8w2se6Zs+zHIdTn/8bHna
	 FwQZpaToDKik1UP9DfTLsT1K62VD8ZSYhtnkTbUVX00+p5bxEumZBKJKeDDEy9cLx71ZK
	 Tlvf1RmvpfX8cJdBWEDYj6te/yRFLsx61zCM3vN451XGxe7IN1tESlp8Ow4t0XkHw4EaW
	 CJ4EhOs/CBRJ8q3aLj3N2MoThv1NApTo7UlLP4HQASoS3qp01EPOBdSUr876W1dpGbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEws94Vj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F416B606A32F;
	Wed, 18 Nov 2026 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEws94Vj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F931F000C4;
	Wed, 18 Nov 2026 20:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034651;
	bh=JvixRwcztoCacmqizMrSuTLgBzes0vwryWYgGCm+Bmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEws94VjFr58lmIycy6AnA5UOQuqfR9AmxxMBVyyv/y2jVmwMAwwOiH1EjPpM82z6
	 5dgK7z9nIBoew4oH6lE1PAAH71xk53I8vnY/zYr5HNM+J3O2eIGnooLWNdJR4WGSQH
	 ucKs+vl9/rL1zexzmSjTRPOd5SobYAMF2eRrGDMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason J. Herne" <jjherne@linux.ibm.com>,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0446/3318] s390/vfio-ap: handle hardware checkstop state on queue reset operation
Date: Wed, 18 Nov 2026 15:17:48 +0100
Message-ID: <20261118150330.115686202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason J. Herne <jjherne@linux.ibm.com>

[ Upstream commit a681226c675cf4ff4f1ece8f44a7f698c4a6ca6a ]

Update vfio_ap_mdev_reset_queue() to handle an unexpected checkstop (hardware error) the
same as the deconfigured case. This prevents unexpected and unhelpful warnings in the
event of a hardware error.

We also stop lying about a queue's reset response code. This was originally done so we
could force vfio_ap_mdev_filter_matrix to pass a deconfigured device through to the guest
for the hotplug scenario. vfio_ap_mdev_filter_matrix is instead modified to allow
passthrough for all queues with reset state normal, deconfigured, or checkstopped. In the
checkstopped case we choose to pass the device through and let the error state be
reflected at the guest level.

Signed-off-by: "Jason J. Herne" <jjherne@linux.ibm.com>
Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Link: https://lore.kernel.org/r/20240215153144.14747-1-jjherne@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 65e05ec252a9 ("s390/vfio-ap: fix KVM GISC and page leak when queue removed from host config")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 35 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index d6c60802c9785..572f9fd511c5a 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -663,6 +663,21 @@ static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
 			     AP_DOMAINS);
 }
 
+static bool _queue_passable(struct vfio_ap_queue *q)
+{
+	if (!q)
+		return false;
+
+	switch (q->reset_status.response_code) {
+	case AP_RESPONSE_NORMAL:
+	case AP_RESPONSE_DECONFIGURED:
+	case AP_RESPONSE_CHECKSTOPPED:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * vfio_ap_mdev_filter_matrix - filter the APQNs assigned to the matrix mdev
  *				to ensure no queue devices are passed through to
@@ -691,7 +706,6 @@ static bool vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(prev_shadow_apm, AP_DEVICES);
 	DECLARE_BITMAP(prev_shadow_aqm, AP_DOMAINS);
-	struct vfio_ap_queue *q;
 
 	bitmap_copy(prev_shadow_apm, matrix_mdev->shadow_apcb.apm, AP_DEVICES);
 	bitmap_copy(prev_shadow_aqm, matrix_mdev->shadow_apcb.aqm, AP_DOMAINS);
@@ -720,8 +734,7 @@ static bool vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev,
 			 * hardware device.
 			 */
 			apqn = AP_MKQID(apid, apqi);
-			q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
-			if (!q || q->reset_status.response_code) {
+			if (!_queue_passable(vfio_ap_mdev_get_queue(matrix_mdev, apqn))) {
 				clear_bit_inv(apid, matrix_mdev->shadow_apcb.apm);
 
 				/*
@@ -1709,6 +1722,7 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 	switch (status->response_code) {
 	case AP_RESPONSE_NORMAL:
 	case AP_RESPONSE_DECONFIGURED:
+	case AP_RESPONSE_CHECKSTOPPED:
 		return 0;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 	case AP_RESPONSE_BUSY:
@@ -1765,14 +1779,6 @@ static void apq_reset_check(struct work_struct *reset_work)
 				memcpy(&q->reset_status, &status, sizeof(status));
 				continue;
 			}
-			/*
-			 * When an AP adapter is deconfigured, the
-			 * associated queues are reset, so let's set the
-			 * status response code to 0 so the queue may be
-			 * passed through (i.e., not filtered)
-			 */
-			if (status.response_code == AP_RESPONSE_DECONFIGURED)
-				q->reset_status.response_code = 0;
 			if (q->saved_isc != VFIO_AP_ISC_INVALID)
 				vfio_ap_free_aqic_resources(q);
 			break;
@@ -1799,12 +1805,7 @@ static void vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		queue_work(system_long_wq, &q->reset_work);
 		break;
 	case AP_RESPONSE_DECONFIGURED:
-		/*
-		 * When an AP adapter is deconfigured, the associated
-		 * queues are reset, so let's set the status response code to 0
-		 * so the queue may be passed through (i.e., not filtered).
-		 */
-		q->reset_status.response_code = 0;
+	case AP_RESPONSE_CHECKSTOPPED:
 		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
-- 
2.53.0



