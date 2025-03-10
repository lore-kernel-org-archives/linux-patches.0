Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CCD2D023;
	Mon, 10 Mar 2025 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629284; cv=none; b=Se5tSDWShXIxfdUyC7/Zo28HTvo8T15Ww05gsyw/fcmXGY+xItepWEHEGOAc0Yg/x+K+QPwVFeLMVnVugboS0rM+gzI4WqOPQIifO28MxCdFdVeiqrhdLvTrhqErMQ8wZkVCrxE4IbWlztXXWzZy0l88ab30BYLtaQIlPO4BeHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629284; c=relaxed/simple;
	bh=HpHo6JGywTgP0EHPYkxDpJvzHIzzMEeZ/DdcT+s1C/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBalYlaFRWaGKz2ZFnzcrfVKPQT0UMBtrQAiqwVtX/ZBnIztD8LPME+1pztbKHNQ4zvg7NJktZjVeeVSnV2Bk0U8SetGMTWPMXLcSXtcUt7YHb4cyldOmt8jNVv0cy5GPjkJBY1NFJQWKNWXILMDiD5eYGphMpGaAFbRNO0dZ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZxwZo+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZxwZo+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F27C4CEE5;
	Mon, 10 Mar 2025 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629284;
	bh=HpHo6JGywTgP0EHPYkxDpJvzHIzzMEeZ/DdcT+s1C/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZxwZo+vN+gW8TA6RPQ6hq5LjXKEC4dOTxPZ4KR5LyybQiEUMah8e0ARv8dNPySVP
	 FqNJRsM45aI4gA44g9ekslfWGayR00vQU9d4eKxLYuUjysf5NEOOcth0p5rFpx4sMB
	 +89MZV3T4lKxvMDCH4p21u35e+Zvb/D4tDhdRB6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Pandit <pjp@fedoraproject.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/620] firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry
Date: Mon, 10 Mar 2025 18:01:27 +0100
Message-ID: <20250310170555.145041429@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasad Pandit <pjp@fedoraproject.org>

[ Upstream commit e1e17a1715982201034024863efbf238bee2bdf9 ]

Fix ISCSI_IBFT Kconfig entry, replace tab with a space character.

Fixes: 138fe4e0697 ("Firmware: add iSCSI iBFT Support")
Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 97ce31e667fca..b4d83c08acef8 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -139,7 +139,7 @@ config ISCSI_IBFT
 	select ISCSI_BOOT_SYSFS
 	select ISCSI_IBFT_FIND if X86
 	depends on ACPI && SCSI && SCSI_LOWLEVEL
-	default	n
+	default n
 	help
 	  This option enables support for detection and exposing of iSCSI
 	  Boot Firmware Table (iBFT) via sysfs to userspace. If you wish to
-- 
2.39.5



