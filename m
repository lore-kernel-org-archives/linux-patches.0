Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1081BD9D3;
	Thu, 30 Jan 2025 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247268; cv=none; b=ha+jDehcd1X74EEKHLp2xvrThSdBKgctGYvHRv+uVfmWIQJY89O3Q4cpJk6YXV0+xUu15/i6gNkmwHwkGdB6PmHrYZhy8o1g+Sqep2tlidSlPUrBTCk4L9XsVYlGnJf1uMUUFTB30NeTAjZIh2Yu/LPt+3ZdoFUwPDfdhRsPggI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247268; c=relaxed/simple;
	bh=GtfJIMZ48Inwk+YAmRVkbdwK28Xp4nfMfliHvl4YkhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESoHzn0fXV1FQSX94H/hsxWFmzEZPMy8O3xmUf2qhtdmSBlu9T4zbM7gZcJNp8Un9vfWWmgOn2Wl5uuINh3AdIUt0ejJZvdz4mug+P7JOyE3juMNuoh5KTyEdddMbp1vrBLXkmZYqG1R7b1Ts4ADt6XUQlWnziLUc/Lt8ZnULMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GW9r4xZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GW9r4xZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82352C4CED2;
	Thu, 30 Jan 2025 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247267;
	bh=GtfJIMZ48Inwk+YAmRVkbdwK28Xp4nfMfliHvl4YkhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GW9r4xZBSyoFfPJkAAOVQy7/2xtPRXBMVWfpDPkbmf+coP3OPTlD0abLRhklfpIJ9
	 rRTt+6jOD0gRHEeiMrjdcXu3tK2yndacljBkdbO8dodaMDi1t4hCAeHsjDWPAoLWJw
	 eo6/vPd4jv/VZzi0wnkR4g6Oo7TXCL73FfEvV9kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 132/133] Input: xpad - add unofficial Xbox 360 wireless receiver clone
Date: Thu, 30 Jan 2025 15:02:01 +0100
Message-ID: <20250130140147.840467752@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit e4940fe6322c851659c17852b671c6e7b1aa9f56 upstream.

Although it mimics the Microsoft's VendorID, it is in fact a clone.
Taking into account that the original Microsoft Receiver is not being
manufactured anymore, this drive can solve dpad issues encontered by
those who still use the original 360 Wireless controller
but are using a receiver clone.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-12-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -128,6 +128,7 @@ static const struct xpad_device {
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x028f, "Microsoft X-Box 360 pad v2", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x0291, "Xbox 360 Wireless Receiver (XBOX)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
+	{ 0x045e, 0x02a9, "Xbox 360 Wireless Receiver (Unofficial)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x045e, 0x02d1, "Microsoft X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02dd, "Microsoft X-Box One pad (Firmware 2015)", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02e3, "Microsoft X-Box One Elite pad", 0, XTYPE_XBOXONE },


