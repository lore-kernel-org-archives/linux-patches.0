Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7E6431A5C;
	Sat, 12 Sep 2026 12:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214556; cv=none; b=dgrhdSAWQj+ULH9PvupGwb8clcn2yupXPWyieg5f6VgQcHBo7tM8Hm/dD5Y0ARa3hbHYFn8deBM2UEitMyVptSNVfKOA/SmpjAcnaU/QaZmub80FxsUE36f+ztGdMELopTcYecKaLl6vUfcItJgQRnf32/Ap91Gc3Cdx9MIaOGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214556; c=relaxed/simple;
	bh=IDiTjK1jSeDmxmGoxpWOTEXdfRuR7V/et//VWM5VmOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdCyBP8mpuN6oosEA3TcmfwlB9EApoTMAbguzyl8P5IhUYvoiBP6gGak2yY7vWEsDGjZNZ3/BVctf5h+6Vpwz+jGPbV71DFjWhIrF6wajR0cbEoo7dV7pPixJ97oeQ89eQiyoIA8oR2WVy+g7LVtPIC7NZslu4HS/fbEFkrvv/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mrsj4/qg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mrsj4/qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143401F000FF;
	Sat, 12 Sep 2026 12:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214555;
	bh=UFbz+p4KUbCstfeh4riDrvu00Mat03fcymDLVB2qYhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mrsj4/qgRtZwBWblOczatzRPp8Nv7LaFBdVOieu4mlWiHjcb2mPO+sJS5bI7PaDeE
	 7wfItOvh7mzXcApmdWwtJY7wwYMpMSboOCn50A7yQFxX/9vbBf1NHLpbnMSPCmnrTX
	 SzmcVUbUhU2KpsAl7jfqcO0OCyZbigDvs4vMiWYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0350/1376] media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define
Date: Sat, 12 Sep 2026 08:46:16 +0200
Message-ID: <20260912065615.352529579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 8c74175bf296a..ab8c1b82dff6a 100644
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



