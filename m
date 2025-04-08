Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1BD269CEB;
	Tue,  8 Apr 2025 12:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114797; cv=none; b=LQ8D/Kpc60khcDg9oQznLlUYpnrSR69htWjDUFMqY+7IY7HXYioNSHaKaHa4QLcgpEU0pfKCgd2MhRuKGsMcHU/Bcure+Hx+PNAstNoyby/KMSbih1AoK+EeLwN3tP9xw2JmCXxouiiAmnJyx2fYVXDQcsZF7NKR7nj4LqmHEfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114797; c=relaxed/simple;
	bh=T5mdom7VbRmMpA4rwdBg5Dqb61JlK5JNnAWXtPk5Q+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oof2tbptJX6G4nuY3RG6w4FAmVKqGuxwhNHBxA2kXEWDlxUQ3JCHdNlbTiQ5l1/S7neTBFNo0dGCg8KNC3k/Z98QCjAZNOb/f1BZySpR8FOxwHuHh+SbBZ9uivMIeyFUSGYGeuPxgSUzfB3ALcYCOMvwEd8yiDGotIRc43etC4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+pvgUXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+pvgUXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D67AC4CEE5;
	Tue,  8 Apr 2025 12:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114797;
	bh=T5mdom7VbRmMpA4rwdBg5Dqb61JlK5JNnAWXtPk5Q+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+pvgUXNQigQwLJSYkcV4oDd2eFjsuX/ACP5/Wueq6MmAij6xEl434kx7+9Q0vGiY
	 MYpZKg4qgKsq6Hfn1Ky3puHzBhibbx6Z/prCw7WA1Tiix3Ds23Iw8T0h91cjZhwJhr
	 JncCY6CSak7BJksu0CLHYXu7cenEKczGnERKYbfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 211/499] staging: gpib: Fix cb7210 pcmcia Oops
Date: Tue,  8 Apr 2025 12:47:03 +0200
Message-ID: <20250408104856.471883088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit c1baf6528bcfd6a86842093ff3f8ff8caf309c12 ]

The  pcmcia_driver struct was still only using the old .name
initialization in the drv field. This led to a NULL pointer
deref Oops in strcmp called from pcmcia_register_driver.

Initialize the pcmcia_driver struct name field.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202502131453.cb6d2e4a-lkp@intel.com
Fixes: e9dc69956d4d ("staging: gpib: Add Computer Boards GPIB driver")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250213103112.4415-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/cb7210/cb7210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/cb7210/cb7210.c b/drivers/staging/gpib/cb7210/cb7210.c
index 59e41c97f518d..ef6be5ab3a17c 100644
--- a/drivers/staging/gpib/cb7210/cb7210.c
+++ b/drivers/staging/gpib/cb7210/cb7210.c
@@ -1342,8 +1342,8 @@ static struct pcmcia_device_id cb_pcmcia_ids[] = {
 MODULE_DEVICE_TABLE(pcmcia, cb_pcmcia_ids);
 
 static struct pcmcia_driver cb_gpib_cs_driver = {
+	.name           = "cb_gpib_cs",
 	.owner		= THIS_MODULE,
-	.drv = { .name = "cb_gpib_cs", },
 	.id_table	= cb_pcmcia_ids,
 	.probe		= cb_gpib_probe,
 	.remove		= cb_gpib_remove,
-- 
2.39.5



