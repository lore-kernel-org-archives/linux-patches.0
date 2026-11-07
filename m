Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060583;
	b=lldIAbEbUT2s68oEveXTe9b4lh4nqKbZEA2I+ucFT6u3BDzLg7sZBVNrdEEGFA6Z3IdD
	 QDWx+agsOozJNHk1AM/RAKci6DfmvFm6NUj0QW3/WNOQlNOhldvbc1ZGopeBT4HTd0PiM
	 vVdWlpHH/6e4qQm6CcoZuwj6T4Q369qwtny8MeBEHCB3NZNleO4K2Mtli2yT67CCS/TXM
	 4uQ/9/CgYJdZH0iLBQWmQ+5yNp8URy6MQQudd15S8z/3oKT755xIWviwcz+jr4DQhevRt
	 JYDERrC4W54Aypt/haULbNCbkusUsShnU9dzl+rwXRBqMULHEz6hF9ph/m3jXA6R5zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ly/o2HvwwVbnn9SnY+pbzLMAt02O1qAPktEmWl+9uGc=;
	b=Or+WEwN6uugTpLpTa7RNw7h6XCVHlwJEQW62ALdlvvz5LrNENXTHwlGWjwHgzV9WnTB4
	 E7oUXNxj+Iy1nvJd7sslhH5VRWe/hXcZKRoY4azu0OqTddkSCiyqso+fQe1XE4uXMWuBs
	 VdGIl1mGuOcdNbS2KXL/6vRwe/Hj0BttiaSHDL9a6CjdAe0KQggL3Oheb8Qa2Kq2nHnC/
	 fibIfrZu9UptVOfcCGqPULF9JPoc0UEV4MWM9bCQwswLqMjAs7Vrkaw7ZLV3Ig0jcxk7W
	 EHPBG4Pf1Mhzdy3+nGZyShkpqhpknlDdnkE9qwiHhZdkBF1foTjmiwRz77Pewl4r6Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ll5WJXN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2231606A32D;
	Sat,  7 Nov 2026 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ll5WJXN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2011F0089F;
	Sat,  7 Nov 2026 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060583;
	bh=ly/o2HvwwVbnn9SnY+pbzLMAt02O1qAPktEmWl+9uGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll5WJXN1pNyl+B33zU9hb1hNcnfUjR9XDyuL1VbVuvsfFnVvisjvVEYi5JZCdWI0g
	 lxEBXJkr5VEuHLUb1ZquOprrMSi67zlHeetVRJBlXgop6w7ptDVZ9UwLUTVWivsa4M
	 L3q5sQKWn/uJSpQtCD2q3fuwk7QGAxpkSFXIFMdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schaefer <dhs@frame.work>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Sven=20Vaink=C3=BCla?= <sven@xn--vainkla-r2a.ee>
Subject: [PATCH 6.12 0014/1536] iio: hid-sensor: als: scale each channel individually
Date: Sat,  7 Nov 2026 08:33:50 -0500
Message-ID: <20261107134958.079852704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schaefer <dhs@frame.work>

[ Upstream commit cad928dad9a4c26aa56b4223dc2a29bca517fb5f ]

Some sensors have multiple channels (not just brightness but color ALS
sensors) with different scaling factors.

Signed-off-by: Daniel Schaefer <dhs@frame.work>
Link: https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/merge_requests/413
Tested-by: Sven Vainküla <sven@xn--vainkla-r2a.ee> #Asus ProArt PX13 laptop.
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/hid-sensor-als.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index 260281194f613..e97eb4ff6e0d2 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -33,9 +33,9 @@ struct als_state {
 		u32 illum[CHANNEL_SCAN_INDEX_MAX];
 		u64 timestamp __aligned(8);
 	} scan;
-	int scale_pre_decml;
-	int scale_post_decml;
-	int scale_precision;
+	int scale_pre_decml[CHANNEL_SCAN_INDEX_MAX];
+	int scale_post_decml[CHANNEL_SCAN_INDEX_MAX];
+	int scale_precision[CHANNEL_SCAN_INDEX_MAX];
 	int value_offset;
 	int num_channels;
 	s64 timestamp;
@@ -186,9 +186,11 @@ static int als_read_raw(struct iio_dev *indio_dev,
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SCALE:
-		*val = als_state->scale_pre_decml;
-		*val2 = als_state->scale_post_decml;
-		ret_type = als_state->scale_precision;
+		if (chan->scan_index >= CHANNEL_SCAN_INDEX_MAX)
+			return -EINVAL;
+		*val = als_state->scale_pre_decml[chan->scan_index];
+		*val2 = als_state->scale_post_decml[chan->scan_index];
+		ret_type = als_state->scale_precision[chan->scan_index];
 		break;
 	case IIO_CHAN_INFO_OFFSET:
 		*val = als_state->value_offset;
@@ -337,6 +339,10 @@ static int als_parse_report(struct platform_device *pdev,
 		als_adjust_channel_bit_mask(channels, index, st->als[i].size);
 		++index;
 
+		st->scale_precision[i] = hid_sensor_format_scale(usage_id,
+					&st->als[i], &st->scale_pre_decml[i],
+					&st->scale_post_decml[i]);
+
 		dev_dbg(&pdev->dev, "als %x:%x\n", st->als[i].index,
 			st->als[i].report_id);
 	}
@@ -346,10 +352,6 @@ static int als_parse_report(struct platform_device *pdev,
 	if (index)
 		ret = 0;
 
-	st->scale_precision = hid_sensor_format_scale(usage_id,
-				&st->als[CHANNEL_SCAN_INDEX_INTENSITY],
-				&st->scale_pre_decml, &st->scale_post_decml);
-
 	return ret;
 }
 
-- 
2.53.0



