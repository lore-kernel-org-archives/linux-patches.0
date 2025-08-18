Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03C2C235D;
	Mon, 18 Aug 2025 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524099; cv=none; b=MXesTSp744JmaAA/QrwGpPe4QnDG/8xGNjMJUkw3mis7wwhAVjMcl8lx//cbJQTj07Oc9SQqrpE9LLDk+QV5D2VkPXxH1xngizGZRL7vTreMYFrt2z5QhbX4FrBjElaVJ5BRNZy6D9mxs3eW+qpAoR2obSjSvN04AFvmtoz5Zu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524099; c=relaxed/simple;
	bh=/iQtkEqWwP+KIfmf5vHtNL7CiqJLdY8nEYTEQJ7UiMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbJ+88scl55lrv2CxDXkMqWOGxJfc6BktHNe2VVP9YCA/z4xVWS1FHTMpuDmoJuuwLD1/SPINwppFLeTc+/rXujAkDTYt51UtFcyKY/uUxxQ757sGSDpzVqiwRc1VrzyoSOP4T1fKjMvmWyxho9DZeJgFMNczcE5xvWtSkM+HJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMkNPRhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMkNPRhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C13C4CEEB;
	Mon, 18 Aug 2025 13:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524098;
	bh=/iQtkEqWwP+KIfmf5vHtNL7CiqJLdY8nEYTEQJ7UiMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMkNPRhJukJw3Kx1QGuTN9xGX6ZsG8IiwCBtUM8NXZLnZVAqf/X3+9nY/zQyn5V9b
	 xL0/0V6N/es3Gyzk6HrHaHiNhggMoX+xsRxDkN5L6PtFCmjnHQatMF8lrENqcfKrhv
	 nWOeYVOXbj416jLR3AT/D0Em4mkp1+bI4qiZJ5HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 360/515] media: ipu-bridge: Add _HID for OV5670
Date: Mon, 18 Aug 2025 14:45:46 +0200
Message-ID: <20250818124512.267138706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit 484f8bec3ddb453321ef0b8621c25de6ce3d0302 ]

The OV5670 is found on Dell 7212 tablets paired with an IPU3 ISP
and needs to be connected by the ipu-bridge. Add it to the list
of supported devices.

Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu-bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/intel/ipu-bridge.c b/drivers/media/pci/intel/ipu-bridge.c
index 1cb745855600..a081e44d786e 100644
--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -60,6 +60,8 @@ static const struct ipu_sensor_config ipu_supported_sensors[] = {
 	IPU_SENSOR_CONFIG("INT33BE", 1, 419200000),
 	/* Omnivision OV2740 */
 	IPU_SENSOR_CONFIG("INT3474", 1, 180000000),
+	/* Omnivision OV5670 */
+	IPU_SENSOR_CONFIG("INT3479", 1, 422400000),
 	/* Omnivision OV8865 */
 	IPU_SENSOR_CONFIG("INT347A", 1, 360000000),
 	/* Omnivision OV7251 */
-- 
2.39.5



