Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212295;
	b=wxBJfs+JdzitcbatsJDNHcPTFrYTWF49fWGn4FnEFDZApJSO3VufqQUdR2ng3FY9LNn1
	 jjPAuuNMJLA1b3SMg+NbV4c2ZHWJtvb+Pc20CHXq5ZTH2KCxViHuUdVP1KcSbHzQ8MPDh
	 nJMkrIqLBpon2RXx0xWsRuLmfaUponzFMKKoidT+0b9PbDu0pzbl0iexJyH70y4Mf4XLr
	 u6KM1S5N0bh0jj2EJWZtn+Wp8Mjsc6VnSszv+dppec2Wyt4Xt3+nm2f694/++LDeSo5D9
	 imyTowtm5a6+73XAZFjkjPlB30PyHMEzCMN8ZSYiYTFJMYgEpB22c8cPCFV9mverMVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ll+is3QDCjkLmul51wzTu1tNLLDR0KD9XlJ/veL1Bvg=;
	b=QKtz87iztwTHNFHAWZsmR+vQGhCj37FUWcxPTv2wffITKR9uQVdudr09e9kXcXgmuB62
	 9toPUukzMrOu2GWnnjwT30lmyKJ9AHX1Vs8Hv5FGn2ObuUOjn4wjEEhdOE5oh8fA6Gdsd
	 512mtjdO0OQY83OZFzmE6Tg8GMvdRMWn/yKQXFpNivbOkj2NeOdsZ+svq6U6NdmSsqbVa
	 jYrE0Pqdy96AHzf5cYPIyVJkE4bdQSGE2zHVztHqWuxviYJBWlo7uj2TCCT3oy6riGqLV
	 brRnbB9dLpSthDp/APZKBSmweSx3PRfueY+Jnrk/KMr7CzTPi4Hs+9zm3Jb3QQhJJ+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9hIwaUH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F38606A31A;
	Wed, 28 Oct 2026 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9hIwaUH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284E91F01825;
	Wed, 28 Oct 2026 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212294;
	bh=ll+is3QDCjkLmul51wzTu1tNLLDR0KD9XlJ/veL1Bvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9hIwaUHSojJlf1ufKoxoAjB/GHmN4ve+JHmwzX9vr9dQYrER141YGsHZTLgEV4k1
	 zmelZT2OGlu63FTMd7F3Gw+8CzxOUc+Z56ZmAmGW0+HX5JUcs6/PoL2DET6lNXgt12
	 dB0i4VcfJc1mLg184xWRiHk8+XG+mBjD6QGBreMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0103/1887] s390/vfio-ap: Fix NULL deref in status_show() during queue probe
Date: Wed, 28 Oct 2026 17:36:39 +0100
Message-ID: <20261028170501.578075506@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit dd6f4ef6f8a37412909ad787c837332fb070159c ]

When vfio_ap_mdev_probe_queue() creates the sysfs attribute group,
the queue's driver data has not yet been set. A concurrent read of
the 'status' attribute can therefore call dev_get_drvdata() and
get NULL, which is then passed directly to
vfio_ap_mdev_for_queue() where q->apqn is unconditionally
dereferenced, causing a NULL pointer dereference.

Fix this by acquiring the update locks before calling
sysfs_create_group(). The status_show() function acquires
guests_lock before reading the driver data, so any concurrent
read will block until after dev_set_drvdata() has been called
and the update locks are released.

As a bonus, the APQN no longer needs to be read from the queue
struct after allocation — it can be read directly from apdev
before allocation and stored in a local variable, which is then
assigned to q->apqn once the allocation succeeds.

Fixes: 260f3ea141382 ("s390/vfio-ap: move probe and remove callbacks to vfio_ap_ops.c")
Cc: stable@vger.kernel.org
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[ Adjusted queue-initialization context because Linux 6.1 lacks the newer reset fields. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 33 +++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 34dfe7493173e..0d884f340dc1c 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1768,6 +1768,23 @@ static ssize_t status_show(struct device *dev,
 
 	mutex_lock(&matrix_dev->mdevs_lock);
 	q = dev_get_drvdata(&apdev->device);
+
+	/*
+	 * Make sure the drvdata has been set before proceeding. There is a
+	 * possibility that the drvdata was not set if the vfio_ap_queue object
+	 * could not be allocated when the queue device was probed. In that case,
+	 * the locks used in vfio_ap_mdev_probe_queue() are released prior to
+	 * removing the sysfs status attribute to avoid a lockdep
+	 * splat. That opens a very small window where the status attribute is
+	 * still available without the vfio_ap_queue object having been
+	 * stored in the device drvdata. In that case, indicate the queue is not
+	 * assigned.
+	 */
+	if (!q) {
+		nchars = sysfs_emit(buf, "%s\n", AP_QUEUE_UNASSIGNED);
+		goto done;
+	}
+
 	matrix_mdev = vfio_ap_mdev_for_queue(q);
 
 	/* If the queue is assigned to the matrix mediated device, then
@@ -1795,6 +1812,7 @@ static ssize_t status_show(struct device *dev,
 				   AP_QUEUE_UNASSIGNED);
 	}
 
+done:
 	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
@@ -1864,13 +1882,16 @@ void vfio_ap_mdev_unregister(void)
 
 int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 {
-	int ret;
+	int ret, apqn;
 	struct vfio_ap_queue *q;
 	struct ap_matrix_mdev *matrix_mdev;
 
+	apqn = to_ap_queue(&apdev->device)->qid;
+	matrix_mdev = get_update_locks_by_apqn(apqn);
+
 	ret = sysfs_create_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	if (ret)
-		return ret;
+		goto err_release_locks;
 
 	q = kzalloc(sizeof(*q), GFP_KERNEL);
 	if (!q) {
@@ -1878,9 +1899,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 		goto err_remove_group;
 	}
 
-	q->apqn = to_ap_queue(&apdev->device)->qid;
+	q->apqn = apqn;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
-	matrix_mdev = get_update_locks_by_apqn(q->apqn);
 
 	if (matrix_mdev) {
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
@@ -1907,8 +1927,13 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	return 0;
 
 err_remove_group:
+	release_update_locks_for_mdev(matrix_mdev);
 	sysfs_remove_group(&apdev->device.kobj, &vfio_queue_attr_group);
 	return ret;
+
+err_release_locks:
+	release_update_locks_for_mdev(matrix_mdev);
+	return ret;
 }
 
 void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
-- 
2.53.0



