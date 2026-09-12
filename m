Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F56C37204A;
	Sat, 12 Sep 2026 07:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197205; cv=none; b=HwR3gVNIxlg4cuV9tWBo8qJ4WFMOsnW728A9AkoR1QR9rNc1cW9oCL+3J0Nz/XCysd9YKKbXNMYCRJf1cRR2n9u+OzXeC2XDY2MX6eXp73aEJruTZ3+bASQla/o9Tpc427VIZjoaAIeIUn2xJTxOVkbj/DzMx4gIBlHcPfZUQGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197205; c=relaxed/simple;
	bh=HV7X6QSY5Kg17BTXPici2a7Dj8OJ22kOabTve52Xc6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPiOShoUjBcF2PZDsg45ZgxOWsB2Bi+46bwXXrght2WUeieMgAzUXN1wL+Xy1m1OnTXaOWF6C4S1SgIJ+jS7N6kcojUgfKrchyl92U2j8yTTksz453yxHrnM57+7DMnUy1OgS5SLhOIMo2Kx+JvroHSZEJ0MZTuoVHxpq+ahRow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AePHXTmC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AePHXTmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC45C1F000FF;
	Sat, 12 Sep 2026 07:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197203;
	bh=BrWUjL1oKhfR/4mevXz+0wG/YwK9GCXxrU5a8+ncLFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AePHXTmCy/jfHSKfrU0RLvwUxUAhjdfy2NCxNuPRoR0NzSH5UYBjptTnDmez7iq4s
	 wNm58QYnYx9hSXXrgJ96JwjRWJXMo1GQfbc29QmsLX8qISbfOe7usSSEsP/4B9znvI
	 rmYpuikjFaOjXCIFd4oTAoJYPuYCbIEhM7CZMN/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0123/1815] media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define
Date: Sat, 12 Sep 2026 08:31:13 +0200
Message-ID: <20260912065651.901846332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 950d702aee3bb..d95ed3e96de28 100644
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



