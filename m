Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8997E110;
	Tue, 29 Apr 2025 17:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947927; cv=none; b=PzsUt7QXNDyTuhi0liiA/xn8Uu691uPBCmUC1EaIXnjSY6uoM+lyuByUIUWAqlYzbzBMTWeNHyzSm195/zj8bMqRsqcLT4JDQStlN+yVWoqbF0wyKRRMIOqBZvJFTbf/A9m2acufvzi2gjnbmpaiCN+VAZD6rwHcnZg6PW/G+EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947927; c=relaxed/simple;
	bh=/yjbJ0yKAhCnJ7H58ZDKEL8Ek5JIUBC+5/b+fDbk/I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/NTFkePOmsSCSoNCta8aCDxJcm3lDCXA6ftC6vklMZnobJxuQAO68sJE7BGqp0RybS2jlROHqGvi01B5muiVF11ctBsGFO9aPeFdX9Iq8+WV0bGdtwRsIv3VayFZmwMbxDcEgefmif/22u3IYQO783YLhlxkUSh+iEDlHo9fOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdiiY0EY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdiiY0EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CA7C4CEE3;
	Tue, 29 Apr 2025 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947926;
	bh=/yjbJ0yKAhCnJ7H58ZDKEL8Ek5JIUBC+5/b+fDbk/I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdiiY0EYiVTGDv12/JnjyjNVDTv840dGIE4M43PAvTShLBzJoP/nxikR71PfARvrX
	 RFaFQ4+HDL5ulQxp5bl+k2xH3vRNHL9YPaMI9FR6lqVCYlStRARegBaP+VlGVRTixz
	 xS6mzNjcIJVXj9JV1I0O/6Tt5k4nJice5hohGWjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 147/280] USB: VLI disk crashes if LPM is used
Date: Tue, 29 Apr 2025 18:41:28 +0200
Message-ID: <20250429161121.139306638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit e00b39a4f3552c730f1e24c8d62c4a8c6aad4e5d upstream.

This device needs the NO_LPM quirk.

Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250408135800.792515-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -542,6 +542,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* VLI disk */
+	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


