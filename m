Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2FE3161A3;
	Sat, 30 May 2026 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161581; cv=none; b=mhm+ThQUzpMBkcQ9nACLpgb31HBl/333DWIE2wNhHOdon5mtP2IT9mzqi7yHxzyB5N+l1Gt3N+OoQYBc84+5uesi/yoEGQPDasj31xTxv9GTGI2mh+SeGkxvNgLM8FsNI+kr70dtGS8WYDlpWVJgv9UalFwebpIBk4vN5D3vXIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161581; c=relaxed/simple;
	bh=SR0cbpsidA5LmY2wzpC0RaZgPslw1+fFejqcqPoUtUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otPBp+H6Rv3RmBgDWdoh+Wo4sHN0XwSk84Wjl5db/edyr8JRRyyLekQ0bGU/x8oIC6nW6sv5xJ58nxwLmTDwiI5oIiXsyEaeBRE56WOYvOSEghzTopJ64O0GrZjkdqowtHaoo6y5HaoEGvPNzXyDJfLIK/GdcnFiy3pwAE+7GlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AI4py74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AI4py74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CA01F00893;
	Sat, 30 May 2026 17:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161580;
	bh=TCMrEYr48k+Gkqcr7oaxKOvwsgDOW5g/Ymm86CrhPeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AI4py74Ccea7So74QgUSngzqbMaXyVxNka/4+c0tSXrmw21HciI8SpsUjJmhB2tC
	 OkYsLbbI7LP2s86S2Yr8Q4o+DD8y2HSjQbXEARF5IPyQR4NK9wkzCOCX/EDmqpfsFh
	 DqTm2U4U7RYtD7pory1UWl16h9N8xtZwES2wHoMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 635/969] driver core: device.h: remove extern from function prototypes
Date: Sat, 30 May 2026 18:02:39 +0200
Message-ID: <20260530160317.987666910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 98e4a0d01e5a4..428c96ce6b4c4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1149,8 +1149,7 @@ void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
 void device_link_wait_removal(void);
 
-extern __printf(3, 4)
-int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
-- 
2.53.0



