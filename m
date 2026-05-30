Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C83ACA4D;
	Sat, 30 May 2026 16:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159808; cv=none; b=VWCBphLwXURPvKwbvahDOcQEQfWIE/fwG6wgAP5sh0Xp8T/BklDjh9QZ+kHPHi4ZaBPHto1iZn1OK6lmg7YO+hp/LHx3h7TF/mlnJnIEpl4zhTxNwlbuj5WsMWrKmpqjQOg8Yz3JsH0P8ukjpwEBuSEBFvMJve/cVMjl1KLqyGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159808; c=relaxed/simple;
	bh=NTv1NtgtZl/xNXaSSfvHhFLWfg102n3HXCYK2JQTRgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsys2+AOMCOW1j66vGls/21fI5IRom1iFjVwnxyd/FTctl+LbM+Y9JjlQi28+HVnLFwoFUYGnxoTL+h57++QI3TYhJrpCYaQAfIXeBc10fQoSCLKb/fyrfJ0U+D/SUWa2xC52M1FlOiArt89DcUEIFn8jumDwTbFKg1H/pnXfpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPrzrWzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPrzrWzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AB31F00893;
	Sat, 30 May 2026 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159806;
	bh=mLQjEEWVzOfQF8DPJdbrahB7jk/MooZWayiLB0FBz2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPrzrWzxNDRUnH28tCZjTB2dNIFviMFfCnwZzjnDJZvWVUEnzrGAOPqOIr1kkaQVh
	 IL/ee6h+y3GY6KGAtf5fG4V2c4tjADnTp1XufthnIG83WNH76oVV+UgQKrAAVe6tYx
	 E1wlhx7N+aM8qd5ID/Is7Fq/HL4HO8uUHLcIV2nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guocai He <guocai.he.cn@windriver.com>
Subject: [PATCH 6.1 126/969] Revert "wifi: cfg80211: stop NAN and P2P in cfg80211_leave"
Date: Sat, 30 May 2026 17:54:10 +0200
Message-ID: <20260530160304.053120695@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guocai He <guocai.he.cn@windriver.com>

This reverts commit 0c4f1c02d27a880b10b58c63f574f13bed4f711d which is commit 
e1696c8bd0056bc1a5f7766f58ac333adc203e8a upstream.

The reverted patch introduced a deadlock. The locking situation in mainline is 
totally different, so it is incorrect to directly backport the commit from mainline.

Signed-off-by: Guocai He <guocai.he.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1328,10 +1328,8 @@ void __cfg80211_leave(struct cfg80211_re
 		__cfg80211_leave_ocb(rdev, dev);
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
-		cfg80211_stop_p2p_device(rdev, wdev);
-		break;
 	case NL80211_IFTYPE_NAN:
-		cfg80211_stop_nan(rdev, wdev);
+		/* cannot happen, has no netdev */
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MONITOR:


