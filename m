Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8DD2E541D;
	Tue,  8 Jul 2025 16:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993065; cv=none; b=RpfGR7Z3qL41sRpnScrY6ECBiVp9SSkbbSyOd0dPTry9WAtHmIXFhN/QKbjTlz19aV0SoixT04LB1ZgeZ/6AceuSi4xnOs/FB2sU/kAzATIoUiOYKRe5pf9kuORalaBHn9zUy/EO8Ml9/aohLAfcX6ZBZDe55cn3tXyiSA5rMJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993065; c=relaxed/simple;
	bh=fbUYGFd+pbh2ASbjYFr6iirjQMzOsjBg+aIiGwUtULA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzWgi8mXQul7VcNKT1ZySmI2Qm60QnHKI+rcMjvlEY+aOqLKyIfSuj9JcM8PZ7C36+RMSmpmEbUUNh1u/z+w/JT03GlSbHfHoSmETTC0DD5cfTPod98L7XeOzEoFBU75r4zrKB1DZAfob3zSjbtB7zx8sRtYuXoqVS6VuU5xhEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P81xusKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P81xusKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C566AC4CEED;
	Tue,  8 Jul 2025 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993065;
	bh=fbUYGFd+pbh2ASbjYFr6iirjQMzOsjBg+aIiGwUtULA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P81xusKOpTSAcSi3+KNL72uCXIh8Te5KLz6WaijRwFTrV8nekoN9NSzg5+FfvxP1W
	 yLOufjY5rrjNMwCXUrpMqiXcC0G0aorF4gAiNzLne9Lf2nfGMdl9qWdVgKNYYeCm0z
	 +KIj635VzOVp///SC9/0SeN1H/OqwrOzInyJOC8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/232] ata: pata_cs5536: fix build on 32-bit UML
Date: Tue,  8 Jul 2025 18:22:52 +0200
Message-ID: <20250708162246.044405933@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b811efd2cc346..73e81e160c91f 100644
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



