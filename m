Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22789350825;
	Tue, 26 Aug 2025 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216888; cv=none; b=JYqqwwJlBE5skgHQFQzMP0sC6kT4sfJAUUY38owtWw2frJ06WPIdHJlJAWjLZUd9YvWBuaNrhHmx5jrdbizQJ/INrPBxNB2VSMwqlVGzvR+Gx4BrmYmSOAewNtjrrHI3l9g+t/tdL+FIG0/Bh9aCyNgYA3+LlZNehhrZBTBA8nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216888; c=relaxed/simple;
	bh=h05GePP/JKB9hU7rC1TgpscJ2g8IqgkzOgbjK4nlDmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZ5loiZRuu3wFlbRhw1ecxjeJrADZYa6Fk6L5dobfdE3yxcwZKBRv4iBTxejQdsegVPWplPnJexw3xXQSMlw8No3epmG7fMWJiz7pWYg2+K4Y9cIN9WJT5krO3vdLQnVJ35DAbm7CXZaZyAYoB7LvIYMHgh3ehpHc3mVPrvFgEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x43A3VR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x43A3VR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB826C4CEF1;
	Tue, 26 Aug 2025 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216888;
	bh=h05GePP/JKB9hU7rC1TgpscJ2g8IqgkzOgbjK4nlDmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x43A3VR9M207ooCkVlXpK9r/UmjAfaS/n45UpejfsOJJDJost1kq7/8O+mi4g5vRo
	 pv8bL3Wng6dpJMju4uRcbvb0m7EntGy36QMnBSYH0R5D12INg5IsKvgdkj9nVFienn
	 ocllviar3GTiBb0RLoIB8S4f1NUgDydntb/r4TBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 581/644] usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive
Date: Tue, 26 Aug 2025 13:11:12 +0200
Message-ID: <20250826111000.930356720@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


