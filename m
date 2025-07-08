Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD8C2A1BA;
	Tue,  8 Jul 2025 16:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992094; cv=none; b=TNgPXVSxC050aT6HipG68Q4EBFoq3X+stI90/2NuH3M/WOq4azKeg575AHul1ZYPDcRlrLOv8toVa3H4YaSzt7bYZC8/nR9GVRyVtVUW6PGKGYGX0YqRdpDLJRiADE7D398r5vEmsOl5jhgAIABeu71UZfI2GypeFOXHsUSqTRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992094; c=relaxed/simple;
	bh=go0glYJsSVpINek9WkCY3aGUfOGAkVdkddBhr1plaKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3DDIsyIeEGImDSli5+Zw03YyYRQfiCZFN3leZnA9EdwTjyW08LTbzDKK4D/JVfZGpoTm8qNScpstWW0BBNpS9SgZaSUwibT1G6XOUnR33e7N34ezsSpLsNdIpqBkX4TVAfIDn2psF9Z53PZNv79ofSBlEMQnrjdyDbdORu/+Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/f3UrFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/f3UrFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98692C4CEED;
	Tue,  8 Jul 2025 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992094;
	bh=go0glYJsSVpINek9WkCY3aGUfOGAkVdkddBhr1plaKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/f3UrFMKTSQfGMH9j+hbyIRcWG5Oy315G2Co0d2XEy1Fwv2C3x7bCo4H+3InOqDA
	 l9CfezrGqdr6v8QBdlpJnZCd+wp5+vBfMCxEYxgxwQR0CU2j1YVreaDHzC3IgNW/8V
	 ueTIm1xJgEiEqhqqMUQAs6ZqujCT7WmjUGXz8y9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/81] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue,  8 Jul 2025 18:23:41 +0200
Message-ID: <20250708162226.577145340@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab47aeb5587f5..13daa69914cbe 100644
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



