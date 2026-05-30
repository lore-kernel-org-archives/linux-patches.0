Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4B02C11C4;
	Sat, 30 May 2026 18:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166485; cv=none; b=THLJsGye4MaKysWfGb8LqCtU8OxJQu7+nl15/PXGg/eE85t6UO/oOqYormcverfMrK1iGokJOyQ6GTmitCJdTWcVoIwRyY7IwpQLFsTZRnqOBy6Y0Kee5qoo7BhEX8yyQNbg5w0wo6Oc2mIXGHjXbM24Ru0P2kDV8gzS6xaiXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166485; c=relaxed/simple;
	bh=LYmtTtyWnO0tI/cXHGox6iXVFL2HPDJQGVhc+jV5MIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qccz20am3nLeAJgqEYDKYz6cUgdaKaMbQqRZ6Qum+vERbUaJaAXK1wKa1gIYlIx3elAQCaaZ5o+F/UVmJcY6M9HLt50iR9679lSOvLf39VyOWp8n5zeh/dwGWnVRmDbBMgFwRMRPSwggsWNk4/JL/7/fx8YuxlGopea/CPUE4iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xD+Zo+65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xD+Zo+65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4026E1F00893;
	Sat, 30 May 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166484;
	bh=hvOq7sB2cgnQVJNSQucjsZVdX0Tqc9eOCqZE9bebVOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xD+Zo+6520OBNrMPzXXjbsA/wFSCuOcYjoBe1QFsDDU3+ohmot81O17RfNeew/eTG
	 iWj/F20de968xjXo9gFKUtaTxQGemkx5tPBVzwsdU4I/2FESo72uxqHVxGfEED32fT
	 5bfuA9K26sTFQoNolnsH213LXAK0P46SZp6xXy64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/589] driver core: device.h: remove extern from function prototypes
Date: Sat, 30 May 2026 18:04:27 +0200
Message-ID: <20260530160234.945926511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit f43243c66e5e9ad839d235f82a58e73a7e7612af ]

The kernel coding style does not require 'extern' in function prototypes
in .h files, so remove them from include/linux/device.h as they are not
needed.

Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230324122711.2664537-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 797cc011ae02 ("backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index b2a2109b170c5..11709e3ee811f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1032,8 +1032,7 @@ void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
 void device_link_wait_removal(void);
 
-extern __printf(3, 4)
-int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
-- 
2.53.0



