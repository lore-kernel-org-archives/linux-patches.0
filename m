Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064DE25DCFA;
	Tue, 11 Mar 2025 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706742; cv=none; b=aQfMsjqMFt/ETN0547fIrLaVxjmA3JIrWKpz0t3wDC/NxYexziFGiYomOJfFNE9st6slXp9UfxU/819crDaCqrxznwgPODKwcDdVJKrbiZ5rPxDE1+M3hsy7RKFlL0Gng+UfROyugx7IFd7re0PFBh8rv7Tf6txqxxcbmHKivOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706742; c=relaxed/simple;
	bh=i1LPlJeAO/OYZiZke2E23OIXt9/sUtdsIY2KljFq67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8eypwT1MVeoTZlp2eQ542W6qUQJaI9nS23+zxA+QnPKccYgVG53zGq8/amqkzRVMFNS1tXZYQNaVAnDe9PQUV3PE3LHrWyjxUdRFVp/ocCbsD84WbdbN7CccMH6jNh2nEHGiUeBei+5kvO9f/ac904I9TLmh6hhlpxAW1tAdhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXcVCsUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXcVCsUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78931C4CEEC;
	Tue, 11 Mar 2025 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706741;
	bh=i1LPlJeAO/OYZiZke2E23OIXt9/sUtdsIY2KljFq67o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXcVCsUdEH07rBemftD1PMRdx22a87imyEP6WI0srp2cqF8SjanQ7KKvHmMSrFoGt
	 u6P5xNDD/GLwLkKEX7kl0Mx4UlVp0TM4olazSZ0N7BdScHJ6QAttBzYKvycWC6ovZX
	 hp4vjHVFD1t/vxz/Z/5wPp6RQEMZ+HwUreBSH9js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Pandit <pjp@fedoraproject.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/462] firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry
Date: Tue, 11 Mar 2025 15:56:58 +0100
Message-ID: <20250311145804.354583594@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
index 807c5320dc0ff..a83101310e34f 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -171,7 +171,7 @@ config ISCSI_IBFT
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



