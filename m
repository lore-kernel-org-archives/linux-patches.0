Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAEE78B53;
	Wed, 21 Feb 2024 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523299; cv=none; b=drJi8WwqN5m43q449ZLgUupgNpImsFkykGYU82hg/RZdNnU/ZmdkCqNin6VWzmnkupmDXH2jIhVbn7lAXOFpf+evy+wjT+x2nto3U1Ok3GBDqAtfNRcC9FyTGt42eoUIwLNLMlfMto1j+o43FjMACHxeMcyFRDFBi6iIO32nK0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523299; c=relaxed/simple;
	bh=IEQaxgug0i+mPCVLFksrl+3FDZafmxEvnQ7ugYHvsFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jl4Am6KMTdMYpB+ZfdEmolnJEluuwqWR/+PmQNpb27MZZ1dmRbbrJ0wvsyZTNzD5iAUQuIe6jwmVvcPmL+Lb1NUXFRvd5VDWablbdlTN394LPd3RO56k5dkpsdmK7NUViPosU+MZNQMieZ173r0Cgxz4PaOKiJDG06lK/uxwRXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0s2tQGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0s2tQGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04DFC433C7;
	Wed, 21 Feb 2024 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523299;
	bh=IEQaxgug0i+mPCVLFksrl+3FDZafmxEvnQ7ugYHvsFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0s2tQGc575Ki0Pk8wtmwCKmtKqTEuLUJiTL0JIG3RSN1yrAvY/z9I0n2MzS6nQ94
	 xAmBrFDtmsWxdWoQop5hnQ+72uvF67dvaULpUD9t+fWmor2O55pbI6tk1yyzbWzCvL
	 eygRvgLD/M8+yfWK8VY/dBxE3uDR1tnPIVh2Kzt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 365/476] iio: hid-sensor-als: Return 0 for HID_USAGE_SENSOR_TIME_TIMESTAMP
Date: Wed, 21 Feb 2024 14:06:56 +0100
Message-ID: <20240221130021.515007278@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


