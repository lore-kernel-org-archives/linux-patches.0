Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193414375A;
	Wed, 19 Jun 2024 13:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802896; cv=none; b=GxAoAUZscskIxx/U3IprCAkLXyTlBFOoVBQxlexk7fNOxH2NCgsmX3T8Ns8uWeixYVhVsLqxKOqbTcYaSwFVdZztsqya599FzM1DOsijbZgdtc9DAvn9MhDK9WcNEAoF4uk2c+6N6SM886yWO9NnsuAgeWxI3l8qVYTOCBAKb8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802896; c=relaxed/simple;
	bh=7EBfyLt0lzdzqLeaTqtu6WcWcjZRi/pJCevNGtqAWmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9wPNpgK2YC4Ny5WvoVbuN0v7DLILq5VZcQ2NxVfw5DW29H/+iszYDMoUAUu8Gtel3LBhRxMEH0rR3DgmULJ04Wy/TiK18pm9/HzIedd14J7Xe45vJ4cuxso6mp4UFsriSs17mYUmug7gBgDaqJXYvwJJNJb5TXFVLeptvcbwVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGHc4GMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGHc4GMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114A5C2BBFC;
	Wed, 19 Jun 2024 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802895;
	bh=7EBfyLt0lzdzqLeaTqtu6WcWcjZRi/pJCevNGtqAWmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGHc4GMfUX1oTPg2+hzneD+Q9kmkgMIAbpoUVQc008Eeb85yS/QNXP4AKJ+wMrV6i
	 gBacooRP+ET9GJWKrr3fhCmR8JFy8bd5ic89Pok83KbernwPVmYW8BmBIx9HTSMMUv
	 DRN8FBIzOmIot0PTo0/rW/COTLd1i0LkuB+JU2Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>
Subject: [PATCH 6.9 084/281] USB: xen-hcd: Traverse host/ when CONFIG_USB_XEN_HCD is selected
Date: Wed, 19 Jun 2024 14:54:03 +0200
Message-ID: <20240619125613.073858748@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ernberg <john.ernberg@actia.se>

commit 8475ffcfb381a77075562207ce08552414a80326 upstream.

If no other USB HCDs are selected when compiling a small pure virutal
machine, the Xen HCD driver cannot be built.

Fix it by traversing down host/ if CONFIG_USB_XEN_HCD is selected.

Fixes: 494ed3997d75 ("usb: Introduce Xen pvUSB frontend (xen hcd)")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: John Ernberg <john.ernberg@actia.se>
Link: https://lore.kernel.org/r/20240517114345.1190755-1-john.ernberg@actia.se
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_USB_R8A66597_HCD)	+= host/
 obj-$(CONFIG_USB_FSL_USB2)	+= host/
 obj-$(CONFIG_USB_FOTG210_HCD)	+= host/
 obj-$(CONFIG_USB_MAX3421_HCD)	+= host/
+obj-$(CONFIG_USB_XEN_HCD)	+= host/
 
 obj-$(CONFIG_USB_C67X00_HCD)	+= c67x00/
 


