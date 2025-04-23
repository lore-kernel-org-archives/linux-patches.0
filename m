Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002D529AAE0;
	Wed, 23 Apr 2025 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421779; cv=none; b=exYO/rPWIinqNMgMcMKKKdIJSd0C9Jf1zvBvdJCsQFVq+3B/3I/ev9Uz4PhNNdmLH8Sdyy73jGwjX47tVFs2GX9IDM/9bGI9gFZgDxXEzc6TD/s783B6VcCtUn59BImDH7qYZ8U4xh5g5boiwdw/AVKCUFIFlD/F4dgtZh8Q420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421779; c=relaxed/simple;
	bh=vS/1osaHEujlLN0s7Rni+35KDUh9X1WFrlM2+gehioQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rsdi4fYgEi4xv+gk0QbA+O3jrza82PXamXQPOCJUHPdwEmAr7s0odB+iS99bYIfbPMHfef73XcBBdj3BANMFmAL66p0AbmpqobkIFpEaySProVS0RFxegwEsGIIb0iyAhzPEsxdkRzEwTFlFhxRI9PCGQcSsUnTYIW7e0LJg3OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIwgm6Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIwgm6Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BC1C4CEE2;
	Wed, 23 Apr 2025 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421778;
	bh=vS/1osaHEujlLN0s7Rni+35KDUh9X1WFrlM2+gehioQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIwgm6RmUfKOlpFV+zWLSA1HhBh7rCj8VEif3Z7dD6XbwFivG+h/Lj2kmf5gLbOC0
	 fpY3jQoBm0cHlXcp6wcBwb/21zf6zPhjD/A/V+epW2diNlKXM2bd6CczK29LKH4PHT
	 VMSes+Gx8MvrQSWTnRSdz8dz5C5121vgz4YRYe90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.14 232/241] platform/x86: msi-wmi-platform: Rename "data" variable
Date: Wed, 23 Apr 2025 16:44:56 +0200
Message-ID: <20250423142630.050321930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit 912d614ac99e137fd2016777e4b090c46ce84898 upstream.

Rename the "data" variable inside msi_wmi_platform_read() to avoid
a name collision when the driver adds support for a state container
struct (that is to be called "data" too) in the future.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250414140453.7691-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/msi-wmi-platform.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/msi-wmi-platform.c
+++ b/drivers/platform/x86/msi-wmi-platform.c
@@ -173,7 +173,7 @@ static int msi_wmi_platform_read(struct
 	struct wmi_device *wdev = dev_get_drvdata(dev);
 	u8 input[32] = { 0 };
 	u8 output[32];
-	u16 data;
+	u16 value;
 	int ret;
 
 	ret = msi_wmi_platform_query(wdev, MSI_PLATFORM_GET_FAN, input, sizeof(input), output,
@@ -181,11 +181,11 @@ static int msi_wmi_platform_read(struct
 	if (ret < 0)
 		return ret;
 
-	data = get_unaligned_be16(&output[channel * 2 + 1]);
-	if (!data)
+	value = get_unaligned_be16(&output[channel * 2 + 1]);
+	if (!value)
 		*val = 0;
 	else
-		*val = 480000 / data;
+		*val = 480000 / value;
 
 	return 0;
 }


