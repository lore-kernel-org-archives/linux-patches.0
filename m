Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B6A2E7F1A;
	Thu,  3 Jul 2025 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554718; cv=none; b=Zx/vLAtYDjlk/U5fLh7A1Ivu2gbu6tcKtFSXXLDRnmD+YrLyENQsfqHL2kAMzIvpP+12ULoZ14FB/kDz6qqoj5/KpDV7mJ8apQZt2CxFP1rk5zJH4wWh60lakSIQLXWmD4kFg5Ibx6ntDK7soruJO6psb7eD9sJrMaqJJsbypKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554718; c=relaxed/simple;
	bh=Lg3V8+PPXxaACr1oTKnbYgyeSRgP9VbK7vwJnqWhiZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqHoN/faBB4qs1AYoctFDbe+48o7gCQ5f0lh+l7HIyYCfyC+aVFwmF9rLxfhIUntOqSgB+jyAAphGGb5BYESX3k0TWK439oymJK6zLfgeCaOBX6Z6kAAXFzqcxPaj2a9dOkn8Sq6F/HLXj7RZBliw+wp115nsjlymxYTGEcHlnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoCjM45z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoCjM45z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AB2C4CEE3;
	Thu,  3 Jul 2025 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554717;
	bh=Lg3V8+PPXxaACr1oTKnbYgyeSRgP9VbK7vwJnqWhiZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoCjM45zRPM6THt+syFdlhpwdJnNH0MFO9dPUG80cencfTJS99kOd5Xw+t4+f5t+f
	 fwij4lxaxsoMcFAYV5qz9vNQAw0VKruJkoqJawr/VAeFIx2fk1sCPKkPgWYct+GJNc
	 fWe0AAt+6XeSyn5FbxfSGhXU8d1eQHyfzPs5dglU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 055/263] iio: hid-sensor-prox: Add support for 16-bit report size
Date: Thu,  3 Jul 2025 16:39:35 +0200
Message-ID: <20250703144006.514224390@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit ad02ca57e44e9936fca5095840fad9d4b47c5559 ]

On Intel platforms, the HID_USAGE_SENSOR_HUMAN_PROXIMITY report size is 16
bits. This patch adds support for handling 16-bit report sizes for the
HID_USAGE_SENSOR_HUMAN_PROXIMITY usage in the HID sensor proximity driver.

Previously, the driver only supported 8-bit and 32-bit report sizes. With
this change, the driver can now correctly process 16-bit proximity data,
ensuring accurate human presence detection on platforms where this report
size is used.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250317013634.4117399-1-lixu.zhang@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/hid-sensor-prox.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/light/hid-sensor-prox.c b/drivers/iio/light/hid-sensor-prox.c
index 4c65b32d34ce4..46f788b0bc3e2 100644
--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -215,6 +215,9 @@ static int prox_capture_sample(struct hid_sensor_hub_device *hsdev,
 	case 1:
 		prox_state->human_presence[chan] = *(u8 *)raw_data * multiplier;
 		return 0;
+	case 2:
+		prox_state->human_presence[chan] = *(u16 *)raw_data * multiplier;
+		return 0;
 	case 4:
 		prox_state->human_presence[chan] = *(u32 *)raw_data * multiplier;
 		return 0;
-- 
2.39.5



