Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499DE241693;
	Thu, 13 Feb 2025 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457404; cv=none; b=FgXKwz3sWgNFb/TnmneEMzSHnxlLdQrAOlXUhN4S1pV27IGu6I1b8avRnranlAbcy4kxp1NYq3QTND6rvBspi1nteL1QXhVfERgl4fhrZG/Za084B7T/T5MGArtvonRPLmSViGQP/cBBmoGWcYFa5HfzdybVErUeD+Kn6tQnCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457404; c=relaxed/simple;
	bh=rah5wuEmbG2ReaNI0aJdRjXlAg1eTfFaLF/B4Dpytv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5ehUZtjg3oD4GFJ4VF+/+2NrRGiBhzOyGXaiU9VogVUEx0fM5VITU1xovthsEWwXHbL6EV02haDotM1gXtiWYA8xr9ZwenwJno4togWKXjt6/+CI7JNGVeOu+S28MNZENeMyzNNvBxpj95WLp4IYxl1YESj2DipNqRNGN9JKBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl/vCMYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl/vCMYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C85EC4CEE2;
	Thu, 13 Feb 2025 14:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457403;
	bh=rah5wuEmbG2ReaNI0aJdRjXlAg1eTfFaLF/B4Dpytv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl/vCMYBDjKRQlvC0BNVPSMt9xnppPFhMjKWQbg52Rcc/EJqE3S6eo9P1EL175jbj
	 VWpl2d41zBbg6hV2rSVpJSkd6bzdwAQZVFzzpqna3WpKG7w2h9n6kVginoaHhMxNfR
	 qd1XJ/rlJaJBmcdKWKXupR+sDdXtY6cfOV+j5xOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Pandit <pjp@fedoraproject.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/422] firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry
Date: Thu, 13 Feb 2025 15:24:10 +0100
Message-ID: <20250213142440.453671210@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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



