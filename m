Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8AF3D75CE;
	Mon,  4 May 2026 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903010; cv=none; b=eUIOz9BZbcQ0NG1H2BKcmKIarnPK4mJBRGDCCgxyWlNKetLLt2pt/HfZmYcSXYfFMj19cGKi1vDZgtU8uPIz+X7ls4Lnlie88cOYK6Hfr1ea10i2jt6lHzmN3XHoRKE+RT3ylDDxG8MtuOb0Kwkos8kHTqw9hEWIrrQ1+eduYdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903010; c=relaxed/simple;
	bh=Z3SE2iXMJdkU9eoNd8IpMqcHmBQiEnelcio+IvFBgdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZUciq4j5NXPgG077TtrsWLN1gU7DY7lFQmXvcJulfU7+pqEC1VeTmJDJnOI0pB+icw2on8uMufkJG7zDUeT2Jz2mPW3IIoadd6X/dP239qLvPQYYMX+csjGhHyvKpa0IZCRCdCAVMbhWVMLyOSSasXweztZ7YfeO86Tkrj8n7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mfFXQRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mfFXQRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82A1C2BCB8;
	Mon,  4 May 2026 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903010;
	bh=Z3SE2iXMJdkU9eoNd8IpMqcHmBQiEnelcio+IvFBgdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mfFXQRe0je1s+tizWYKv9/qDFVrGvPKoJPC8uUpD8I0v4wxupniho3yIKD+wSezz
	 iTm5HJENr9+YpYY0EjVRGAeW/bbR3nncCVDE0UCurxD6qShcEaf0o5PSLtvlu5bGHO
	 JoBKwyeJW5wIFHrZzGcVMmkwflvf72+Jy3T02YnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 7.0 036/307] vfio/xe: Add a missing vfio_pci_core_release_dev()
Date: Mon,  4 May 2026 15:48:41 +0200
Message-ID: <20260504135144.183237989@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Winiarski <michal.winiarski@intel.com>

commit 493c7eff3c2ffa94ce3c5e62172948a1e38b491e upstream.

The driver is implementing its own .release(), which means that it needs
to call vfio_pci_core_release_dev().
Add the missing call.

Fixes: 1f5556ec8b9ef ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
Reported-by: Niklas Schnelle <schnelle@linux.ibm.com>
Closes: https://lore.kernel.org/kvm/408e262c507e8fd628a71e39904fedd99fa0ee8e.camel@linux.ibm.com/
Cc: stable@vger.kernel.org
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260410224948.900550-2-michal.winiarski@intel.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/xe/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vfio/pci/xe/main.c
+++ b/drivers/vfio/pci/xe/main.c
@@ -504,6 +504,7 @@ static void xe_vfio_pci_release_dev(stru
 		container_of(core_vdev, struct xe_vfio_pci_core_device, core_device.vdev);
 
 	mutex_destroy(&xe_vdev->state_mutex);
+	vfio_pci_core_release_dev(core_vdev);
 }
 
 static const struct vfio_device_ops xe_vfio_pci_ops = {


