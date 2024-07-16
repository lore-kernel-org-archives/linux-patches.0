Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257D1CA40;
	Tue, 16 Jul 2024 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144239; cv=none; b=IBljFveTPJ0D06br/Ufk2LQdqeKZS82cqv5z9DkIJpgWgYxxk2MLoVCJ8cI8zei50mrE4PK61juv1YhUPHxymBzlAAuTlmgTKRN2mhDGCdXtWfhRrtJy/mMFkxWcsXxuHl8xY6kkOxoXyVZOZ8JlMvEelDnzQfSs+5U2a8fFmDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144239; c=relaxed/simple;
	bh=fgYgwtZznaUyV12Bjxnux7aNBS4I9AkcZreXp37XOC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxxcQwAcjaCzz+XOt24RsadfFzuaIRlGCorZZLY2y5Iowh59WjEQkB2ti14yxsTp34kahb1YmJFUmQCgGMe3xVvu3z5nPwTzOINyg9Y9msOaTeUVMxeK7DngumWGpsjCBdDs9OG5T5i+FXEdKj85cBtB3M8MnXpPpmBTIXNrcgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/HeS0v7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/HeS0v7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A010BC116B1;
	Tue, 16 Jul 2024 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144239;
	bh=fgYgwtZznaUyV12Bjxnux7aNBS4I9AkcZreXp37XOC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/HeS0v7BRctNpDdSlzSNhV8zc57bRHNvoIDb59QUS3ro5wNHA+Hxz554cBJ7z2QJ
	 jRsXn1mvJasz0kAp0dtzGaL9KLiaguQiAA67+TvwSFvRnshSuMq844lzyBK4MR2oWK
	 vaJJe134JKLsvbeUIULeaZhXEzGMRnVzsx9lZ9bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	jinxiaobo <jinxiaobo@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 4.19 55/66] USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k
Date: Tue, 16 Jul 2024 17:31:30 +0200
Message-ID: <20240716152740.263585829@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 3859e85de30815a20bce7db712ce3d94d40a682d upstream.

START BP-850K is a dot matrix printer that crashes when
it receives a Set-Interface request and needs USB_QUIRK_NO_SET_INTF
to work properly.

Cc: stable <stable@kernel.org>
Signed-off-by: jinxiaobo <jinxiaobo@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Link: https://lore.kernel.org/r/202E4B2BD0F0FEA4+20240702154408.631201-1-wangyuli@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -504,6 +504,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1b1c, 0x1b38), .driver_info = USB_QUIRK_DELAY_INIT |
 	  USB_QUIRK_DELAY_CTRL_MSG },
 
+	/* START BP-850k Printer */
+	{ USB_DEVICE(0x1bc3, 0x0003), .driver_info = USB_QUIRK_NO_SET_INTF },
+
 	/* MIDI keyboard WORLDE MINI */
 	{ USB_DEVICE(0x1c75, 0x0204), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


