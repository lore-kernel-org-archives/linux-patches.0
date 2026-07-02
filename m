Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4CC3CE49E;
	Thu,  2 Jul 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009723; cv=none; b=Ay/mVoOQ7PVngBwstwWluFbazMUB0nKihasGg0SQYnMM8a1vozawzhpXrRitP+Jv8Wy2FjxLVyxzh8fuOE7PHzmDvrsmugFWxl/Fba1EVbeAwbPu5XOc1tbn2BaJP6LQuP7ftMJ08ImY0sE/VFrNhlFDw7Rl3T2cdv+f4RSRB7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009723; c=relaxed/simple;
	bh=UBYgZZoKcO+EtcrlEmbL29MFLT96zl2gsNglBrHGi5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1c3ipL7i06HCymmyTSonOJPySHXRQNq5SsORNGSq+U8FTg89wxdbvLF+R76j8YQfFBs5+FFrqgEvJcC9fqwjBnYR7yISMY+Xsb59nWPmvwIJdN3Sk9h16hlXrRIjkLLse3I+RKY9eGYWQiR8YLI+8BaQ8+ALuYIGr8xC49OMCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTT8LPc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTT8LPc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AB61F000E9;
	Thu,  2 Jul 2026 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009720;
	bh=GMCMjqpHIvUvAhwaQYdqVbACkha9YMUGTATjKDn2bW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTT8LPc8K68SW1+wI0mXm0KTlHx0p4UH97r0Xcny2Bz2VpG1Q12AckCvjzbq+kimJ
	 nOvDn6Bf5dqRADmgBWFPKoLqY8LYx5nUbMJUK9wxQtGk4mgyn65JuyLXROl20SACTk
	 FnmT3HvITWpTypprElhvQQH6KfVxtVhv8ufh1onM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.15 62/95] wifi: rtlwifi: rtl8821ae: Fix C2H bit location in RX descriptor
Date: Thu,  2 Jul 2026 18:20:05 +0200
Message-ID: <20260702155110.515408197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 83d38df6929118c3f996b9e3351c2d5014073d87 upstream.

Bit 28 of double word 2 in the RX descriptor indicates if the packet is
a normal 802.11 frame, or a message from the wifi firmware to the
driver (Card 2 Host).

Commit f5678bfe1cdc ("rtlwifi: rtl8821ae: Replace local bit manipulation
macros") mistakenly made the driver look for this bit in double word 1,
causing packet loss and Bluetooth coexistence problems.

Fixes: f5678bfe1cdc ("rtlwifi: rtl8821ae: Replace local bit manipulation macros")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/04da7398-cedb-425a-a810-5772ab10139d@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
@@ -291,7 +291,7 @@ static inline int get_rx_desc_paggr(__le
 
 static inline int get_rx_status_desc_rpt_sel(__le32 *__pdesc)
 {
-	return le32_get_bits(*(__pdesc + 1), BIT(28));
+	return le32_get_bits(*(__pdesc + 2), BIT(28));
 }
 
 static inline int get_rx_desc_rxmcs(__le32 *__pdesc)


