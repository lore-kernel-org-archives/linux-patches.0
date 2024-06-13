Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3706A145FE1;
	Thu, 13 Jun 2024 12:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280341; cv=none; b=mG+XtT7VX0MZi4mIXYabAgdhZnLcNCtkQAaL/qBfTi0KrMSyN8cBlNU0U2swaswtwChGyBmQsGeqs/zQf0sT4+pWfwa5GuSyTFlTKjBKzJNpoWwY2bzz6ehahW00znLsarFEZPogH9klNB0xzmWd1rhgeU3N9JPABvJpafO+xxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280341; c=relaxed/simple;
	bh=9Xl0S9+4uJDbQNbDCeD52QcpXLDtzVa3Tu/Pd9kwDPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfaP8eUMPBFvvcng5QkcHmD22ASiJqnGBn0BGXShowtZC0Gv0dKWisdrulpS1ekWi4SNyvY+Af6/Bxv92qi1r3/xGjW4DfvllJ1yohu6l3OqkX5Ar50sH7EOa/hasrpZ1P3TqFW9rNvXCkncZ3WLwPxgemOj/HH6WutHG0GZ1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfA46ykn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfA46ykn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FD0C2BBFC;
	Thu, 13 Jun 2024 12:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280341;
	bh=9Xl0S9+4uJDbQNbDCeD52QcpXLDtzVa3Tu/Pd9kwDPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfA46yknKxBmECt6hop47GV+NObFM3GplzGThzyIyybfCUWJGveOOMZVDFJgdAejk
	 4uFCxjifNgZ2pQL0Tzm9dMO0GJVg8WXT4pJX5V63hpuphy+U+bMP10aLvaBuDoI3VX
	 OT4ZImIpZGpzdAAAbWkvswnL/KU3++a2of+GOXbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 021/137] wifi: rtw89: correct aSIFSTime for 6GHz band
Date: Thu, 13 Jun 2024 13:33:21 +0200
Message-ID: <20240613113224.111267386@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit f506e3ee547669cd96842e03c8a772aa7df721fa upstream.

aSIFSTime is 10us for 2GHz band and 16us for 5GHz and 6GHz bands.
Originally, it doesn't consider 6GHz band and use wrong value, so correct
it accordingly.

Cc: stable@vger.kernel.org
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240430020515.8399-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -303,7 +303,7 @@ static u8 rtw89_aifsn_to_aifs(struct rtw
 	u8 sifs;
 
 	slot_time = vif->bss_conf.use_short_slot ? 9 : 20;
-	sifs = chan->band_type == RTW89_BAND_5G ? 16 : 10;
+	sifs = chan->band_type == RTW89_BAND_2G ? 10 : 16;
 
 	return aifsn * slot_time + sifs;
 }


