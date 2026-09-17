Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820EB4ABBC0;
	Thu, 17 Sep 2026 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671556; cv=none; b=afV9pf18c4eCmbUby3C0/oljYt3QuXDX6oflaEcV+ScsszYYiamanFkNrM7h2LzivyifJDtPo4534Wgg7E7G3E3n2eKIMR01HiJbr5quRxaS6NaEUyDawfs+twtXRWS0wX7G/wtM8HkYFNd5vmBMcTY7HslX/4eifp3b1fFVS5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671556; c=relaxed/simple;
	bh=jinx/ZpwVYuztnEx90+0OYG9l9raoT/si20JVoDcJtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qs6Hk++5afvnEJY5nh0kOHBB5AQxujNQXMCpVBS6OfPGUCTwWBbA+SAUoM96PNzCHh2Hhv8uwVfgPBpoq849jGOonQ/awa4SQLYalfvx8bkgtNfmnKRfVnSpZFJxsfcrLHaSXbZ4wM12VYYE6SAiKCdOzjIJFf4S/G6/m1PWKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHpGSR9E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHpGSR9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965931F000FF;
	Thu, 17 Sep 2026 18:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671555;
	bh=zs46yPAJCDcLDg7ykUHYepeXWND3fijvnrcw9wZcHf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHpGSR9EHzE2m5WNC/EzHql3qBlL8wqlmXcti5h0nVWazIJnejMIaZHD0hdQsXM0v
	 0ywmd/Ww2+U2Pd9fQ/WlOhFxO79q3e1XUWPVrwZzpER9+IYewaVVfQXnP1GjfixCD4
	 2CdvfKCS8ijlKEhxZXSJCKQORSqZoJ8DrK5KD8b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	Minchan Kim <minchan@google.com>,
	Richard Chang <richardycc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1016/1102] zram: switch to guard() for init_lock
Date: Thu, 17 Sep 2026 16:15:59 +0100
Message-ID: <20260917151606.260990979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 0d38260c2a11de147f0c4701b344fdfa6bcdd04c ]

Use init_lock guard() in sysfs store/show handlers, in order to simplify
and, more importantly, to modernize the code.

While at it, fix up more coding styles.

Link: https://lkml.kernel.org/r/20251201094754.4149975-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

For the 6.12 stable backport, retain only the zram_reset_device()
conversion needed by the follow-up fix. The remaining upstream hunks
apply to zram paths that have significantly diverged in this tree.

Stable-dep-of: dde75313eed0 ("zram: set default primary compressor in zram_destroy_comps()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2167,7 +2167,7 @@ static void zram_destroy_comps(struct zr
 
 static void zram_reset_device(struct zram *zram)
 {
-	down_write(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 
 	zram->limit_pages = 0;
 
@@ -2183,7 +2183,6 @@ static void zram_reset_device(struct zra
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
-	up_write(&zram->init_lock);
 }
 
 static ssize_t disksize_store(struct device *dev,


