Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD5433438F;
	Thu, 30 Jul 2026 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425256; cv=none; b=QinoS8JQW6gc86HR4Z4Wq0zpMr5K3Zx9OsyPp3m+xdfPswhe/jbl8bJ014xzsBpVvXVYBdT4VTTdd3AYKWbq/Wp8c6CCcuvkK4wRX4Yp/qU0qdgSkG96Y3YohY6ZzwUCMjYt1EGjKBC6SUIi1QTSJcUUOmJXEsxeY4LXow5LxeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425256; c=relaxed/simple;
	bh=+1/jyWKsXlLLDX96T3eWzEBedZY9FpmhVL0Kmdx0F/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDZOWLiMHkmEWyUD7lqqDPt0t19nEJQXNP0DaWxYdp9GAD/b++HJKOxYpzx9U0dt/6JjQ3XULQxNQ2qQd6NmXmYQG/4QMdw3TixSt0rfM8PYDVKLHqnU5rhmKjuGPdKHaKojjKs7CxQOYcvdfvxJVJA3fg8bflZ0YZs18+0luaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7Yq8R+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7Yq8R+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DD41F000E9;
	Thu, 30 Jul 2026 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425255;
	bh=cckyC2srVqAPLNLFahxEocDQoDx9mneLI3+z9s2RdHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7Yq8R+02AgoItTdnQRIx4Iu9hU4CSZ5PC4T9BQfghbIN/YeJ2MVN7OHinVwyu6f/
	 FDaZBURhZ0mwuhn6eTZxxA1xQLfvpfk4Ykxr7n1HU+TkXChHT2he7hWlOq1qZZjzl0
	 l/Tr8fOmHnj/qgBMaeTe6GEgwtqcIK7WcTmYZcqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 647/675] mmc: vub300: rename probe error labels
Date: Thu, 30 Jul 2026 16:16:17 +0200
Message-ID: <20260730141458.888139275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5b8b35d6f4fa758dd5e8ae18526ea1c73f6787e0 ]

Error labels should be named after what they do.

Rename the probe error labels.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: a3b5f242997a ("mmc: vub300: fix use-after-free on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2115,19 +2115,19 @@ static int vub300_probe(struct usb_inter
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
 	mmc = mmc_alloc_host(sizeof(*vub300), &udev->dev);
 	if (!mmc) {
 		retval = -ENOMEM;
 		dev_err(&udev->dev, "not enough memory for the mmc_host\n");
-		goto error4;
+		goto err_free_res_urb;
 	}
 	/* MMC core transfer sizes tunable parameters */
 	mmc->caps = 0;
@@ -2344,10 +2344,11 @@ static int vub300_probe(struct usb_inter
 			 interface_to_InterfaceNumber(interface));
 	retval = mmc_add_host(mmc);
 	if (retval)
-		goto error6;
+		goto err_delete_timer;
 
 	return 0;
-error6:
+
+err_delete_timer:
 	timer_delete_sync(&vub300->inactivity_timer);
 err_free_host:
 	mmc_free_host(mmc);
@@ -2355,12 +2356,13 @@ err_free_host:
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
 


