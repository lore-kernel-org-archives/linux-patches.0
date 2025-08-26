Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B0D2676E9;
	Tue, 26 Aug 2025 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219292; cv=none; b=QD4bcTNojHn15fpzLTxtqE8tKZwxwIWrPvkOgugBiXXYHI4qdOQiKfjWSm8Ll0KYIwOtZU7VYR7Oq3y25NwVnzwpCGcOeo0gRK4Tg4gjbJ5Z4wTWgpVV3ZvPwwjERBjGjpzLXlTQMHzczUJgeU7QlnFTQYboic+7McJp31KMmvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219292; c=relaxed/simple;
	bh=aNhxgSlW++X2WkvN69UMtUu8Ht027kYcjQmiZewwAZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIV969BYjQ91EjqEQ/lFcyu+y/xU/BBft4sBhDIC9OGsNaRpYY2Cp73Q6LvUWz4Qx9ORfA2cFxiGj5u5SaEbxgQsD+IJ7/Xk8aCMtJEvotzWTSydzKD7Y3kpWQ0iaRl1Oj1MlY56L1O/UjE5qCJt4B00q6NoYGO0tNzYXLqz4OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10gxDlXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10gxDlXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B26C4CEF1;
	Tue, 26 Aug 2025 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219291;
	bh=aNhxgSlW++X2WkvN69UMtUu8Ht027kYcjQmiZewwAZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10gxDlXBNy9wyB1Qb1TmTS+6cETVXJ2Wygz1Cu3uySO982oFa/R+eOdkQSqZ6S4X6
	 +pufgAr417xWgmKFepCtgYlYM3ed/0EWLghdzIuIEWyigYJSvppG2wUSYoKTi60Geo
	 xBM4MsK3zF2w7gcDRKYJiFv9hY+OqwOvYhJ2GCZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 318/403] usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive
Date: Tue, 26 Aug 2025 13:10:44 +0200
Message-ID: <20250826110915.597399287@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit e664036cf36480414936cd91f4cfa2179a3d8367 upstream.

Another SanDisk 3.2Gen1 Flash Drive also need DELAY_INIT quick,
or it will randomly work incorrectly on Huawei hisi platforms
when doing reboot test.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250801082728.469406-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -368,6 +368,7 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
 	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x5596), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* SanDisk Extreme 55AE */


