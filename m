Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BD741A92A;
	Sat, 12 Sep 2026 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228964; cv=none; b=EuDR49aAXNiHv0fW9dCq8MscSqdyvdPGqtgtVXkZLrTMLWLvddWWLOwDq7w96gZHwCOKfPa4Wh8IQizQ0Kz4hyDUVZ05XHFdt1kXmmQRz8uydZA5NnU5TCipk5cezdHY+NWaIdOGT2pe8SoTTrzKSPYteMHJXzPtEZfkSn4HP3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228964; c=relaxed/simple;
	bh=U5d7q7vbLVsRebrQvZGO2V/1BaGkVMRHLk4OulYlZZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmgpV3tga81vaDCflnz3y7ROs/v+w8gPFwDdsY9xrv3xQxIX0JVVLcmzTpxElSRX6Jq11qfegg9d7TvJX4XZRzNmT/eSYB1JANE7NErfwyb6WG4qbODyYMPAylarfSxM7WZYcpINn7R+Tar/jFIrUv8gI+iWx4Md3ZFz2f0IWFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9Vjirmn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9Vjirmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236041F000FF;
	Sat, 12 Sep 2026 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228963;
	bh=TEdv6eqZIAFWwLADGKYyvb0TiAa4iYCq1asAhMR0i9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9VjirmnnQywFk3QDFUqBI1B7mKraBBdxlNLd6HsWBsbsRNMT6o4YUVdY1Q3DD91X
	 h1l1tIxsgd6shGvcdGHmLmE7AZcvpn7v26WdoU2yCRafSz3ppt4Qp5MsmjCHrLYSfw
	 jJrQFNHU/aiJmyny0v8Cwaj7ob9jlCcLS2W5kJ7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0492/1191] media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define
Date: Sat, 12 Sep 2026 08:53:40 +0200
Message-ID: <20260912065559.280242289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 1eb9a93330036..d59aceb38ca05 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -260,7 +260,6 @@ struct rc_map *rc_map_get(const char *name);
 #define RC_MAP_GENIUS_TVGO_A11MCE        "rc-genius-tvgo-a11mce"
 #define RC_MAP_GOTVIEW7135               "rc-gotview7135"
 #define RC_MAP_HAUPPAUGE                 "rc-hauppauge"
-#define RC_MAP_HAUPPAUGE_NEW             "rc-hauppauge"
 #define RC_MAP_HISI_POPLAR               "rc-hisi-poplar"
 #define RC_MAP_HISI_TV_DEMO              "rc-hisi-tv-demo"
 #define RC_MAP_IMON_MCE                  "rc-imon-mce"
-- 
2.53.0



