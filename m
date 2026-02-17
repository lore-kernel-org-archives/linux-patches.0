Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DBF377563;
	Tue, 17 Feb 2026 20:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360811; cv=none; b=W3QNGb+vBc/7YMsXiPsxbfT9Z1kaSSwG7u4tyxOGf6oey3m205OmNo7rRZ6S4iJdWFmESb3oLbLoaQpO5onknTiW+EYWJ3ScKNUUEwgXM8ac2IC2e5XWyh3Z34wOzM+Fq17lw6/L0cY+6i5AM+mA1oIUs6XgL1wYxCHZZcWBQK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360811; c=relaxed/simple;
	bh=mPWKDDc+28LxiA4LRofoQh+xmaFt1YIv7kcv82CEuIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abM6m83wfm+b1mJ7rRhSwpnleiLdvWk9dIzsRhQIfJwN+iFI9H52lbI4BqnKYiju6PBcN5l3qZLzqked78Bkgpnf/4++N8bKaxeI49d21FyAJ0mFugvMS+V7JZev2hHrkWUK3mex72iyVEmgBj5Oo3S9/SY7xHUH+Sw2ziclatc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUbuVkKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUbuVkKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C24C4CEF7;
	Tue, 17 Feb 2026 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360811;
	bh=mPWKDDc+28LxiA4LRofoQh+xmaFt1YIv7kcv82CEuIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUbuVkKgjNYSo9LjC6q7F6q8nJPnVZ3gcSZly9ayQh5w/deBJSbJ3dOMEF1IqS4MZ
	 VZbG6UGKla8hsy2BliR4H7TzfYgZ5BzCtjDRlGMO3KpmtBReDpxGfL2qf8L6l7MwaW
	 /Rw4dVGr+dTZWv6APx1qqOge6bxJqij5IwLdiX3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/39] bus: fsl-mc: Replace snprintf and sprintf with sysfs_emit in sysfs show functions
Date: Tue, 17 Feb 2026 21:30:26 +0100
Message-ID: <20260217200004.395444985@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

[ Upstream commit a50522c805a6c575c80f41b04706e084d814e116 ]

Use sysfs_emit() instead of snprintf()/sprintf()  when writing
to sysfs buffers, as recommended by the kernel documentation.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250822124339.1739290-1-chelsyratnawat2001@gmail.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Stable-dep-of: 148891e95014 ("bus: fsl-mc: fix use-after-free in driver_override_show()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -175,8 +175,8 @@ static ssize_t modalias_show(struct devi
 {
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
 
-	return sprintf(buf, "fsl-mc:v%08Xd%s\n", mc_dev->obj_desc.vendor,
-		       mc_dev->obj_desc.type);
+	return sysfs_emit(buf, "fsl-mc:v%08Xd%s\n", mc_dev->obj_desc.vendor,
+			mc_dev->obj_desc.type);
 }
 static DEVICE_ATTR_RO(modalias);
 
@@ -202,7 +202,7 @@ static ssize_t driver_override_show(stru
 {
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", mc_dev->driver_override);
+	return sysfs_emit(buf, "%s\n", mc_dev->driver_override);
 }
 static DEVICE_ATTR_RW(driver_override);
 


