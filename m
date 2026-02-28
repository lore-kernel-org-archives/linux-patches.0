Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C2C34028F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300976; cv=none; b=TblJUpEcsCkzemfB0JCgEU2/N4aKg3IoXZ3XBVFysWbMmBIbBvdL/SWkEvtYt9u8G3BSvIUDYhr6Am/beDz5ht3oVSPk9ldsrD7csfpQr3A33OtFOdLoTqcOJNoLHGHNJga/TQltb/PSkHbntzETw8Q19vaUxO7kY7xT80caXOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300976; c=relaxed/simple;
	bh=GiSdY7QWPuOmRrO/Wej4YIsbBGCxiqtbm54OJsH3IzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrfemRrkxX+Oim701AKcfr9jUwChYUMwYTM6EyTH3AqK5sb2y0YhT2HaRKe3XA7zZnxCPVH9zaE+Gs1Vuw+RiyBBb3nG85FzlMeyJ6NHj1cY4SpQmLJEbohAbWznIDZS6h98M6t4clpfhGVmaZXvWSMhoZGOJASbNbtfjmUGU3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrKDq+3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrKDq+3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5438C19424;
	Sat, 28 Feb 2026 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300976;
	bh=GiSdY7QWPuOmRrO/Wej4YIsbBGCxiqtbm54OJsH3IzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrKDq+3Q5tFnX/PL2Tsg9rUNhuKsoUiYqoHvG8FKRZ6hmnSnO63uGWc93o3Yi/VbJ
	 EsZMT/iF7WvE9S0ZoXuheuDZrLII54SCugXF84P6aLTi6axaOZSm3YpxUmdNZ5iNXO
	 ch89PE86WoJW+SmIfHmjcuFMT0tt9BockBIPFhhk07o3AX22rWLnlUELId6VSdTb3q
	 RVLldntMMmkb9U1VT7Mbw5cRSB+l0n3SKv/mnA7NI9DbseF5cBEHtpEBKIasMLPXF4
	 3/E7CGJfbx3uDgo0H1TML71mYss51btFCXABeaq9ekTUZwApC2gSC2x2mmqfGk6zfx
	 4uQMO9+AGQyuw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/752] parisc: Prevent interrupts during reboot
Date: Sat, 28 Feb 2026 12:36:55 -0500
Message-ID: <20260228174750.1542406-104-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

[ Upstream commit 35ac5a728c878594f2ea6c43b57652a16be3c968 ]

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/process.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index e64ab5d2a40d6..703644e5bfc4a 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -85,6 +85,9 @@ void machine_restart(char *cmd)
 #endif
 	/* set up a new led state on systems shipped with a LED State panel */
 	pdc_chassis_send_status(PDC_CHASSIS_DIRECT_SHUTDOWN);
+
+	/* prevent interrupts during reboot */
+	set_eiem(0);
 	
 	/* "Normal" system reset */
 	pdc_do_reset();
-- 
2.51.0

