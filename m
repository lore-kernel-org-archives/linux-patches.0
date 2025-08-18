Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9E131E103;
	Mon, 18 Aug 2025 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522386; cv=none; b=KlN0CuKIuhwjT13WQOvlKGb8cOZrMtHXKt4KcMn9KdOneDANomjfEsJoOcAHbaQN7kxwX5Sald8Bw1bTa1i5UsTZea1zj4azwCmTfmBSsrF5A3cPV6zIH+4QfToE6hqhr3hpfAygEQFHeuH88QbLWHSDjs001dj4YR9UAJ5hqZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522386; c=relaxed/simple;
	bh=IFTt7czDDgjNqYmvogi2ausPPR9oKdJ2o64YxMZhnwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+knLhAe4pWQqy9YFE2QzBqadHcowATLnKRZ0t4uuuX3I6anX+RA7/qr5N1d5jrooBkrckuuuO1+2tZMyPR04XFwDMTM1sBCkGC8RbegmFAUwU27rb+BAVDbLy2euq2kJRDs9OjVFVhK328P3mOZxe1FWJZp+xDa9EHkgqpqVHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueRBNYwO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueRBNYwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB659C4CEEB;
	Mon, 18 Aug 2025 13:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522385;
	bh=IFTt7czDDgjNqYmvogi2ausPPR9oKdJ2o64YxMZhnwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueRBNYwOmIvIuNOjj9Irz/bkE+Htn6lUZwKoQMXicN6B8zOybgRxIIISc5dvKrxZ2
	 p/W2Vc3CcILxQpujngWzqu8jjTtbEAKQWG4us65cH8PigeXl8gY9GFCZF8nAYBeFY+
	 RGTlL1WS4sS8U8c8tByJM0NFoVrZEO9/Yhpk2QR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/444] media: ipu-bridge: Add _HID for OV5670
Date: Mon, 18 Aug 2025 14:45:27 +0200
Message-ID: <20250818124500.235752448@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a0e9a71580b5..4e921c751629 100644
--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -59,6 +59,8 @@ static const struct ipu_sensor_config ipu_supported_sensors[] = {
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



