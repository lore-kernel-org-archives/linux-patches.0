Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CB5219E0;
	Mon, 23 Jun 2025 21:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713766; cv=none; b=EueXCqUepAP8ZUOa8vFLpt2dPWVb/SwWZoKgHB/EetMwcxD0gLyPhu18qc0EF5FC8x7lR44BZXj68uzDAnz0ToCxq0A1CTMzaonaYQhdWHRUBBa3mZoyADPy5hJpgSnSxzgmjL7+Xh5UsGO03HROarRq/V30cK+8HfPerVuBqLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713766; c=relaxed/simple;
	bh=o4nMq1IsqNMuy5Y5PXwfr72n7RrdPebQFeBzQ9M53pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoCOHmaQZKpxK2sYa5KIYjyTdrNbZa+TNrv341QNWu5frhBKTA09dWVQCLlPRMl4iAPcWYs6wjIovOfYZUH/mYN67eS0TkE6vj/u4Z8+F8VNBS9OxaeekagrXdAM6eD96Y6N2RXDuShY1u7Qe5X1cTyNS67j4gOBA6TIO72rWMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcZvvXwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcZvvXwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB2CC4CEEA;
	Mon, 23 Jun 2025 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713766;
	bh=o4nMq1IsqNMuy5Y5PXwfr72n7RrdPebQFeBzQ9M53pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcZvvXwRJd9BQ9trjIjzMS8xhDGDuY7bv8mNvV2CB77PY6RIfRdFkvkLIA5+mhHbV
	 YJRYb0g3F9TQX1yhd7GpLJNJPP/IL5DfDRezf2R//UV6Ymr61NGuwFafQTZjWjdnHv
	 ge+BMdLUiz8JLyDCHbcX6MU9t5+6zD3D3vpc3kDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuuki NAGAO <wf.yn386@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 364/592] wifi: rtw88: rtw8822bu VID/PID for BUFFALO WI-U2-866DM
Date: Mon, 23 Jun 2025 15:05:22 +0200
Message-ID: <20250623130709.100857442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuuki NAGAO <wf.yn386@gmail.com>

[ Upstream commit b7f0cc647e52296a3d4dd727b6479dcd6d7e364e ]

Add VID/PID 0411/03d1 for recently released
BUFFALO WI-U2-866DM USB WiFi adapter.

Signed-off-by: Yuuki NAGAO <wf.yn386@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250503003227.6673-1-wf.yn386@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822bu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822bu.c b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
index 572d1f31832ee..ab50b3c405626 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
@@ -77,6 +77,8 @@ static const struct usb_device_id rtw_8822bu_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Mercusys MA30N */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3322, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* D-Link DWA-T185 rev. A1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0411, 0x03d1, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* BUFFALO WI-U2-866DM */
 	{},
 };
 MODULE_DEVICE_TABLE(usb, rtw_8822bu_id_table);
-- 
2.39.5



