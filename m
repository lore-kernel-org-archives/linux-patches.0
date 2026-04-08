Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F6E2641FC;
	Wed,  8 Apr 2026 18:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673971; cv=none; b=ZpRWjyiV8OxftIeYhhyMsGCC0iPWcJ786v5f8VqcFV4xmmgvqD44GI9zBJNqiLL/LJFKcKotQNKX+QPq5gg8BGUAu/PdPGTNdRAAhQH6wHWWuWVX4Kn7x+4VINMZNN+TF9ayN0sGKZB946sjNvffMON2kFiQ3ZLWJUb+KwsT3n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673971; c=relaxed/simple;
	bh=0ccfJNY8sWzHCbx/qSVkcwxU7dM8MeqwsIvVqQ+xiWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZoXrVc81i2pCiWlPARlkElQo7/Pt8EeIV7eBi5Y8WAhJK0OedZSlbJNV/ed5+OYaKHtaYHm00fC8Nq49cp9RXKj81qTBAl1Y/6nwePoiqQMP5Ro0wAQtJRugtUo3/Mj7sWYC5GZdEw0CGI4B51jZYpirzAIRTvamqoRo99nISo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1OVtkZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1OVtkZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25CBC19425;
	Wed,  8 Apr 2026 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673971;
	bh=0ccfJNY8sWzHCbx/qSVkcwxU7dM8MeqwsIvVqQ+xiWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1OVtkZJaaWd7ICAHz/IYj0m9/fKfZrnNG6DlzUXrPfHNFSrK4SAbE/K4jMp7rmE+
	 oYwF+PCZPqpUqyHR0yvsj/o25sPgX7O4SY7b5VBJ3M1+MdjhOtRbnFNbklGt0y08A+
	 Q0uktPQIkbgbeWcA7VCieScYPcYmhxT4JQZXq6NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 159/242] usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive
Date: Wed,  8 Apr 2026 20:03:19 +0200
Message-ID: <20260408175933.040475359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Miao Li <limiao@kylinos.cn>

commit dd36014ec6042f424ef51b923e607772f7502ee7 upstream.

Another Silicon Motion flash drive also randomly work incorrectly
(lsusb does not list the device) on Huawei hisi platforms during
500 reboot cycles, and the DELAY_INIT quirk fixes this issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260319053927.264840-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -402,6 +402,7 @@ static const struct usb_device_id usb_qu
 
 	/* Silicon Motion Flash Drive */
 	{ USB_DEVICE(0x090c, 0x1000), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x090c, 0x2000), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* Sound Devices USBPre2 */
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =


