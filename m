Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D472D47F1;
	Sat, 12 Sep 2026 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222472; cv=none; b=jMqZsERLVjy2vXciX/ECI/y6HgsrnQ1jpZHPkmKxmWIv5uiZYwzqI/rFSc2bARX6YAYM96Oa8r/tYi2KqZXtFXiScpJhZZCcAwdL/NAsjT7phfgk411dudw8iJrhRgUZxq71xeiibC+hvzcULd2YkVXoB7mlEbEz+muSDwkYFGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222472; c=relaxed/simple;
	bh=seg1sc6mvihY86pHNXIKfjJIQXk4ZiXbwoGdyHOWbFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOg1Zax7OuVxsYGF9I1enmenKQ9gJhN1q4tBgASvbSFSGv+dPW8hrONDq4l1nvAoANymCikqAGYSmRoIzek34iFg7tpsFldOomU4Q9flyYTjoBQuZUwDbLR2Th5rxKQ4f6UoNrFW/O+/MK+HxUKVZOL97HALfUWT/css0M6VJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tsBZD0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tsBZD0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F9D1F000FF;
	Sat, 12 Sep 2026 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222471;
	bh=opF0F/KBqx6WwlwiA3UdDQjn8jJuJyJL3Fus3ECLpfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tsBZD0J3hyu0n8wxA8bVDgAseliQPjfUlchzfcj45CBesTbQQ5cQpu6BYZWhnF3b
	 NY6+uwcPR+49cyHzFLJLdKDgB4sZLJecnhODhD1q46N0uKj+GvPTDUychl6lK9Cpq6
	 z4nZGUhzfpkk3zetpSSi23f9iuA1z+d3xCx2EL54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0594/1424] media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define
Date: Sat, 12 Sep 2026 08:50:26 +0200
Message-ID: <20260912065620.594130737@linuxfoundation.org>
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

[ Upstream commit 6e5deb2923b0d1b73c77a1a77c30b0da43d9e022 ]

Since commit af86ce79f020 ("[media] remove the old RC_MAP_HAUPPAUGE_NEW
RC map"), the RC_MAP_HAUPPAUGE_NEW define is no longer used.

Fixes: af86ce79f020 ("[media] remove the old RC_MAP_HAUPPAUGE_NEW RC map")
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/rc-map.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e26e3577d11d1..b7805ecce62b5 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -262,7 +262,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
 #define RC_MAP_GOTVIEW7135               "rc-gotview7135"
 #define RC_MAP_HAUPPAUGE                 "rc-hauppauge"
-#define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge"
 #define RC_MAP_HISI_POPLAR               "rc-hisi-poplar"
 #define RC_MAP_HISI_TV_DEMO              "rc-hisi-tv-demo"
 #define RC_MAP_IMON_MCE                  "rc-imon-mce"
-- 
2.53.0



