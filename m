Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5FF72628;
	Tue, 15 Jul 2025 13:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586542; cv=none; b=QDA/8a5+4QF4jdiU+AiufkkScrGKwJWHLlVORrpUoB4HGQ2EnD0xcMyrGia6Hw7tb721IwwSwFTGWazKnhB/7Phldy43SDNqlL3hb5YYusrvWSOQW34S1U3n6MT7ZctckIWjvVz+g1N1eLJse99QBpMr3QHwT88qkGSxlfN4aiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586542; c=relaxed/simple;
	bh=0ry/JJ90fo3cy0Eoz22zs0eou5H0s2Ml3ggi24aZSOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLkWvMuJmw2s+2N3unQ3yoHjH2ACluDWRtRl6bTvq0b73+0rcvjBAKw+2B/zfdiH2JLyr1Xl5ntoKy1D92153Sgi2B8O8i9+8dkZC4PsrDau6KDzzxHt8mnx87EYMXE0u3zH6VY5bpLETyrHBmx7jonnwMlsJBaurtwwqwyIyK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCtNJKpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCtNJKpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E664C4CEE3;
	Tue, 15 Jul 2025 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586541;
	bh=0ry/JJ90fo3cy0Eoz22zs0eou5H0s2Ml3ggi24aZSOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCtNJKpWTqqu8pEWorERROumPIycwylGy7pZGeuSEjqs4hZcyWEnO8aikiDBQJOF4
	 xPiNtHMNgWAMbdFlwfAZ3meT3NXzVtcORYY4m8+TcRKSD9q7TGkP2QpNAnyG/oI3zy
	 aXrrNT7AeExcw1k2Dw9SXV6JrM4rQP2GPm+Ce13k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/148] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue, 15 Jul 2025 15:13:15 +0200
Message-ID: <20250715130803.247622344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



