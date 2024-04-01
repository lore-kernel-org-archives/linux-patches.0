Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528313D961;
	Mon,  1 Apr 2024 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988901; cv=none; b=IstPl9JKW+MQWa9k23vHyTG3ZuQHkem6f0OB81qvaxfudTiXaHEgpOkQZxykRgcA5NNrpW9t09Dl5PBHpim5KxxRlF36+3OzTPRmJpfOm2lcdVJTEK0MbfNmfvIqyU6Sior4sCzREb46cLlCoxbtIBsJRwll08S+CgkolHsm1h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988901; c=relaxed/simple;
	bh=f5tfg6kTOXlazx3lnRRC5iDH/jOsgLTv0n2tunBkODY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyC+gfWUzbyoad1gWcNSxc56gQpqVLtsY50ALDI5TdBM+DVfarG0RJ2gUTMgNY7CremKP/jWROCwhWq1PiNkrvRTtefHqM3wc0ebIOWBngTRretQvJLbEl1q8Z2khqHXMDxJLEr5GMuMrEsQZPHZ0tlXxqhsumni7Mp5fXWXsE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuWBTq38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuWBTq38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B673AC433C7;
	Mon,  1 Apr 2024 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988901;
	bh=f5tfg6kTOXlazx3lnRRC5iDH/jOsgLTv0n2tunBkODY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuWBTq38ukHlNJI683Unu9mDPzfFTADh7hrwpGRq1kKIhHmAkPtUOQ1UoQ3cpkTjt
	 P/qvW+6k7WsAsEPCfqBP4vCgB4iBp08x2r9PuddMf8m0QvqPxv/uZQKWUYKO24NI/G
	 q0nHdk+PtbOoOwxuMEf2dDdRP1PoJBA8b5e50Vxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.7 294/432] wifi: rtw88: 8821cu: Fix connection failure
Date: Mon,  1 Apr 2024 17:44:41 +0200
Message-ID: <20240401152601.938804083@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 


