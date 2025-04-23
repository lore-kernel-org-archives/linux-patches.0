Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D263280A5F;
	Wed, 23 Apr 2025 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421155; cv=none; b=DUzK6kMvdtlTgePRKLYN5BZ5lt99PucK4aIFEGbdeFp0AKObAEyjNpFPsx74hDEUAWe/MetjBtCzva4aMG3L1aikw3sA6tPnnlrFwII/aAhDQlzUDPM5ufk+fJD0sn1vjETrX/DR9X8F2zd/855G+IwtoiDHJQkqkTOCihHJxfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421155; c=relaxed/simple;
	bh=EjTiPlDQ1TpB3RQd6Dlbwdxe7wORAW5W6c0XOCkvzWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mTbZJ49WQBxHEfIoBoN5dI9mICqmAaBbqGSt8XNtV2xWY42iLGFKtPqNeYFo8eZiY2n+99gvbjXHmXQTydRGTc6OBiam2kNvFBcfGNeK/mSZYJW+f2bG0SbJfEl/NlWWRURC81DLhf7WpvfmrKu6cQRet41kggnnzELE49iCstI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7ETFwwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7ETFwwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C8CC4CEE2;
	Wed, 23 Apr 2025 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421155;
	bh=EjTiPlDQ1TpB3RQd6Dlbwdxe7wORAW5W6c0XOCkvzWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7ETFwwu9yjRiTB97ng5rWqSz63zBlNY8qZlLf5Zsd4PEqouvqCcyigh+wHK/XXPu
	 MAIzZIOdB2fyjePAYtN1Ys6IPXy2qg2ZZCHjOyAHqQsUfI186+jIjklotpmFGW92Uh
	 Mnxl6gUNBm/ic+ZwtVOGo/oN+7srvuTRB7CZYcSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 196/223] platform/x86: msi-wmi-platform: Rename "data" variable
Date: Wed, 23 Apr 2025 16:44:28 +0200
Message-ID: <20250423142625.155795675@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


