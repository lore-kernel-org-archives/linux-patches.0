Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119C833D50F;
	Tue,  6 Jan 2026 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722595; cv=none; b=r5Tmv1Di1lLY/KvVJQTUTMBg4mXFUuZGHmMUC+cRJmMdhspMht/+t2z3WqGpcYAMciCE6rH/M5GAhdzW+0OXIkpBDX5TreNr5tpREAipOo7EN0bndW3oLjc54hNmd90P9Jk0VpXcjedIZ3VPUtoqtZ/eFEt1DdgAxE/GQSmQ6hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722595; c=relaxed/simple;
	bh=8CtP+WDRh0D3wV66rnDjdruzzCVFL7UyjhUN5pno06Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb566K8cG8DofQC9YcGCpdMdNg8pBdHP0PExi6XATPs6OD6ZWBZl2S+L7G97HC1lbc/IoME6bbyVO2aJ1v6lnH43jlaHG4L5e8xZ/HKUroEx5dRGJh/am8setfBNvDQf+uThKkcbDS4kavThdVLKzjuYHqJYtV+IpfAWKs/1PoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3Poykep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3Poykep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF85C116C6;
	Tue,  6 Jan 2026 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722594;
	bh=8CtP+WDRh0D3wV66rnDjdruzzCVFL7UyjhUN5pno06Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3PoykepUsjffZvkDkXZa5BrE42geN8hdJsN20dZNDWjdHXPdt7hkeXXFMtk5CYHu
	 gVYHi1UOvFI/VJ3bvhgFpykutVmaYASuXxePY1kvu+ebLNtdBs6xg4rR2vzEU0IIlP
	 YniP/3fVX+GWZfn1Lw6Qi07iK4zw474ifhMLb+WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>
Subject: [PATCH 6.18 312/312] [PATCH v2] Revert "gpio: swnode: dont use the swnodes name as the key for GPIO lookup"
Date: Tue,  6 Jan 2026 18:06:26 +0100
Message-ID: <20260106170559.148390086@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

This reverts commit e5d527be7e6984882306b49c067f1fec18920735.

This software node change doesn't actually fix any current issues
with the kernel, it is an improvement to the lookup process rather
than fixing a live bug. It also causes a couple of regressions with
shipping laptops, which relied on the label based lookup.

There is a fix for the regressions in mainline, the first 5 patches
of [1]. However, those patches are fairly substantial changes and
given the patch causing the regression doesn't actually fix a bug
it seems better to just revert it in stable.

CC: stable@vger.kernel.org # 6.18
Link: https://lore.kernel.org/linux-sound/20251120-reset-gpios-swnodes-v7-0-a100493a0f4b@linaro.org/ [1]
Closes: https://github.com/thesofproject/linux/issues/5599
Closes: https://github.com/thesofproject/linux/issues/5603
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-swnode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-swnode.c
+++ b/drivers/gpio/gpiolib-swnode.c
@@ -41,7 +41,7 @@ static struct gpio_device *swnode_get_gp
 	    !strcmp(gdev_node->name, GPIOLIB_SWNODE_UNDEFINED_NAME))
 		return ERR_PTR(-ENOENT);
 
-	gdev = gpio_device_find_by_fwnode(fwnode);
+	gdev = gpio_device_find_by_label(gdev_node->name);
 	return gdev ?: ERR_PTR(-EPROBE_DEFER);
 }
 


