Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034654;
	b=fSdRlBxBHUDMeVYgO+91PT6IPqXuEzcIIfY0bd9TVe8wlAiJf8cBFakDr6jY2SFaIDtk
	 /ryQ5X5CwiPDP4FzFY0U7nktdlYMqEkNJxDvoxNIGknQfJ9gKgkj2Let+go/YdBhUpYS7
	 jGCTErooSCa0ypm+M35hlUjUd95OgvLMvlMM7ajwHqj0Z4F85nsUfCPhY7P3eEtijLJY2
	 Iu5j09jx2WnyHgaiFChRDdA/qquRRjzjVutpc/rbSER2qc2ma2OSLDPDjfwdnSM0AFDP0
	 vj87RSfY9s7qzju9h70O7q0rLTAgCLWo1n5KVs34RYTl8F7uyuFIl/ghpSHhffcf2Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mY+bsQr9rd9txRQYu8X0NDK2NSmpMh3vPTLfzrtJgqg=;
	b=vVmQy4bIpbZS1IsdVrks1uKBymjGdtL0lBkRb0hcN75ll4VQhHmRHDvo4vE/ZkQNlz2O
	 6cepT9GMQKdwMPzmApMqP+0rGIseizFsinJqkjo5UACysWcKGVXfff1aNgUv1OcyV8+52
	 7upZ/neppuzPIR0lWiyTJBOq8ShqkBVzvlju4hVjOlQKp6QTJ4BrS/dR8TJkrzd4n8Igk
	 MqGP8O10loU84ZNHZNzjpXmo+2qS3A3TYeX1gihWB9wmmo+MOvOD0f6PmmuIZvpt1VvyJ
	 yLUJvUpX6wal5HRJq1VyGC+CXzAlSrOTO+pBxhivk7jNMLUIjurzqEMx347M5Vptyng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHppP0pS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B1E606A32C;
	Wed, 18 Nov 2026 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHppP0pS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D5E1F000C4;
	Wed, 18 Nov 2026 20:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034654;
	bh=mY+bsQr9rd9txRQYu8X0NDK2NSmpMh3vPTLfzrtJgqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHppP0pSN1Fi13PRrcWz9zgOM88MhDxmL3BP4FRNDDvfiOC/OMstzAG9VoID3y7KH
	 pFuBCfoSotxZZgB+wJknyQm4F5G62aRTRUeWKSkt8ns51OGjpNIhW/D7IPHkScoh+Z
	 b1YcwogWt7gvy9Ap2dkJv24TnAFNdZGNU36gr2VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0447/3318] s390/vfio-ap: fix KVM GISC and page leak when queue removed from host config
Date: Wed, 18 Nov 2026 15:17:49 +0100
Message-ID: <20261118150330.150587387@linuxfoundation.org>
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

From: Anthony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit 65e05ec252a9b79e75930d3c4dd42d8877db04c5 ]

Three related problems exist in the handling of KVM interrupt and page
resources when a queue is removed from the host's AP configuration
while assigned to a mediated device (mdev).

Problem 1:
~~~~~~~~~
AP_RESPONSE_Q_NOT_AVAIL not handled in vfio_ap_mdev_reset_queue()

When the AP bus removes a queue device whose adapter or domain has
been removed from the host's AP configuration,
vfio_ap_mdev_remove_queue() is called. If the queue is still in the
host's AP configuration at that point, it calls
vfio_ap_mdev_reset_queue(), which issues a PQAP(ZAPQ). Since the
adapter is already gone from the host configuration, ap_zapq() returns
AP_RESPONSE_Q_NOT_AVAIL (0x01). This response code is not handled in
vfio_ap_mdev_reset_queue()'s switch statement and falls through to
the default case, which issues a WARN but does not call
vfio_ap_free_aqic_resources(). As a result, if IRQ handling was
enabled for the queue by the guest, the KVM GISC registration and
the pinned guest page holding the notification indicator byte (NIB)
are both leaked.

This is fixed by adding AP_RESPONSE_Q_NOT_AVAIL to the same case as
AP_RESPONSE_DECONFIGURED and AP_RESPONSE_CHECKSTOPPED in
vfio_ap_mdev_reset_queue(). Like those response codes, Q_NOT_AVAIL
indicates the queue is not operational and no further reset attempts
are possible; the correct action is to free the IRQ resources
immediately.

Problem 2:
~~~~~~~~~
 AP_RESPONSE_Q_NOT_AVAIL not handled in apq_status_check()

In vfio_ap_mdev_reset_queue(), there are four cases that indicate a queue
reset has not yet completed, in which case apq_reset_check() is queued to
a work queue to verify completion of the reset operation. This function
uses the PQAP(TAPQ) function to get the queue's status and calls
apq_status_check() to verify whether the reset has completed, failed or
needs to be executed again. As described in Problem #1 above,
apq_reset_check() does not specifically check for AP_RESPONSE_Q_NOT_AVAIL,
thereby potentially leaking KVM GISC registration and the pinned guest page
holding the NIB.

