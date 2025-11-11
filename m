Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709F72E7182;
	Tue, 11 Nov 2025 01:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823245; cv=none; b=gS6F/E/0nr7Mlcu36nZKTQv6D1YM5XhJUzdhW4zw8OO39r72vyQA2x1PQMVJ9gKbBjKjlNKxIAaL7/pHpzN+7ks3Q3ZhHa+TAeDJFbXlkG4G6c6gSoGj1Ab69/Xqi742PP9IHPun8sKSfZxWj0t+kZTlVp0LcTts3O+PK7o8EcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823245; c=relaxed/simple;
	bh=IEkrwRlz6BaqkqwniGWJ5vn+qmRNSxc0ZqT0tu5855E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEldj8m6PxzDC2dMSAUi0rJ3mn5FEsgjWMJEmQUv8TAsslHVqtUDSCebnNstLrtZFkmxJOx1AG318V0y60ru96GBJSk9uWUrCXNrlPMXkn7b84SgA/ZFXWRIKf84b2dfgwgypg932BWhBmftHXghiI+3myfgIdzYr3d8N9L3PH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QpGxG/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QpGxG/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5F9C4CEFB;
	Tue, 11 Nov 2025 01:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823245;
	bh=IEkrwRlz6BaqkqwniGWJ5vn+qmRNSxc0ZqT0tu5855E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QpGxG/WkFbOOQgs3NppVsBAreYgvdwlgddKoiN2Rg8NJkpA6ckR65MtmP4s/PsfK
	 0nEASFdxpqtz8B7ZPF3ZWo6HTdQk5akM8LeC3Z+GuQHcPmkfWgN48gg/cdJP9Q1rqG
	 w4hNO9mYske05VWE0LO/cxYXTxAtzx5ME5OOh3N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/565] media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR
Date: Tue, 11 Nov 2025 09:41:00 +0900
Message-ID: <20251111004531.516742303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Mehdi Djait <mehdi.djait@linux.intel.com>

[ Upstream commit 2d240b124cc9df62ccccee6054bc3d1d19018758 ]

Both ACPI and DT-based systems are required to obtain the external
camera sensor clock using the new devm_v4l2_sensor_clk_get() helper
function.

Ensure a dependency on HAVE_CLK when config VIDEO_CAMERA_SENSOR is
enabled.

Signed-off-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 85ecb2aeefdbf..5cb596f38de33 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -27,7 +27,7 @@ config VIDEO_IR_I2C
 
 menuconfig VIDEO_CAMERA_SENSOR
 	bool "Camera sensor devices"
-	depends on MEDIA_CAMERA_SUPPORT && I2C
+	depends on MEDIA_CAMERA_SUPPORT && I2C && HAVE_CLK
 	select MEDIA_CONTROLLER
 	select V4L2_FWNODE
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.51.0



