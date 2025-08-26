Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705B52FAC02;
	Tue, 26 Aug 2025 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207773; cv=none; b=HFYtqKMLmq+BvxlE5llVBK1qOkT05d0htYqIk8F7uWmPkgLHywssVRAkRjWWANrlkNyENouik/lDI6tU15bZfqEnFpX83w4H3irmfdDHL9JskelzJPdSz5LUNNvJBmdIjCnRkEBDB7U74zFqSsh4C9jQLqnwltpV1RDUTO3T5FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207773; c=relaxed/simple;
	bh=1m3Dv24EQvjXn16HhZYb0TBu0BGT4XYW424jGt38LvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKPSZm8W2GKtSSs9qVeF6KxBC/9y2b2Tk8tKL9ooPT7pMK/hzBVypCKs6lmL4ThVduixiV1ibUgrByjBaW7Ts5Y8cewf4pXJxRdbKrvvFvrv9I9mXjcNxipM4JsHDU2d08MI4A9FQe6I7p1tDZBkLsR6dQsryyN91jEjuiL+pGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhC8LgU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhC8LgU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89FBC4CEF1;
	Tue, 26 Aug 2025 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207773;
	bh=1m3Dv24EQvjXn16HhZYb0TBu0BGT4XYW424jGt38LvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhC8LgU0wiQwrjTNemIITfmOz9C/UuAw8lf40CeQYRcHEOiSc23yS3vY60rdbvHbh
	 FzbcaiHxKLvp+vYmhdK++2Xyl7aGfF4/xr3pPew1AZgrAg7u0qsmNaMpOwD1MHmXG6
	 Tr7Gmq+IbzWp0K4fet2I1/zC8zFKUxYBcFb+b+X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.16 310/457] usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive
Date: Tue, 26 Aug 2025 13:09:54 +0200
Message-ID: <20250826110945.023181554@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,6 +371,7 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
 	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x5596), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* SanDisk Extreme 55AE */


