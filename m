Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E2744AB85;
	Thu, 30 Jul 2026 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428260; cv=none; b=X0IExwfno8MxMQh1HqaytNfHeHqVHPR8TGfXCja/DieEnVlS1YyDgcvk3mN9zXf27zS5ixeqggn6xchSsD5bl3FWDet+Dhh8bMZVm1aCmocQ7WkR83CvOTr0mcb3O5jK/t6KnDItQAlrvp2rsJKdcEt6Qi+kKCo3xOEzpQ94Tjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428260; c=relaxed/simple;
	bh=er6dcvyy3K2qEwqKyXjfws2n/6h179x4CnFm4E5PteQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmmQC/y4hjN5rukdF7KkC8SgFdCOtgDzQkGj9wj9ZAJ+TC/WfZ06/CCEWBanjCqmawfT+pmJ1zABc4bZ4E8P2pJzDkgTqnv0XvzfE47hWZY4tI31XGrHCIlA8jMqGnhvRe7+A1bIOyIXnnoth4CLGV9GySF75hqGS/3bBnou8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pFAWhdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pFAWhdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A56E1F000E9;
	Thu, 30 Jul 2026 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428259;
	bh=6nWVSex7/mOq4RIFHRKc+yn3Jj3DGq2Vb0jRJC5n7EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pFAWhdnTkE/bpa9nrGH/TOQqriS7hQI/EJrOLvf/ljaO0oxiIFze1p9f0Uborou0
	 6GXWwtP12SwC5BLp+/PKF30SSrzp846Q4OvzrIJAfNQSdMlJQ6g9q+mFqJkOKWRrRO
	 g6x9Em/TLnIaFtQ1jeKGrL2lj80J9ifOzXD5bf6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 457/484] mmc: vub300: rename probe error labels
Date: Thu, 30 Jul 2026 16:15:54 +0200
Message-ID: <20260730141433.412479055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

Error labels should be named after what they do.

Rename the probe error labels.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
(cherry picked from commit 5b8b35d6f4fa758dd5e8ae18526ea1c73f6787e0)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2114,19 +2114,19 @@ static int vub300_probe(struct usb_inter
 	command_out_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!command_out_urb) {
 		retval = -ENOMEM;
-		goto error0;
+		goto err_put_udev;
 	}
 	command_res_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!command_res_urb) {
 		retval = -ENOMEM;
-		goto error1;
+		goto err_free_out_urb;
 	}
 	/* this also allocates memory for our VUB300 mmc host device */
 	mmc = mmc_alloc_host(sizeof(struct vub300_mmc_host), &udev->dev);
 	if (!mmc) {
 		retval = -ENOMEM;
 		dev_err(&udev->dev, "not enough memory for the mmc_host\n");
-		goto error4;
+		goto err_free_res_urb;
 	}
 	/* MMC core transfer sizes tunable parameters */
 	mmc->caps = 0;
@@ -2343,23 +2343,25 @@ static int vub300_probe(struct usb_inter
 			 interface_to_InterfaceNumber(interface));
 	retval = mmc_add_host(mmc);
 	if (retval)
-		goto error6;
+		goto err_delete_timer;
 
 	return 0;
-error6:
-	del_timer_sync(&vub300->inactivity_timer);
+
+err_delete_timer:
+	timer_delete_sync(&vub300->inactivity_timer);
 err_free_host:
 	mmc_free_host(mmc);
 	/*
 	 * and hence also frees vub300
 	 * which is contained at the end of struct mmc
 	 */
-error4:
+err_free_res_urb:
 	usb_free_urb(command_res_urb);
-error1:
+err_free_out_urb:
 	usb_free_urb(command_out_urb);
-error0:
+err_put_udev:
 	usb_put_dev(udev);
+
 	return retval;
 }
 


