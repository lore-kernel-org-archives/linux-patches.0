Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC14A3A9622;
	Sat, 12 Sep 2026 18:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238195; cv=none; b=J9kCbzESnJhOS5whX/gm0+oFe3UE8uW1xUl2Hi/iP3ePazouKBMVSvLm/VHHuYTqgXCOKOuo/RaGxTcguwH28o53aeDMgz7bbtAU6vb6q0VHYoXbMju9l767nkPZ/juKcmgN0B1yosmFAS47XWY+uWEeYMOurNlNWNJtIftZBSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238195; c=relaxed/simple;
	bh=37QlEErUzoq4FgIaK/OC+TcSbehp0RQd5UZq0wQxI5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEQeQ6vZK6UmJkQSSkakkxiquTxiGdsaLkXwkt15hc0IkAqITijzarizIyKjlcGD2d7MNd1sUiP0pwTxlAv74RFCaRI07rRYAwR7Gs76vksCnCqQHfr34kk16NJpQC4O6Jd8gE2Oa2hLA9vFDxLin/sbQfFArJkaXBkqatmRgXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUJL8fUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUJL8fUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7901F000FF;
	Sat, 12 Sep 2026 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238193;
	bh=mC9X8InwU9CfJ5FJz0RlZHdmmj7MyUW4NItCO22tKi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUJL8fUlQrxbldNqar+h8dgH+03BCn3Pt5MBpLokTozfFhGNI9kYuA0vr1W0jhdE/
	 LAnaZ3soHjSFettvS2rq5Mq47QiqzDSQi3uC5z+HS3dL5JewuIsb06QS9MGHjstnzu
	 9/Oj1EvAkGTW4crwoXWUmltTq7/PGr3PGrvg4lrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/935] media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define
Date: Sat, 12 Sep 2026 08:57:23 +0200
Message-ID: <20260912065536.296371327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 793b54342dffe..1eb9a93330036 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -306,7 +306,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
 #define RC_MAP_PURPLETV                  "rc-purpletv"
 #define RC_MAP_PV951                     "rc-pv951"
-#define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_REDDO                     "rc-reddo"
-- 
2.53.0



