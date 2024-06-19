Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E81714C584;
	Wed, 19 Jun 2024 13:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802101; cv=none; b=Ndzx5DbTGrw2kDyqPXJHlebaLqYOw03HFhCWqgTtypYc2cwlEtAAYHtReExnhIm2z2n92+SsMgj+Pcswu+lpNbb5/+rK1JIMMiH53uGay8QR/toHrP3iNhyuaVaqFSI/EuuJVxXOCA39nGGqBXLckFRS7HCNaO+IjkdDs01pEUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802101; c=relaxed/simple;
	bh=Ga9ETDnfSzUEKB4wt+zMPRmqos0ZG5Gf9KnsSQtPVC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtXvRPfqLqKOpL6qV7isyJ1lbeIr20SpzeCurPepyJIGkFMoWOBcf5ek1wpXpEWqZHEQOGUY1q/exbvF17JS1TeZlFWzxzXoPM7tOP0ZFmbIJRrhm7eM9bZhNsc6RJPUg3c6yC7PWnOGRr7XqiO5VbQtQXgzj1zTmAYmrnlOJQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFpdY5zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFpdY5zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F2AC2BBFC;
	Wed, 19 Jun 2024 13:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802101;
	bh=Ga9ETDnfSzUEKB4wt+zMPRmqos0ZG5Gf9KnsSQtPVC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFpdY5zRrEv7nqaXK+HLMKb35i0T+EWw0IuXC3vx6Y1Gy3veOAMpdca6BERO2cboR
	 OwdkEzKos6POikorVYO0vmPz+afVZKl+H5sRbL+7m6feiWOWH0ShnZTu/+4YNiCZRb
	 WmIwGKjz8PWdA84IaN4txf6eg25yWYdtevJ5627E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>
Subject: [PATCH 6.6 081/267] USB: xen-hcd: Traverse host/ when CONFIG_USB_XEN_HCD is selected
Date: Wed, 19 Jun 2024 14:53:52 +0200
Message-ID: <20240619125609.460822548@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


