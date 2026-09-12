Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9270337883C;
	Sat, 12 Sep 2026 19:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242296; cv=none; b=BAf5DDZTPcId3ZAxWikwPczI+YJeJmPOlDyANiDpy6aqjyP0m7PHWnFw+u/Ev7mwmLw7yjvg46pvw0tzzEVEn2ZTuGP2Qw/hV5GZplRVwkV34tqpE0Mj9m1PFNRIk9LLZfi5pJs9qWRRhXOS8snLcG6+PDIVMj6Kmi96CPO3ylQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242296; c=relaxed/simple;
	bh=3ZLy4f5irsiSPVVfTUo8C8Vs/D1DTgeJa3vnvuW7qSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POB77YeXNXZ8gW3lRi+3Zf/f96iTgIRBYsW9uQ039pZYq9yswtg96/5AnVT7YkoplZsiLXBWyKDGo/pK83OQsGX5iaJgxA3COiLBVo53rDa2xYWJ40fZRSpuqi9OSZ6q+CzvH9B0tO5j/ITKLVukfJ9kyJBjzQkfyoqJZhoW2+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcAzTxDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcAzTxDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5FC1F000FF;
	Sat, 12 Sep 2026 19:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242294;
	bh=I9huQuk2J1OCriCX4b5b0NkL3CFjIMh6hAo4L+RYrhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcAzTxDBKSVLmHTHfRr3NyukUMxvHUiVcODIVV5YA3Fhl1sQNB2IcIxwAC+/Ycn0h
	 UX+AW/IGiReWjM60zZn4hN24ChD9KxtFYmKgrkqJt2ARY1UR2q9s4CjOiXqTFWfXko
	 zjgCRy0Ll69upWS34EPhWV4B92DwJ0oohYtS+dZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/798] media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define
Date: Sat, 12 Sep 2026 08:59:42 +0200
Message-ID: <20260912065525.275254225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c3effcdf2a641..3e01cb92feb5a 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -300,7 +300,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
 #define RC_MAP_PURPLETV                  "rc-purpletv"
 #define RC_MAP_PV951                     "rc-pv951"
-#define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
 #define RC_MAP_REDDO                     "rc-reddo"
-- 
2.53.0