This is fixed by adding a case statement for AP_RESPONSE_Q_NOT_AVAIL to
apq_status_check() and returning -ENODEV for that case. The caller,
apq_reset_check() will then check for this return code and call
vfio_ap_free_aqic_resources() to prevent the leak.

Problem 3:
~~~~~~~~~
vfio_ap_free_aqic_resources() leaks saved_isc when kvm is NULL

vfio_ap_free_aqic_resources() guards the call to
kvm_s390_gisc_unregister() with:

    if (q->saved_isc != VFIO_AP_ISC_INVALID &&
        !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->kvm)))

If matrix_mdev->kvm is NULL -- which can happen when
vfio_ap_mdev_unset_kvm() has already run and cleared kvm before a
subsequent cleanup path reaches this function -- the WARN_ON fires
and the entire block is skipped. This leaves q->saved_isc set to a
non-invalid value, creating a potential double-free on any subsequent
call to this function.

When kvm is NULL the KVM guest is already torn down, so
kvm_s390_gisc_unregister() need not and cannot be called; however,
q->saved_isc must always be cleared. Fix this by separating the
kvm_s390_gisc_unregister() call from the q->saved_isc reset. The
WARN_ON now guards only the genuinely impossible case of matrix_mdev
being NULL. A NULL kvm is handled gracefully by skipping only the
unregister call, and q->saved_isc = VFIO_AP_ISC_INVALID is set
unconditionally whenever saved_isc was not already invalid.

Additionally, add an else clause to the host-config check in
vfio_ap_mdev_remove_queue() to call vfio_ap_free_aqic_resources()
directly when the queue is not in the host's AP configuration. This
serves as a backstop: when the AP bus fires the driver .remove
callback after an adapter is removed from the host config, the queue
is by definition no longer addressable, so vfio_ap_mdev_reset_queue()
would always return Q_NOT_AVAIL. The else clause handles this case
directly without the unnecessary ap_zapq() call, and ensures cleanup
occurs even if kvm has already been set to NULL by a prior call to
vfio_ap_mdev_unset_kvm().

Fixes: b9bd10c43456d ("s390/vfio-ap: do not reset queue removed from host config")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260818193349.1877940-2-akrowiak@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 572f9fd511c5a..66c94f1f3a6b3 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -277,9 +277,9 @@ static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
 {
 	if (!q)
 		return;
-	if (q->saved_isc != VFIO_AP_ISC_INVALID &&
-	    !WARN_ON(!(q->matrix_mdev && q->matrix_mdev->kvm))) {
-		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
+	if (q->saved_isc != VFIO_AP_ISC_INVALID) {
+		if (!WARN_ON(!q->matrix_mdev) && q->matrix_mdev->kvm)
+			kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
 		q->saved_isc = VFIO_AP_ISC_INVALID;
 	}
 	if (q->saved_iova && !WARN_ON(!q->matrix_mdev)) {
@@ -1737,6 +1737,8 @@ static int apq_status_check(int apqn, struct ap_queue_status *status)
 		 * a value indicating a reset needs to be performed again.
 		 */
 		return -EAGAIN;
+	case AP_RESPONSE_Q_NOT_AVAIL:
+		return -ENODEV;
 	default:
 		WARN(true,
 		     "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
@@ -1763,6 +1765,10 @@ static void apq_reset_check(struct work_struct *reset_work)
 		ret = apq_status_check(q->apqn, &status);
 		if (ret == -EIO)
 			return;
+		if (ret == -ENODEV) {
+			vfio_ap_free_aqic_resources(q);
+			return;
+		}
 		if (ret == -EBUSY) {
 			pr_notice_ratelimited(WAIT_MSG, elapsed,
 					      AP_QID_CARD(q->apqn),
@@ -1806,6 +1812,7 @@ static void vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		break;
 	case AP_RESPONSE_DECONFIGURED:
 	case AP_RESPONSE_CHECKSTOPPED:
+	case AP_RESPONSE_Q_NOT_AVAIL:
 		vfio_ap_free_aqic_resources(q);
 		break;
 	default:
@@ -2285,12 +2292,15 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
 	/*
 	 * If the queue is not in the host's AP configuration, then resetting
 	 * it will fail with response code 01, (APQN not valid); so, let's make
-	 * sure it is in the host's config.
+	 * sure it is in the host's config. If it is not, free the KVM GISC
+	 * resources.
 	 */
 	if (test_bit_inv(apid, (unsigned long *)matrix_dev->info.apm) &&
 	    test_bit_inv(apqi, (unsigned long *)matrix_dev->info.aqm)) {
 		vfio_ap_mdev_reset_queue(q);
 		flush_work(&q->reset_work);
+	} else {
+		vfio_ap_free_aqic_resources(q);
 	}
 
 done:
-- 
2.53.0



