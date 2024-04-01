Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEAF3F8F4;
	Mon,  1 Apr 2024 16:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987317; cv=none; b=Eg9suTJY0XG8lDYVpWKrthuVD0SnrKbV6FUAfV5XfoNurVj5LgM1OgiZ8NxB1NcttarfvIZT8R4kGtkr4Y8D8kB+yJ4S3Llc2nqp9tAAK6oU2HlATiBFSURLtkAsHVBBAf3srThLJoBB7wRgFE/CNydnpBDAi+LvIvqtRJu6Dow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987317; c=relaxed/simple;
	bh=xsUttKnpPzWA4Rvg8rIDTzNaqHGM9NRSJsVI6OFQdq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAs5izFtAvve786O28yxcLG1ByTo+DbUz1cjSYv5jBfNCCBC0C4YwdV1UyvZ+6DwwBbLJzStjTP/fcO4p34Hbaujh/m6buDY8SUdKARBVIC26Cfn9vjPSwzRIWNHZVlUoku3wICKRks6OtT1T8ai3BTZTLnVSekLDKnnYwyK+s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV1+eGzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV1+eGzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61859C433C7;
	Mon,  1 Apr 2024 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987316;
	bh=xsUttKnpPzWA4Rvg8rIDTzNaqHGM9NRSJsVI6OFQdq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vV1+eGzLn/2ovUa6dLDaXXC2vFqwM0i5ik36ezSh5qvHngNCe69Kz2Qsr4S+/xOSN
	 QvZB9K1AX81SnZ5EuQ/SzmSbOOgoKhT9zOMOTwl9sCBu6LdbwUZJcVuxjeGP5Afmt1
	 EgB328pxbjTopiBDr7O3n/fkqS1QBj+E31BFwN7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.8 250/399] wifi: rtw88: 8821cu: Fix connection failure
Date: Mon,  1 Apr 2024 17:43:36 +0200
Message-ID: <20240401152556.632487468@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 605d7c0b05eecb985273b1647070497142c470d3 upstream.

Clear bit 8 of REG_SYS_STATUS1 after MAC power on.

Without this, some RTL8821CU and RTL8811CU cannot connect to any
network:

Feb 19 13:33:11 ideapad2 kernel: wlp3s0f3u2: send auth to
	90:55:de:__:__:__ (try 1/3)
Feb 19 13:33:13 ideapad2 kernel: wlp3s0f3u2: send auth to
	90:55:de:__:__:__ (try 2/3)
Feb 19 13:33:14 ideapad2 kernel: wlp3s0f3u2: send auth to
	90:55:de:__:__:__ (try 3/3)
Feb 19 13:33:15 ideapad2 kernel: wlp3s0f3u2: authentication with
	90:55:de:__:__:__ timed out

The RTL8822CU and RTL8822BU out-of-tree drivers do this as well, so do
it for all three types of chips.

Tested with RTL8811CU (Tenda U9 V2.0).

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/aeeefad9-27c8-4506-a510-ef9a9a8731a4@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -309,6 +309,13 @@ static int rtw_mac_power_switch(struct r
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
 	ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
 
+	if (pwr_on && rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB) {
+		if (chip->id == RTW_CHIP_TYPE_8822C ||
+		    chip->id == RTW_CHIP_TYPE_8822B ||
+		    chip->id == RTW_CHIP_TYPE_8821C)
+			rtw_write8_clr(rtwdev, REG_SYS_STATUS1 + 1, BIT(0));
+	}
+
 	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO)
 		rtw_write32(rtwdev, REG_SDIO_HIMR, imr);
 


