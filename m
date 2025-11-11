Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5765B261B77;
	Tue, 11 Nov 2025 01:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823433; cv=none; b=kuTokr7wuiAgPOkq6uiEwx1kvgSUKqKLKlzmhtdU+vlXTqZbF9Fs43a3rwYL9AiqLOPV+3q1rr8KH5mv3i471O9crdTdJ7oXuB+mPKwRILopDvO5AvgeHlSHX7y0xxXMvLx5g2ZqhHJLBLIlc0GIpzmViau0ur4Dg2UpSXJ5Qv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823433; c=relaxed/simple;
	bh=JrY7+4my1yG5deiadWtkLjOY2yf4vgzKjc1Yidqtt3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slhoBmeAxO9JrzUMHJXQnXRH7OaRsnBiFArbMgixbJZlQOQYTMF7hy/ZGmh/u4QD5H8m+h8uGPYma5T9fMHnCtK4rUbrzREH5yyZE/tqZLNkowDoA+BBzD7aM5byv9Z4ZawRO6njcCACUcXGS/Y6tF3bkwRYpqzQ1Q6hO6lm8xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMMCHfQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMMCHfQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B796CC4CEF5;
	Tue, 11 Nov 2025 01:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823433;
	bh=JrY7+4my1yG5deiadWtkLjOY2yf4vgzKjc1Yidqtt3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMMCHfQ0s1wuPbweNMgN2ifake7ATMQXLM3+XPBlkaxZlqNHSBlpsrgF42ebXt8kv
	 0Q8X49g0+zONmzapzAsMHsfkqok9Bkg0Nap3f68lizdJM7U1cleUbJ6S/NtXOUbST3
	 lWJX/eZ13MDF+tv+EqsrQ5Kbx7e9OIHSmW2uQzug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/565] media: ipu6: isys: Set embedded data type correctly for metadata formats
Date: Tue, 11 Nov 2025 09:41:42 +0900
Message-ID: <20251111004532.444502154@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit f5a2826cd50c6fd1af803812d1d910a64ae8e0a1 ]

The IPU6 ISYS driver supported metadata formats but was missing correct
embedded data type in the receiver configuration. Add it now.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c b/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c
index 0a06de5c739c7..463a0adf9e131 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-subdev.c
@@ -81,6 +81,12 @@ unsigned int ipu6_isys_mbus_code_to_mipi(u32 code)
 	case MEDIA_BUS_FMT_SGRBG8_1X8:
 	case MEDIA_BUS_FMT_SRGGB8_1X8:
 		return MIPI_CSI2_DT_RAW8;
+	case MEDIA_BUS_FMT_META_8:
+	case MEDIA_BUS_FMT_META_10:
+	case MEDIA_BUS_FMT_META_12:
+	case MEDIA_BUS_FMT_META_16:
+	case MEDIA_BUS_FMT_META_24:
+		return MIPI_CSI2_DT_EMBEDDED_8B;
 	default:
 		/* return unavailable MIPI data type - 0x3f */
 		WARN_ON(1);
-- 
2.51.0



