Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8618DB24;
	Mon, 10 Mar 2025 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628462; cv=none; b=e/lAiPZD0f5z0o1XP8Lc6mJcjEF+VeorBAx45rliwXoFLKmAGyy/uyTdfiYkFWIP/q9gywJOPshCUKtjbzGpm50jbVuLooKOWypS1BBz1fJ7Ehm6kLf72eiWS0VB3KvRT3AFTIMBBPW4dFL0g1Q9rU5pd3FWnsTBiSxPZ1yO3YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628462; c=relaxed/simple;
	bh=fhrpq1IWht6thd5YMuAQho0iZO+vEj+m+CQO9tPrvJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXRoNwVdCSxsTADNJSxCbe7FEkJin87b6rjCOijNYX/HJvSabNwhCe0KKpHVRD19KSom+LjeA4EN3jCxGLDv+qoWW4mK+aZFJl+Dox3DfU7nIedbNQ+l2G9wyqvu8+5MkLVJK5KtMY6pLf5sRsWcUu+cw5/7+/4b9DkrM5H36OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2p8yyQ8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2p8yyQ8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDE1C4CEE5;
	Mon, 10 Mar 2025 17:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628462;
	bh=fhrpq1IWht6thd5YMuAQho0iZO+vEj+m+CQO9tPrvJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p8yyQ8+PyJ1MDJ7MTZE3p2z3WI/9FSNRXPcbPLpFbZF1lJLGyDsC7wwSXQ+X3yPj
	 tKUhftskMVZw6Jg3uiqSnuLmB6Zz68xxlexYQYJmuq44c8cO+wZzEMft96Ji7Xh7wd
	 krlXkQUViQbI6OxO72kCXK9xWXUEkUaw2dkk+A8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 067/109] usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader
Date: Mon, 10 Mar 2025 18:06:51 +0100
Message-ID: <20250310170430.231389741@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit ff712188daa3fe3ce7e11e530b4dca3826dae14a upstream.

When used on Huawei hisi platforms, Prolific Mass Storage Card Reader
which the VID:PID is in 067b:2731 might fail to enumerate at boot time
and doesn't work well with LPM enabled, combination quirks:
	USB_QUIRK_DELAY_INIT + USB_QUIRK_NO_LPM
fixed the problems.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250304070757.139473-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -341,6 +341,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0638, 0x0a13), .driver_info =
 	  USB_QUIRK_STRING_FETCH_255 },
 
+	/* Prolific Single-LUN Mass Storage Card Reader */
+	{ USB_DEVICE(0x067b, 0x2731), .driver_info = USB_QUIRK_DELAY_INIT |
+	  USB_QUIRK_NO_LPM },
+
 	/* Saitek Cyborg Gold Joystick */
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


