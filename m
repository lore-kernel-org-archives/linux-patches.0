Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216271;
	b=4fmehgKnYWwF35xWfVHBMCBF8tz9zbCl76pyUKwhwQqXu7XEP0KoprCJS6bkdAOp+T2J
	 r5ZgLM3+yaTeLlhP2sSzJ+VcQ4p36pt7oR+kuMl8a/AMN/mweYDWwCnMjToNtWMgcPCy7
	 /GIHTLU3TUOpEQ+JgUfOGV23/gqX7Ry9qkaN7vIRXfsQXbPMphKD7Gpx+xbueXCOI8ER+
	 n/LhhzS5bwqx3M7Asa1F26nsZRLm4gVQUOtbkxu7utT744djXto/sbDiX8b9X6af4KgkE
	 qDin7ip4k0+7pxkMzi717I+GCNC3I6OZnIpA/bNy/6IT7nkDWU3al5slGMkyNQGZSKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sEYCMpb7E+Hy2k4oWF/J6x22ipHVHDITNzlrHWABU6I=;
	b=MvhMfcH9gsKfZD4rXYXWJ3kSaibNrBRPXbr+C4Ts9RjpTO2wfDIcHiKMuubgrrQwdY5Y
	 9tPXNy5ORAjq7nyM8Z19t0D0serPBe+Ee25dPK4VAGNhhO/Qyl3PqXG5q6EOxxksqBvgN
	 XqXAHG7Bv52tavnvoIUPd4T0CIoO3lhNm7Eh9K9hdwheSAxlgAUJvvHiTtNXIOiclJwd5
	 D7xgxNSojJUO32Zra+l88ZlpoS0D6JM4914wk5ITEKTQ9RIEfaKZk3yoePn2d7yNnKNCc
	 ZI6FBD8gJTRZAceU0CA8mQ5LgDHrCZDNQ73NSbWx4gRfyUJMZ+v8ymN2HUBXGmCT7Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkLaO1c1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419BF606A31E;
	Wed, 28 Oct 2026 19:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkLaO1c1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9371A1F01828;
	Wed, 28 Oct 2026 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216271;
	bh=sEYCMpb7E+Hy2k4oWF/J6x22ipHVHDITNzlrHWABU6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkLaO1c1LNmULxqoFCwnolucJhSTw9cf9HDLoTocaygqghm74rKXvc6Ui0P24xeQM
	 5SKeahi53fY7Mi8UTXTqG2gKEr1Lgg2X/K/Z1DeMN4Ii/6lMVejsgDOIvtWlLwIoG/
	 HDIGghimGMI71OkXvSdpQbDiOr9TBoQn58lZNfVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1498/1887] s390/vfio-ap: Fix dereference matrix_mdev->kvm without checking for NULL
Date: Wed, 28 Oct 2026 17:59:54 +0100
Message-ID: <20261028170533.546885457@linuxfoundation.org>
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

From: Anthony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit d50346801b4f144e42b49cd4f1496010498ab114 ]

The ap_driver structure has two fields which are function pointers to
callbacks:

* .on_config_changed: called at the start of the AP bus scan function to
                      notify the device driver that the host AP
                      configuration has changed and the associated AP
                      devices will be added or removed accordingly. This
                      gives the implementor a chance to evaluate the
                      configuration changes and respond to them before
                      the associated devices are added or removed.

* .on_scan_complete:  Called at the end of the AP bus scan function to
                      notify the device driver that the host AP
                      configuration has changed and the AP devices have
                      been added or removed accordingly. This gives the
                      implementor the opportunity to respond to the
                      changes after the associated devices are added or
                      removed.

These two callbacks are implemented in the vfio_ap device driver via the
vfio_ap_on_cfg_changed and vfio_ap_on_scan_complete functions respectively.

Within the call stack of these two callback functions the
matrix_mdev->kvm->lock mutex is taken without checking whether
matrix_mdev->kvm is NULL or not. If matrix_mdev->kvm has never been set,
trying to take the lock will trigger a NULL pointer dereference. This patch
adds checks for matrix_mdev->kvm == NULL before taking the
matrix_mdev->kvm->lock mutex.

Note that the matrix_mdev->kvm->lock mutex taken in the
vfio_ap_mdev_hot_plug_config function is moved to the calling function
along with the matrix_dev->mdevs_lock which is needed there to access
the fields of the matrix_mdev. It makes little sense to make the change
the check for matrix_mdev->kvm there before taking the kvm->lock
mutex only to have to move it out via another patch, so it is done in
this patch.

It is important to make note of the following:
1. The matrix_dev->guests_lock is acquired at the start of both callback
   functions. This ensures that matrix_mdev will not be removed via the
   vfio_ap_mdev_remove function because it too takes matrix_dev_guests_lock
   before removing the object; so, matrix_mdev will be available for the
   duration of the callback functions.

