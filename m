Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456153AAF43;
	Sat, 17 Oct 2026 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254520; cv=none; b=UaFYgPjgogo+Kgqyo0TB79hNaKD51WjtqmTMWuHhtU3+o1w6o6OEGSGRUd1o00Epv3xjq7WunKCcyjuDu8dHDB8yBS5js1j9BybDqRZxGOu2vUbQtZw613/m4tLHCwdAtFA3USlEGhutpm/9A6imCTkN753wq/18Y+R7hB0mvv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254520; c=relaxed/simple;
	bh=kM1G8QbC3NYsnAyn4MUFWFzrYqbUHiayB1JiQV52oDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7+jKGrIwJJYURImVUs/e2sX29RafGC1JGmf4OpO9sAkwJdq3krhlt8dAd5QgXuGC0ibas08bHKCgr07XcdJ5B0ZOD66pYltP1GNmnvZPkwB1whHfcRxWc21mpoT04mWaQbWtsSLKT3XY6XzwbzmpLLpzdvBk0fxJfvRhZV0Xos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+o+1btE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+o+1btE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128321F000C5;
	Sat, 17 Oct 2026 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254516;
	bh=76rQ9b076ZHQ4Ne8W+a1/unrPpe7kBtIEpntAzmm7EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+o+1btELIpq8wpD0IUxcsie6Vca4DwG9oE/UfYvGNMEdIu7KbU/CqkfebBxPqO4p
	 emAzN4hY2iqw7E2A7eV/6kUA+C9rVL/UvRSsD6fonnh61OdSSDlRnkenfEpu6ZXbAB
	 tJv7aiwZamqu5os116zpGZNBWGhtQCabdO4ZHqAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 423/869] mmc: vub300: rename probe error labels
Date: Sat, 17 Oct 2026 17:54:24 +0200
Message-ID: <20261017160047.982107950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5b8b35d6f4fa758dd5e8ae18526ea1c73f6787e0 ]

Error labels should be named after what they do.

Rename the probe error labels.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: a3b5f242997a ("mmc: vub300: fix use-after-free on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/vub300.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 937b9644f958c..73d4af7e9b32c 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2115,19 +2115,19 @@ static int vub300_probe(struct usb_interface *interface,
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
@@ -2356,12 +2356,13 @@ static int vub300_probe(struct usb_interface *interface,
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
 
-- 
2.53.0



