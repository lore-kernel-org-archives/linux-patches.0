Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4412571D5;
	Thu, 17 Apr 2025 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912702; cv=none; b=ihGAMB1pRvNEmJapjwx/StInosc7ah0lYr/LL/Yg/U8VcrinRVEdRLBncYB9ZOE8SBs+78T9bkalNw/jo6tks3liaELOuhpHyWOsjMfHBZ94mUiwuv4eAy0pbgN6VMIiexFGMrJeE9aD+3YF8gmRetMhf+8MqnD4gjfMJyAMkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912702; c=relaxed/simple;
	bh=p1tD+KPrSIEURihILIy/QRqNyL/dGT3cyhrPolSzS3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9fsjCg23J5MW06XeNaMreMZoCTe3+zpUUpBtbslynR5suBKeW8lhapxeaBXAFbqjjNonG4KWxXJC/s0sS2EcXvkrOwdn5jIUOAmL/GSROvWzeD3dKw4jEjA7Z5oXpL4Tzpn8CQT4o7N6WZzSOfWpWsD3Jb/EJM+qTExvG6OKU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcxFIMpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcxFIMpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B78C4CEE4;
	Thu, 17 Apr 2025 17:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912702;
	bh=p1tD+KPrSIEURihILIy/QRqNyL/dGT3cyhrPolSzS3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcxFIMpBaO2DQ8mQUtCrp966sWFBYVko6rEUhP00V2w+qqSEGQrgAyzjyZx4nJSFt
	 Y/gJJnUMUteCX0r+LGci3VAiHKKF1/u8p8CPzadHdDBdMz2Uqi/c9/vTfxltVj6Qx0
	 5wr6HYpHqWtoxP6fJEU2en3KqjX0vDEiAmDlSsZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 095/449] wifi: ath9k: use unsigned long for activity check timestamp
Date: Thu, 17 Apr 2025 19:46:23 +0200
Message-ID: <20250417175121.787181022@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 8fe64b0fedcb7348080529c46c71ae23f60c9d3e ]

Since 'rx_active_check_time' of 'struct ath_softc' is in jiffies,
prefer 'unsigned long' over 'u32' to avoid possible truncation in
'ath_hw_rx_inactive_check()'. Found with clang's -Wshorten-64-to-32,
compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20250115171750.259917-2-dmantipov@yandex.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a728cc0387df8..cbcf37008556f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1018,7 +1018,7 @@ struct ath_softc {
 
 	u8 gtt_cnt;
 	u32 intrstatus;
-	u32 rx_active_check_time;
+	unsigned long rx_active_check_time;
 	u32 rx_active_count;
 	u16 ps_flags; /* PS_* */
 	bool ps_enabled;
-- 
2.39.5



