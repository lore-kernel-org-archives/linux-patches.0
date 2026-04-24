Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D14F3D3D04;
	Fri, 24 Apr 2026 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037973; cv=none; b=s/zTAOMXtJo1O/K3lDV4zG/oYWLrUyoGZIe9olsPXZ/tBlJjeV6BiyHo31xwfJ7Qaj2VJylijJf9MNg7Mi/wopt10XBbd/29sYtXRhezQULtiWl6ydDIgpMkGzueIpen/SqjX8gjTsds1xLGlUXhlAS00aLpR+S1lZUMtv31OLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037973; c=relaxed/simple;
	bh=I/meAe6kDApYo5lrY798B7D8WR3CmUknUcA3JpMctiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYEHiF0AYY3pwwkX1G3mKDS2wcA2ih0RC/NBDJD4cQ6ZcLBmUfbov2SaZCrD13920JgAeUG/CFL8Hbeq8JBIlvOjE/j4GWMTp5HywN7yM5dwiXnzWM1370IhqvasdR+q9Fr7qmk4rvyLSYJaW52YuFd/M4PsBY77Yh/RUqrmMcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGkHp4af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGkHp4af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA74C19425;
	Fri, 24 Apr 2026 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037973;
	bh=I/meAe6kDApYo5lrY798B7D8WR3CmUknUcA3JpMctiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGkHp4afj6uMF4mnYpzNJn69jcyc4d7ixBerm1BBW2XyjFDOazV36MUpAxzO0nbb1
	 mqWGBBbkmDZKjYT4gBHZloLxOZhHQRlGzyUiBBAGfG1nbLrAZp49yWD9/6HmXWpAkY
	 udspaehN79Op47AbB6MfwS3UPChjTDglT0U3RBe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guocai He <guocai.he.cn@windriver.com>
Subject: [PATCH 6.6 141/166] Revert "wifi: cfg80211: stop NAN and P2P in cfg80211_leave"
Date: Fri, 24 Apr 2026 15:30:55 +0200
Message-ID: <20260424132602.509552113@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guocai He <guocai.he.cn@windriver.com>

This reverts commit 4d7a05da767e5cbcf4db511b9289d7ebd380dc56 which is commit
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
@@ -1332,10 +1332,8 @@ void __cfg80211_leave(struct cfg80211_re
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


