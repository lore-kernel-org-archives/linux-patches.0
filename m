Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC49E2EBB88;
	Tue, 15 Jul 2025 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587761; cv=none; b=b7CuEI/gp9gbGgU5Zqk4OU+9sDEZptaaO/CRETudzvhUCxH5mBIQkQiGsK/64vU6TUXIVPzGIcYyfccJKn21ODO2DQBfeHmTCWROrpX6gXA7fOGqO+A967iYQ2mb5Xt6s0jBtiOKQJF32atLH9KulVJhv8MzmaQnONtXS0p6D7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587761; c=relaxed/simple;
	bh=A3efCJshF7X/5Fd62OoWlWPZeZYZY/SJ4EKiRIrk/yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMofO63oveolWZNZQ0+RNbEOb9SX1FMRS8p/dDs96sWQc5wjubjdyJv3y3h2skQJpx29sjQsxeEO50YPZgyEd/dYmJVKSzKKf7HO3sWVZ61fI4nBK+wEwsR+wq8+7dv7OdtIQ9B4KjbZu+n5kyAyVPGoyADYfrCfNr2X7TE8FbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqqYjXbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqqYjXbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46374C4CEE3;
	Tue, 15 Jul 2025 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587761;
	bh=A3efCJshF7X/5Fd62OoWlWPZeZYZY/SJ4EKiRIrk/yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqqYjXbr1ZGAEqiyVdjyEWx21HYYhkUrbxwy4Effae4KBaHCWVnZcetYcbfsJNeSB
	 Joa0k6l7AkWFSZwqoLideX1pImtjij8qMQqEdaFSaR0mYgENXEGkfVcNlyojByc6qh
	 8pAbqBlkRfyOOXCmkw8DkNKwUmiirTgOUkSiQ3UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/208] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue, 15 Jul 2025 15:13:31 +0200
Message-ID: <20250715130815.033395070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit fe5b391fc56f77cf3c22a9dd4f0ce20db0e3533f ]

On 32-bit ARCH=um, CONFIG_X86_32 is still defined, so it
doesn't indicate building on real X86 machines. There's
no MSR on UML though, so add a check for CONFIG_X86.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20250606090110.15784-2-johannes@sipsolutions.net
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_cs5536.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 760ac6e65216f..3737d1bf1539d 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -27,7 +27,7 @@
 #include <scsi/scsi_host.h>
 #include <linux/dmi.h>
 
-#ifdef CONFIG_X86_32
+#if defined(CONFIG_X86) && defined(CONFIG_X86_32)
 #include <asm/msr.h>
 static int use_msr;
 module_param_named(msr, use_msr, int, 0644);
-- 
2.39.5



