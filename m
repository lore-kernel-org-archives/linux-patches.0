Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988B12F234B;
	Tue, 17 Jun 2025 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175899; cv=none; b=QZe3XXjVBwctmqB2UoTae0JPitvnJxqLId+N/z4RP1LqYG+TNHrQhDfcJcTlOQd2yswej73eEDnykvQO6fTZZX/femudGmYD4ZwIoZmGdhSMxFuHrfq8RDcMK3qqcU3qTkL+4pMLSesdxeZdJkXCzidOmXzko3a3B91lQQdAmAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175899; c=relaxed/simple;
	bh=Xl5P2/RghofKFrLmZNEmFs0yCmsb8CnIDJGgCkR5L24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=it29ceuzrz2s/8nbLHAto9EgWDoJSZ/J8I6EA3Gm3YFZjuad3TQq+QnqwRpje7vJWR0QtodfHK6NjP1cTigXxJ9LPR2rIYS317CCAnPbFntkCurLwQYOp2+x5DvFXyjL6RDDecBBpew3tu1sq/cZ8QU0viYz9mrGfzdq+Nkj4VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRa0rDxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRa0rDxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98831C4CEE3;
	Tue, 17 Jun 2025 15:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175897;
	bh=Xl5P2/RghofKFrLmZNEmFs0yCmsb8CnIDJGgCkR5L24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRa0rDxo4aeba9c/YwkICsG9YeLP67TIu5SyjPTdW3tN4E+u9OYL+aUk0jE/6GASa
	 XkAFrde882TmDdgJdErhTWVLykwmHYtsN6fIzNWaWzGOSseg0VbLFH9iioR+yoHAZs
	 8McyW3sVOyKDQD9iHECIYivkjIfh+havDNkHL828=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/512] wifi: rtw89: fix firmware scan delay unit for WiFi 6 chips
Date: Tue, 17 Jun 2025 17:22:19 +0200
Message-ID: <20250617152426.636286807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 3cc35394fac15d533639c9c9e42f28d28936a4a0 ]

The scan delay unit of firmware command for WiFi 6 chips is
microsecond, but is wrong set now and lead to abnormal work
for net-detect. Correct the unit to avoid the error.

Fixes: e99dd80c8a18 ("wifi: rtw89: wow: add delay option for net-detect")
Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250513125203.6858-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index e5c90050e7115..7dbce3b10a7de 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -5016,7 +5016,7 @@ int rtw89_fw_h2c_scan_list_offload_be(struct rtw89_dev *rtwdev, int ch_num,
 	return 0;
 }
 
-#define RTW89_SCAN_DELAY_TSF_UNIT 104800
+#define RTW89_SCAN_DELAY_TSF_UNIT 1000000
 int rtw89_fw_h2c_scan_offload_ax(struct rtw89_dev *rtwdev,
 				 struct rtw89_scan_option *option,
 				 struct rtw89_vif_link *rtwvif_link,
-- 
2.39.5