2. The matrix_dev->mdevs_lock mutex must be taken in order to access
   fields within the matrix_mdev structure

3. matrix_mdev->kvm->lock mutex must be taken before the
   matrix_dev->mdevs_lock to prevent a lockdep splat.

4: The kvm->lock must be held while plugging the guest's AP configuration
   into its SIE state description via the vfio_ap_mdev_update_guest_apcb
   function.

5. The vfio_ap_mdev_update_guest_apcb checks matrix_mdev->kvm to verify it
   is not NULL before doing the hot plug of the guest's AP configuration.

Fixes: eeb386aeb5b7c ("s390/vfio-ap: handle config changed and scan complete notification")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 39 ++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 8f984ecef02b4..42999d0934628 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2074,8 +2074,20 @@ static void vfio_ap_mdev_cfg_remove(unsigned long *ap_remove,
 	DECLARE_BITMAP(cdrem, AP_DOMAINS);
 	int do_remove;
 
+	/*
+	 * It is safe to traverse this list here because the
+	 * required guard - matrix_dev->guests_lock - is taken in the
+	 * vfio_ap_on_cfg_changed function prior to this function getting
+	 * called.
+	 */
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
-		mutex_lock(&matrix_mdev->kvm->lock);
+		/*
+		 * The mdevs_lock must be held to access fields within matrix_mdev,
+		 * and kvm->lock must be taken before mdevs_lock to satisfy the lock
+		 * ordering requirement and prevent a lockdep splat.
+		 */
+		if (matrix_mdev->kvm)
+			mutex_lock(&matrix_mdev->kvm->lock);
 		mutex_lock(&matrix_dev->mdevs_lock);
 
 		do_remove = bitmap_and(aprem, ap_remove,
@@ -2093,7 +2105,8 @@ static void vfio_ap_mdev_cfg_remove(unsigned long *ap_remove,
 						    cdrem);
 
 		mutex_unlock(&matrix_dev->mdevs_lock);
-		mutex_unlock(&matrix_mdev->kvm->lock);
+		if (matrix_mdev->kvm)
+			mutex_unlock(&matrix_mdev->kvm->lock);
 	}
 }
 
@@ -2309,9 +2322,6 @@ static void vfio_ap_mdev_hot_plug_cfg(struct ap_matrix_mdev *matrix_mdev)
 {
 	bool filter_domains, filter_adapters, filter_cdoms, do_hotplug = false;
 
-	mutex_lock(&matrix_mdev->kvm->lock);
-	mutex_lock(&matrix_dev->mdevs_lock);
-
 	filter_adapters = bitmap_intersects(matrix_mdev->matrix.apm,
 					    matrix_mdev->apm_add, AP_DEVICES);
 	filter_domains = bitmap_intersects(matrix_mdev->matrix.aqm,
@@ -2327,9 +2337,6 @@ static void vfio_ap_mdev_hot_plug_cfg(struct ap_matrix_mdev *matrix_mdev)
 
 	if (do_hotplug)
 		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
-
-	mutex_unlock(&matrix_dev->mdevs_lock);
-	mutex_unlock(&matrix_mdev->kvm->lock);
 }
 
 void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
@@ -2340,15 +2347,29 @@ void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
 	mutex_lock(&matrix_dev->guests_lock);
 
 	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
+		/*
+		 * The mdevs_lock must be held to access fields within matrix_mdev,
+		 * and kvm->lock must be taken before mdevs_lock to satisfy the lock
+		 * ordering requirement and prevent a lockdep splat.
+		 */
+		if (matrix_mdev->kvm)
+			mutex_lock(&matrix_mdev->kvm->lock);
+		mutex_lock(&matrix_dev->mdevs_lock);
+
 		if (bitmap_empty(matrix_mdev->apm_add, AP_DEVICES) &&
 		    bitmap_empty(matrix_mdev->aqm_add, AP_DOMAINS) &&
 		    bitmap_empty(matrix_mdev->adm_add, AP_DOMAINS))
-			continue;
+			goto do_unlock;
 
 		vfio_ap_mdev_hot_plug_cfg(matrix_mdev);
 		bitmap_clear(matrix_mdev->apm_add, 0, AP_DEVICES);
 		bitmap_clear(matrix_mdev->aqm_add, 0, AP_DOMAINS);
 		bitmap_clear(matrix_mdev->adm_add, 0, AP_DOMAINS);
+
+do_unlock:
+		mutex_unlock(&matrix_dev->mdevs_lock);
+		if (matrix_mdev->kvm)
+			mutex_unlock(&matrix_mdev->kvm->lock);
 	}
 
 	mutex_unlock(&matrix_dev->guests_lock);
-- 
2.53.0



