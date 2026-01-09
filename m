Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D2358D30;
	Fri,  9 Jan 2026 12:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962347; cv=none; b=Id4Qfp8TkapU4dxqmiW7mIEFuFZa0rYdYvrtQHyOnFNa4DB4PjE+ockRUZ1yIChou6sQejM/LKo8V/46paEqhomcPOL5hEULMkyXOIkc9P7ZwmUeeRinfdY4/z1PuDOBcFSNvdPePDnzudZVk/cvA4YAReG4ebCxEIci925OaLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962347; c=relaxed/simple;
	bh=NV7sEFkHT8HXiDwU7h7BDH+EiMEiybCW4vtd4KRltC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmO+XQ4hP/bABAmyvngvnlC44unUq+eNVSeHGUBUkqXeHXH/pAn+M8wOYn8gGNKly0TdTColL5Q8tOq9vt7OpwWgQ0WHsfzJXD6yXBCOcIa18mkoDaRu0+PcvLvBHqAjmgFA4eCE3trZ5WD8nn7Jc9RXgbtjr6A3Vlk1hd83bCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncGeBbWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncGeBbWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060ABC19421;
	Fri,  9 Jan 2026 12:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962347;
	bh=NV7sEFkHT8HXiDwU7h7BDH+EiMEiybCW4vtd4KRltC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncGeBbWEk5e3Wh6pftkORhSLjY4V40yfkUKYnFWE/RGQcPJMavPqY0WcxyFa+Z6D1
	 fBjVffIGJ7IILx7yu34m1Y3luj+EGIjAklYph8XorEtL7qGHpG3GROQatbEyGzvgtG
	 ID1W7v2EmO+L6ahqD8hh+AidfPhbYCpOGCuMboHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH 6.1 333/634] usb: usb-storage: Maintain minimal modifications to the bcdDevice range.
Date: Fri,  9 Jan 2026 12:40:11 +0100
Message-ID: <20260109112130.055971974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit 0831269b5f71594882accfceb02638124f88955d upstream.

We cannot determine which models require the NO_ATA_1X and
IGNORE_RESIDUE quirks aside from the EL-R12 optical drive device.

Fixes: 955a48a5353f ("usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.")
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Link: https://patch.msgid.link/20251218012318.15978-1-chenchangcheng@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -98,7 +98,7 @@ UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x01
 		US_FL_NO_ATA_1X),
 
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
-UNUSUAL_DEV(0x13fd, 0x3940, 0x0309, 0x0309,
+UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x0309,
 		"Initio Corporation",
 		"INIC-3069",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,


