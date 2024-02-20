Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2276B151CC9;
	Tue, 20 Feb 2024 21:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462820; cv=none; b=Y1PC0o4mCiRwXAo4y9siWKTBr/+lktxsa/nb9tCG96yBE9SoIxq1YxG9aLzB2Q7ee76Nh5quJxSgZwtv658QDBmZrKUAiPSMODxTB2bTKAHBsvU6cvgUzRKz0B/ZcfeSeU6kii+TucbEqn1K5N7VYZaYyNfwoYRNmPmwGwpRZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462820; c=relaxed/simple;
	bh=ZFUacNxC2osnU8IoPnIxt4hCUZWdhC3f8FRiO+GaKVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOyO90aBUvtcHyeUrF1X8L4m1m48/2mjgOYVcXOHiUw62vgRt+S6L4t7rmS4Cu7vICBZCbeE3jNKN8POGTLehK18kdChdJiyWst8XbNljH/GUQwLyEIjnKEk0rp7dGAVPbPTcOuPwpyGlDfWcDLjXXlqslvZv6AIM9x7+p01u0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fa3wWu6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fa3wWu6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DD7C433C7;
	Tue, 20 Feb 2024 21:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462819;
	bh=ZFUacNxC2osnU8IoPnIxt4hCUZWdhC3f8FRiO+GaKVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fa3wWu6cUsYogOGxE54S7yuH7NMghiN38NIKfTXXM75EUoTN7F7fxTXGGqU9L4CEq
	 Kgrr+O6Pg1XCSP5STDDLCFoJ96831CuCghpnP+oVVAsxsH+l2VzKYO4a2xifEmoZsG
	 z6N06s5dugZGUuwfs0YDemmIx6m8c0L11E2tA0Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 047/197] iio: hid-sensor-als: Return 0 for HID_USAGE_SENSOR_TIME_TIMESTAMP
Date: Tue, 20 Feb 2024 21:50:06 +0100
Message-ID: <20240220204842.490434250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -228,6 +228,7 @@ static int als_capture_sample(struct hid
 	case HID_USAGE_SENSOR_TIME_TIMESTAMP:
 		als_state->timestamp = hid_sensor_convert_timestamp(&als_state->common_attributes,
 								    *(s64 *)raw_data);
+		ret = 0;
 		break;
 	default:
 		break;


