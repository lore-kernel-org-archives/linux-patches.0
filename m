Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214377;
	b=wb8qAjj/zB8Xhn8fo9bTWCTzO0uViPxPDXdTQLkSFwgBgs6o4nKiFXbrObJBgjrRQ26k
	 9pCezgsknMbYXyCtGPIx9b1vAskauYB4KSYcP3aMld/XWQoPxwbzdL6ba1Ft/GX56JgwO
	 Z6Skp5j4RQKyhDQSTHl1sNbptmLTlJIiP5S+gw++UR/5bLgmOo9Rh1BqWMCVyWqiW1A3T
	 Zb2TlSHIIXB01VNK3gcd/MFHYgUEttWbSum0xDuCxNJkj0e5iW/V+seCdVInkHB0A9shs
	 ih4asgWFsaW17ShFFLoF9WU1R1eK7tfItIK+4BqOi2dt3wdo3AyDW8vbc7unE8hRJ8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zc7ZM/mDQtrspDI2WtGWNfNiwm9egkgQQIfQBiiMUgI=;
	b=FLUKazU4Et2cUCm9cZAqXE1ls1xvRsuN7qd5wlza4WdVSbt5FAbXayboLN0hyflVDFJO
	 wGEJluKRCoKXBBCD6efcrZLy2VODFcKlQ5rgthid5RlFHM22ZCjsGLNWr1pf5BTQCBaw2
	 hxeNW+ofytYrl+qGF1MH1F8oWjo0zGWKDYxVDZ4XlVrcoqrb0DmBgrNS6WEqzz97nNpP5
	 pMRGlEgB8bO4RwnCVRIPTNHco41OuS0OOwi/esjy0UdqutNilx5NAuA/KtvTbI/SUFXVx
	 uFkNmPDrUzzOSXxHQcKgcnUsy4cfMP8eUGdQhaQoM9kvAOebTl6mQuSBqEH4QqiCJzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUZSeaOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ABC60A262F;
	Wed, 28 Oct 2026 19:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUZSeaOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627421F01828;
	Wed, 28 Oct 2026 19:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214376;
	bh=Zc7ZM/mDQtrspDI2WtGWNfNiwm9egkgQQIfQBiiMUgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUZSeaOn+zpyaYDEVJ+m3ZuF/DwijL0kAJKXOE6kiQt4bjt6rCiWs29jxXYcblVgB
	 0T06HJk+tXBxt6PsZDBJ0jaZ1vUYeVoMNknG6erKBF1Q8UPDRIiE0Ui5dRi1ZcZro3
	 EQbkwVR5CqF61EQQlEnmINaXBLE5vvu27r7uvK1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0810/1887] iio: st_sensors: relax WhoAmI check in st_sensors_verify_id()
Date: Wed, 28 Oct 2026 17:48:26 +0100
Message-ID: <20261028170517.861857010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

[ Upstream commit a3c2c5c937ed7562b6d120670f2743e979c05881 ]

Hard matching against the WhoAmI values isn't ideal for using devices
which are compatible with existing ones. Instead of raising an error,
issue a warning instead, thus allowing the driver to continue probing.

Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Link: https://patch.msgid.link/20240625082800.62305-1-kauschluss@disroot.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 9f92e93e257b ("iio: common: st_sensors: Fix use of uninitialize device structs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index 6c3705f3838d1..42bfd212b90bc 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -617,10 +617,9 @@ int st_sensors_verify_id(struct iio_dev *indio_dev)
 		}
 
 		if (sdata->sensor_settings->wai != wai) {
-			dev_err(&indio_dev->dev,
+			dev_warn(&indio_dev->dev,
 				"%s: WhoAmI mismatch (0x%x).\n",
 				indio_dev->name, wai);
-			return -EINVAL;
 		}
 	}
 
-- 
2.53.0



