Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126A92DA751;
	Tue,  2 Sep 2025 13:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820791; cv=none; b=sH5iaYOcuabd3zfDz3bK4Kp+UsB45nvlUC3aw4xkOlCI1CNoAZ/5c+Ciczx98r6xRWWZAc1FySvbJhK7/lbk+912CwFMotrfOVmC7qMeM1d30GoRibV75J5U0OvbhZsOpBkBrmwUZPiKA3BB0PsFK9EqjbyAxYJvIFotrazzGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820791; c=relaxed/simple;
	bh=JGr+H7OMNdAMEe5dXys2K3hKN5kOwGJDGUdGXqjdxgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXnqiPEaG+1wYriHqXv7v1pVFRbtZp+7zc6JKQBKHfPbtDOoZCa21225/W9O7MmzSI1kZqVrZnZj2K9Q07C30/b39JkmIQiIL2dtyPNHjiynHhbL3hFVrhVVQU3B7nsPJuGPWoPCL/fLMyS35bl7XgcpY4s+keNNC+q3HjHrav8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0akamDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0akamDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C569C4CEF4;
	Tue,  2 Sep 2025 13:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820791;
	bh=JGr+H7OMNdAMEe5dXys2K3hKN5kOwGJDGUdGXqjdxgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0akamDsEc8v+mhTAuDTiN1SfhSiR6wQI3IIUPol0QjwZEkkXXySN8IrYhT6yCRgk
	 De0U/AkbjYnIe945oEykE6Xx4osHNKJ0eHdwu9LUt9ftMmHsjRS5LjevzOCd/YCR2j
	 9xUIItVNS/ZG1plC0SP5hB5i6FuAqgT+LeP/kCgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 19/23] HID: wacom: Add a new Art Pen 2
Date: Tue,  2 Sep 2025 15:22:05 +0200
Message-ID: <20250902131925.497596771@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

From: Ping Cheng <pinglinux@gmail.com>

commit 9fc51941d9e7793da969b2c66e6f8213c5b1237f upstream.

Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -684,6 +684,7 @@ static bool wacom_is_art_pen(int tool_id
 	case 0x885:	/* Intuos3 Marker Pen */
 	case 0x804:	/* Intuos4/5 13HD/24HD Marker Pen */
 	case 0x10804:	/* Intuos4/5 13HD/24HD Art Pen */
+	case 0x204:     /* Art Pen 2 */
 		is_art_pen = true;
 		break;
 	}


