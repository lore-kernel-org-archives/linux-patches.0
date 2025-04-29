Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37BF24A047;
	Tue, 29 Apr 2025 17:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946142; cv=none; b=VyrOl88fY06LUWOxjFo4WGufa4LlPN53W/OkSL2Dqf3IPIj68fvpkQi0OHyElyKf2yo4eiblOcLMCwMP/BWxAdBbE8WlxvuNBHELqVQFh4Vy3epGHwNP3mIOH4lilBLluU+C/g/S2Dv0Nr58Js99fKA/diLLt1OrBPYXHOG3axY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946142; c=relaxed/simple;
	bh=kK5MthezLg3woXb2gx+Pars/9CKXZdumbazvFoP+x2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3961pDYn9CtygzFAVOh38LHT7UarQYLBJeSJew9aqezftPwqyjRt13Cl70vbXQYlNHiNyPnY0zaLoMInIFfKC1n6uUPwK9maTppLw/U/TPn/W2CCOCnURfeIYaIkYYGa0TrawSYPwxSIVc4NpiQAwOSqqlnI4vW6cLv2kbDcas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQm/pa2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQm/pa2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CD5C4CEE3;
	Tue, 29 Apr 2025 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946142;
	bh=kK5MthezLg3woXb2gx+Pars/9CKXZdumbazvFoP+x2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQm/pa2O2RkV5YiUfql3I/Vz9epqYFpRCxqM57mbdHmgV9boQ534lUtP5hxgXk3s5
	 UBOKGHPotiLyxLurYXOEvmYEPQyUSu3XacibivEym8F5CHT8QVGciqBgW4hah/p0t5
	 MGPmVXhomcvPE5I06jt/X6EohymL/FCv/3FLdPYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.14 169/311] USB: VLI disk crashes if LPM is used
Date: Tue, 29 Apr 2025 18:40:06 +0200
Message-ID: <20250429161127.959602819@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -545,6 +545,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* VLI disk */
+	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


