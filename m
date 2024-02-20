Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3454814A4D2;
	Tue, 20 Feb 2024 21:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464632; cv=none; b=XIQBiepnnNPU4kSHvWF5HoKI4iEKbSzybUVkblQkwC1UM0maQU6u3PE4cm+kHnOCDiyNK4BcRLqXg8gasj/VqcbNeoxtHzk8RlBgW6FUhRxRGnRjrwNbte1skVhTvRgWUgbEd8XWGLrO2SM+6G24UmsvoHuN7OeNzrZ9/gZdkaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464632; c=relaxed/simple;
	bh=+x+Wl4Z4Fg8kpIDrr6Ln8Un2f2YEFKQ3KE4qYNdcMvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHB/k21KAhq0l75u6qHK+C/nLZUMYigYlhC/lHtzBh6I8/Yq6VFUT9yHT8g/lVZz7xKaIP7XFudtFFftdQIZJ33Iem6ATubPP34eYPrfs24UQ2q2/PhKFeATNTz0K35Nn9KrMI5qlfot8S42LAJXSpXnwhMvgV53UDMcWVZtMVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09twVcxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09twVcxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8588C433C7;
	Tue, 20 Feb 2024 21:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464632;
	bh=+x+Wl4Z4Fg8kpIDrr6Ln8Un2f2YEFKQ3KE4qYNdcMvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09twVcxiR5uzppjchFfOMqUN/BT5uv0MooCY0jsVoUdc3F5sSKCK5tdC34F3gq4qM
	 fZv6PD5+/AlO0NqhWAWunS+0Ehga8vf278UR8sJyeki7UFDjmH54oKkiy/+tCec52m
	 U5lm5q6gbRzwhlSTotX56624elsMEoINn9HjEWXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 086/309] iio: hid-sensor-als: Return 0 for HID_USAGE_SENSOR_TIME_TIMESTAMP
Date: Tue, 20 Feb 2024 21:54:05 +0100
Message-ID: <20240220205635.887071079@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 621c6257128149e45b36ffb973a01c3f3461b893 upstream.

When als_capture_sample() is called with usage ID
HID_USAGE_SENSOR_TIME_TIMESTAMP, return 0. The HID sensor core ignores
the return value for capture_sample() callback, so return value doesn't
make difference. But correct the return value to return success instead
of -EINVAL.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20240204125617.2635574-1-srinivas.pandruvada@linux.intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-als.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -226,6 +226,7 @@ static int als_capture_sample(struct hid
 	case HID_USAGE_SENSOR_TIME_TIMESTAMP:
 		als_state->timestamp = hid_sensor_convert_timestamp(&als_state->common_attributes,
 								    *(s64 *)raw_data);
+		ret = 0;
 		break;
 	default:
 		break;


