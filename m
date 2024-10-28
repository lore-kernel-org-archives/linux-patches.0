Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F7B18E05D;
	Mon, 28 Oct 2024 06:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096923; cv=none; b=Lwj/4O9FMtRDKEzy/wd73wPLbP05jQrPc5iCbVfkVsq6zyKS9UY9633IEABkf2mA4f7Fy3EQ4ooy9r0xHDl4V92dTrEfNwCDYe1J3sdcxGseLRLAUKXt2n36XGIqKsbj7AaWUy/XRqURcjTS0hQLZK5l192EB2Dk8SDxQiDPtmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096923; c=relaxed/simple;
	bh=FwqZmJcmtMN7XeA+2gXdpw466q1rrl7FAgJZVJ7SKHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TrjzPX8XJSk6Kxp2G66nxY7gYrVLaZeqmY06vBOGUE4cbw+IMEAL8gCXFzkIopjPNvxSQ+Gqxi0mub9/cJbrcusvNXrPo1KgfsXVo+/LfVhehVn+uRx7hRoC5MnF2Jdab+YtfVza3BQa6asn7KF+gcaLC8NrpaTO+B22AssIrWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQMOzYXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQMOzYXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F634C4CEC3;
	Mon, 28 Oct 2024 06:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096922;
	bh=FwqZmJcmtMN7XeA+2gXdpw466q1rrl7FAgJZVJ7SKHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQMOzYXzVxMIGjzitVTFUzWO+FwHh+Y4aX1vDMSxfG0urcYskLpElT+NNMfz39jJq
	 svfDTJOpXuSpC48XGnar+Maog3tGIPGTA5jJtYDl8i6aZ7DzvnUZVdlvupzQT+ap46
	 zDJAStwFUMP4SsrlBpMmNGgUoqP+CYY47qUFDQTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	siddharth.manthan@gmail.com,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 46/80] platform/x86: dell-wmi: Ignore suspend notifications
Date: Mon, 28 Oct 2024 07:25:26 +0100
Message-ID: <20241028062253.899733468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit a7990957fa53326fe9b47f0349373ed99bb69aaa upstream.

Some machines like the Dell G15 5155 emit WMI events when
suspending/resuming. Ignore those WMI events.

Tested-by: siddharth.manthan@gmail.com
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20241014220529.397390-1-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -263,6 +263,15 @@ static const struct key_entry dell_wmi_k
 	/*Speaker Mute*/
 	{ KE_KEY, 0x109, { KEY_MUTE} },
 
+	/* S2Idle screen off */
+	{ KE_IGNORE, 0x120, { KEY_RESERVED }},
+
+	/* Leaving S4 or S2Idle suspend */
+	{ KE_IGNORE, 0x130, { KEY_RESERVED }},
+
+	/* Entering S2Idle suspend */
+	{ KE_IGNORE, 0x140, { KEY_RESERVED }},
+
 	/* Mic mute */
 	{ KE_KEY, 0x150, { KEY_MICMUTE } },
 


