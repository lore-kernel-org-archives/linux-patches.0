Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362534;
	b=t6BG3+K7pXq/3ShbEoqXuEfXGq+enCeg56BP6IuW1/teaBmLPfAj5/n/whPfF3Pbfc0W
	 3QfFexsq13DBE7Um9sgzEERrW5jZ6SYaZ3EzIwDFCtmaPXdVLmRsi2VOSlDykBx1DkOQR
	 f7pPoniCZjjT1vA40aUKx0Wa17Rgmt3SpON4tF9X2ZYRdm40RYwJuXMqFV7l2O+RCVbpc
	 INbM89Zxa3MxV+B4ZjPaeWvdqmgfSXUlhKfVltX+HetxGgUI4nrjenLm+a5a2CfgNMndA
	 j8gQL52FEuYh6vpRCpOxmqQS8PELrt6MRSQvHOohqXrdbX1rfWTwYzuj9xIL/Nh5+ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yaVOupTyQAA/rc5SeYu0OHmiZJ2E3J0bcnwqmltxpbI=;
	b=o+6V9YmmBJkOgOBA68YypiKRP3oePf1vT/hxgwBQgVjb676G9CUw5ziRIwwT9YwSSMlm
	 8pamBCRtis9GSGNPPcH+4t9U+5ugYisY42hS7EWhOxHLh6Dcr4gsgv6spXQ5rE12EZjc+
	 +Zjz9ao3R4CnJFtcZXiGLVEvwQXouenPOIQ/TzIupMAXIqDN1Zvfm3lHom3SyuDZqPHi0
	 9srVTqb9VKBj99T7UfdksaMQ6F77qQ676UlorKwBcg1QXUwXsHIRIL5QGCzq2CAgftS2h
	 0cWIxLWjYjMU6AZrlmg7cD/gYPqsP6WS6Uaxf+UUCboUd/AAoO5mlea9Z0Fhqy4qZfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4peag2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24EF606A31A;
	Fri, 30 Oct 2026 12:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U4peag2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E21B1F00A02;
	Fri, 30 Oct 2026 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362533;
	bh=yaVOupTyQAA/rc5SeYu0OHmiZJ2E3J0bcnwqmltxpbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4peag2ihIyW/bsunkfsG1/oEI13YhnRLpZ06WnyMiwfx3I8zqPTeBtL4z2QOR/8U
	 BFk0826mniU517hZSDx5VC0/1ryJpo/j9Gp5AaV3p7T/c3taxmVkP1OnycmZ/dje8O
	 YDWfmqAmdI1jUX8E7tbYozp7RDkfT1O9dzcjuDbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schaefer <dhs@frame.work>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Sven=20Vaink=C3=BCla?= <sven@xn--vainkla-r2a.ee>
Subject: [PATCH 7.2 05/10] iio: hid-sensor: als: scale each channel individually
Date: Fri, 30 Oct 2026 13:15:06 +0100
Message-ID: <20261030121255.387630811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6bf1bc9a38fe6..8f2affb226a35 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -33,9 +33,9 @@ struct als_state {
 		u32 illum[CHANNEL_SCAN_INDEX_MAX];
 		aligned_s64 timestamp;
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
@@ -175,9 +175,11 @@ static int als_read_raw(struct iio_dev *indio_dev,
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
@@ -331,6 +333,10 @@ static int als_parse_report(struct platform_device *pdev,
 		};
 		++index;
 
+		st->scale_precision[i] = hid_sensor_format_scale(usage_id,
+					&st->als[i], &st->scale_pre_decml[i],
+					&st->scale_post_decml[i]);
+
 		dev_dbg(&pdev->dev, "als %x:%x\n", st->als[i].index,
 			st->als[i].report_id);
 	}
@@ -340,10 +346,6 @@ static int als_parse_report(struct platform_device *pdev,
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



