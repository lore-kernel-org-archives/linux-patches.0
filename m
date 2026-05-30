Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC7F261B9E;
	Sat, 30 May 2026 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163236; cv=none; b=MZDnbMsB/sR+RCNA5YK+ZdBx8LlrEd7FzDUgzixNxDR0M+oZeCA4BYgBXuv5E6tYvBLeRGPfbkjfnelGF+QJhqD+/+eIGE9Hw4SarDlG4wVeVDO7ZL9RujiRgcZsSzmj+KaNHCHlyXbPbcd67VJbmR9vxH5KOcRw8XjKQui0rQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163236; c=relaxed/simple;
	bh=/m3lrlD9bCiCV67Iekjzg+To3S2rGePYBnsFODtD0VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlsSQqox9+++VUQ7JFnXpRz71ZqCKjxHyj2s38hPbX+ysPk3tLM6AhLX/CUWufvQDmMdGwn1nSw6Tqu5gcGDsV/KkpRjciKGGgQRU3orRV8syb4uXX3iYs+hfmZN9GqJc/5lGhcSIBZU5PoJXnuAbrTBGaaLad8Z7WuXuF/uqi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnQo97R5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnQo97R5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D341F00893;
	Sat, 30 May 2026 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163235;
	bh=R6Yobmy8jb9rfvVvA1cGcOm137DUKyTG2Ad9Us9R2zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnQo97R5xDHQQl94+G1iRnhIgS/6w/FMeLLaP/YkVuTStLcUZS+kuZpexWgYM8M9g
	 La+qTdb07O6dfE0mt5QqFJansf+Ki+DGegqaaR0DAx+ekse1o4O1VQ3MY1hOOdBPJm
	 de4NfKPR9oQC6iCPsqUh+kV2dZiM9JVkmzLdA4gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guocai He <guocai.he.cn@windriver.com>
Subject: [PATCH 5.15 164/776] Revert "wifi: cfg80211: stop NAN and P2P in cfg80211_leave"
Date: Sat, 30 May 2026 17:57:58 +0200
Message-ID: <20260530160244.730320826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Guocai He <guocai.he.cn@windriver.com>

This reverts commit 31344ffecd7a34335ce2b52e8c205bce3cbfca4b which is commit
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
@@ -1300,10 +1300,8 @@ void __cfg80211_leave(struct cfg80211_re
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


