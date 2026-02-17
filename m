Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAE4374178;
	Tue, 17 Feb 2026 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361048; cv=none; b=suF70rIgNHvkiTkpL4olleV2W+pum7TNY7WgcC/x3iSWlJfLI85yNmGt2ykYhHmkEdmOT+lNHum/dBXuTgjWCt/MqPdTHktXzVaBxhfJ7cyqJEootoD17X4+yIA0w5cF0chHIHdq+/RW/pCg7QUXEK/3KO4UA9eKnhrORHA8LV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361048; c=relaxed/simple;
	bh=xSoJiNUSSxTFj8Pbig/+n+E5v6rjxo9OEzHzCdmJK5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHN1Qv7Yi/RFI1qBBL4AKwtc8Tufut3XmF9s3KgDiVg9+/tTFyRe2paFdMsSj4PTm/JCzN7rgCikrsHjHaaF+YqyakX+F/yVy75L89Vd7aiN7olr7NRnuJEmE/e95RP7ZUYiPCpF2cdVdU9w5eIoPaJhsA6j6ymb1M6a6u8DaoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRmZidKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRmZidKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A03C4CEF7;
	Tue, 17 Feb 2026 20:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361048;
	bh=xSoJiNUSSxTFj8Pbig/+n+E5v6rjxo9OEzHzCdmJK5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRmZidKfZIDPNe6eQ8mZhBeefF67jlRD2mv30apX45HklFx4XGrVR0drBZVUhmg9S
	 PMdyIpSxyu625fWqiSP5+wc6yvuD/NBeYdIrKa9bJgXxHGhyA/mJkBhu3HzEu53WPY
	 8hRzCxw186yQESffTZyzG/Sri8siDCfQELN+Q4dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/39] bus: fsl-mc: Replace snprintf and sprintf with sysfs_emit in sysfs show functions
Date: Tue, 17 Feb 2026 21:31:34 +0100
Message-ID: <20260217200003.900682766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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
@@ -156,8 +156,8 @@ static ssize_t modalias_show(struct devi
 {
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
 
-	return sprintf(buf, "fsl-mc:v%08Xd%s\n", mc_dev->obj_desc.vendor,
-		       mc_dev->obj_desc.type);
+	return sysfs_emit(buf, "fsl-mc:v%08Xd%s\n", mc_dev->obj_desc.vendor,
+			mc_dev->obj_desc.type);
 }
 static DEVICE_ATTR_RO(modalias);
 
@@ -200,7 +200,7 @@ static ssize_t driver_override_show(stru
 {
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", mc_dev->driver_override);
+	return sysfs_emit(buf, "%s\n", mc_dev->driver_override);
 }
 static DEVICE_ATTR_RW(driver_override);
 


