Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB745C6E5;
	Thu, 20 Aug 2026 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243574; cv=none; b=l/hRp4e5GTo7L+rsq2DVlGpDleruihbmChGEc35f5MxKjsa4gKPmHweXptfqkqhoslvbJj1FhktMsJ0tv+KAtj2ZjTXepwiOrRmGxXOY1DcBZ+v/0bFFUEjGPXSU33xYbpJK1wkPGRPQV+rwqrYpX5/z+AZVXdNzvLax+DNs150=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243574; c=relaxed/simple;
	bh=CvhsOZ/Shlkt8RnYJLzqR/KrkTVV9n3+X4fc+5jnVek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEJ2jsFhTRzgGBflzzVo5ttgoG2mmWE8T5fKmmhLJkiiTa7a20bF/qi8fmNEbUaevEvnzHEvQeZROR3suSPlhgsspYgf9h2BYB59TAu/q9TdD5n9fbSS9IvyiYeQZ/61eoinvPKUgzfP7KlwTmObMx8RI6mw3tyIAv7o5UfnMaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfGL9OGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfGL9OGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53181F000E9;
	Thu, 20 Aug 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243573;
	bh=w1UYn7Sdtcd7Pkw+qIY7fggkQydXXfgdrK49TBOyO3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfGL9OGxhjEWYrO9C2nS381IBDB5jKxCJ0g92tR7qG6VhpVewSxCTCjuJnllens4B
	 xxKFQ8dejfJ7+Giw8qyiIaday41rpo05RfR4fqxST2sjyzpYJGWE5Ik/0aCn/Qc4Mu
	 iQP0yETI9UfnVjWqVJFHbKDYiWvxgpqcgUGheXy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 141/272] mmc: vub300: rename probe error labels
Date: Thu, 20 Aug 2026 16:55:25 +0200
Message-ID: <20260820145235.523809717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2116,19 +2116,19 @@ static int vub300_probe(struct usb_inter
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
@@ -2345,23 +2345,25 @@ static int vub300_probe(struct usb_inter
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
 


