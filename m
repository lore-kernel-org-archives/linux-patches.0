Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350A1DED51;
	Wed, 19 Feb 2025 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956942; cv=none; b=NTdZJBNVZMt2vEWt4PbuPXX0s7sgEZ9P/qFPP7KvV/Sug0N/qL92H60gC1bjoSSMWAv0ljvjLwD8nYQXb6uOFpsOg+7BLDVI/Ifc+RWf9Cs56APbzqp1tsLcZRDrwTpeuXKCZLBs/7rv93VFZXTAoTB/9HyEc3wZN/ixU+B/cEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956942; c=relaxed/simple;
	bh=kTZlub8RXaU6KeCK8GsnlwH+KcXIlm4XArI+6TEhzGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjiKRzzdWotl9u6SMdfbFviUlFMx76bqW6o+eEd+DrbR8e4Nj3hRfyulAy3eUmM5lyYYXhtGKAJqfV6QbLn5ZM0btqpBE05mIXvqcgtqGqHMjIcA6IAf1NCbBzw/Zb5evebks1SdAOeknx+16av3D9SxbQPPOWoSroKHYkG4psA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os7AxvvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os7AxvvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F846C4CED1;
	Wed, 19 Feb 2025 09:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956942;
	bh=kTZlub8RXaU6KeCK8GsnlwH+KcXIlm4XArI+6TEhzGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os7AxvvSdh91xHW44GvxZMC3F4RoJMK2KG0+ZYIG0HV5HGDMPs/b++THQ/OUK1uk2
	 WTotVyCReX3BIlHIR117aIIFo6YVkEf/LGwZGPRCxS0XgIUSLN0mbfgsp4Dgz8o/5G
	 w6XBlUBHj93xyhsVc+DICmONewwq17fCiiia3rDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Pandit <pjp@fedoraproject.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 322/578] firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry
Date: Wed, 19 Feb 2025 09:25:26 +0100
Message-ID: <20250219082705.676752762@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index b59e3041fd627..5583ae61f214b 100644
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



