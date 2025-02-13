Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2C1547C5;
	Thu, 13 Feb 2025 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458892; cv=none; b=GvXVs/wQr3m6CPLoSuDtdP80sBQ7BnyeG+las5H9dCta8Z8q+BscHOgHlrUxpSjhAyVcdLjaDBjvhUHhEdBYBKTTCVvizr+bN37NYaQuT8LsJfFZCqqOApXKFPuQNtUGGL+C5zUqZGTZOh/zu8bDbdvpwXS0cLWlMnjSnG/HBNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458892; c=relaxed/simple;
	bh=MBFTxJJN0eOg2xq1Kd+wPmoAQ955W+DXB2R+TNBCdt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hk827iH/GfUqQikLWWjAgNiBA7ChpaJk0d6xSwpo7KuD2xHON7CwtwmuGqCC5DetWca0fT2SrXfjCKMr6FM+cb56fiLcVyxRcF/+hqNUEjEr/PtZu/rF2gX/Bw2924qQQnoXun2jJeqe85Klzey3ohdIfpDiQXnoIG4zTMw8dTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NM5MaVh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NM5MaVh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDE9C4CED1;
	Thu, 13 Feb 2025 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458892;
	bh=MBFTxJJN0eOg2xq1Kd+wPmoAQ955W+DXB2R+TNBCdt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NM5MaVh8GUluu+2kSaFwl86c8xR6szJYKlgrgdQ59Y1Cw5SYK0ZsRu4qDumXCEh5g
	 gJvkiyErQ+0fz1XSPh2W7Re1OaUO/cyol31LADBj2Wf18KhZM0mP+pDh5Oob/XfkES
	 1u42YeLS0Jmd5vPtq2xin4GoCLsEZ00irabVXRZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Pandit <pjp@fedoraproject.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 108/443] firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry
Date: Thu, 13 Feb 2025 15:24:33 +0100
Message-ID: <20250213142444.778748810@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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
index 71d8b26c4103b..9f35f69e0f9e2 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -106,7 +106,7 @@ config ISCSI_IBFT
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



