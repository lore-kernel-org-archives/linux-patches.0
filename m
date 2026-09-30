Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A190511E61;
	Wed, 30 Sep 2026 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789821; cv=none; b=fQTkBT4JialbefcmyrDMXhqCVqvi76o0pEGIlBPsOjZDuPDnUY5P3fDQqh6oECtDy9bJu9K1GaAvOJS5Iz/qVQpeuO1ZX9t8QJLZf+L4sX4q/Veuk1UxoB3yM7lLrJxdUG5jEikdKRh8TQ15FNTcTk67dN6YZjpRqxiGekXE5/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789821; c=relaxed/simple;
	bh=m4HfFbOnMdi8gGti8ULgEuQD5IcwpC6xPoUW0FVQS00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9ffWabSMRpgu7VkRbHyJVN4Yabg3f71dWz6Rq+7JnjoZjCcXwpnNe7QqYcqcrGTi/HdP5vGaBOV0r0xUv6u98Kz8COvTDho1UAOHHXLXLIE49rn1648XXiNt1IhcCCGM8fV5KU9G8a/Mj27IfYfesC9Y+PPwKfktpvB29zadO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbQfDXbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbQfDXbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65681F000FF;
	Wed, 30 Sep 2026 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789820;
	bh=nO/0DtGfeGBzY+gw5KlVLsLl0tv5TS3d7yJKEQB2uGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbQfDXbo2fR7DWAv6g+NMptj8bLixIZc22t5Kms/aqw+xTZ8i/75aS0AHOLAwQLs/
	 PvxA5iZalibbnCqnHiDx+WiNIb8jigMkQW61W9jiZYZp603LFxzqCVa6qztiQHS9s+
	 /W5YIKamhZl1g7RNg5ZJFQfEqZFP+1IP2po75F2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 612/877] wifi: rtw89: cleanup unused rtwdev::roc_work
Date: Wed, 30 Sep 2026 17:25:23 +0200
Message-ID: <20260930152427.861170269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit c281bdb8821461047d3e74206afbff190d1f7846 ]

The needed one was moved to rtwvif::roc_work. And, rtwdev::roc_work is
unused. So, remove it.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250120034004.21135-1-pkshih@realtek.com
Stable-dep-of: 667c12782aaf ("wifi: rtw89: pci: add .shutdown callback to stop rfkill polling on reboot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/core.h |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5604,7 +5604,6 @@ struct rtw89_dev {
 	struct delayed_work coex_rfk_chk_work;
 	struct delayed_work cfo_track_work;
 	struct delayed_work forbid_ba_work;
-	struct delayed_work roc_work;
 	struct delayed_work antdiv_work;
 	struct rtw89_ppdu_sts_info ppdu_sts;
 	u8 total_sta_assoc;


