Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23A12D47F1;
	Sat, 12 Sep 2026 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222467; cv=none; b=gnyRMoCia1+cmi0Af7i3cAzKEXyzchNkiyt0aX90r2+q/aPaL2KNrCejimKY4sEx3i+F2uoHUEei6Zva5JxJ/OlbSFleggyF09yA5gs1y3zps0hlSX1RqPOBvvBBJmmryf32E/Ex6vHrYNQEqgEM1R65JJHISfs85wdH5EasdGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222467; c=relaxed/simple;
	bh=0kqa7TYxQfoPQfuoLfQBjtFwn8rXmzdtuv6RlfG0cwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBdy1mr/hQjF5+sVWlfM0OOLwfoSJ1VGCDvxmI9n1oFjHk+vsryxSVGHDoYhlx9e0jaPbHlC7qofKkV3gAFRuvHOEZbzTXpMkNaDibbdFtbCX5Uw3NRQb+GJOpkpAn3/4M0w/5q/fXNUSWJLerLRuqmdng8QMl2Z3BjIbyM9a3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY7DNs5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY7DNs5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B47F1F000FF;
	Sat, 12 Sep 2026 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222466;
	bh=G2g2fgwC3vGtmXRFIQFEiJivsEn5PtkR5gduKVoRo+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iY7DNs5RP24dyULF9NkuR9eHqtHHSJrQf6hc/ayqwasQSeBk74WEejFLe4XjCyrZO
	 uAsE4XOJcYHHWQ+8wJV2ANIpJPohBJSgflAFChEdUL45Ccs5SfRsBY15+2V1fIlZIp
	 5bMmk+1W7t8HLMoB4pw3Qj+zzO5JCV08ZgCnQlB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0593/1424] media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define
Date: Sat, 12 Sep 2026 08:50:25 +0200
Message-ID: <20260912065620.572016864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 5370facb7b4461166a4610d456fefeb92ef50a82 ]

Since commit 206241069ecf ("[media] rc/keymaps: Remove the obsolete
rc-rc5-tv keymap"), the rc-rc5-tv keymap is no longer in the tree.

Fixes: 206241069ecf ("[media] rc/keymaps: Remove the obsolete rc-rc5-tv keymap")
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/rc-map.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 4676545ffd8fa..e26e3577d11d1 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -308,7 +308,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
 #define RC_MAP_PURPLETV                  "rc-purpletv"
 #define RC_MAP_PV951                     "rc-pv951"
-#define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_REDDO                     "rc-reddo"
-- 
2.53.0



