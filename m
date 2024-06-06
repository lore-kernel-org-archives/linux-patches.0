Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F4E1B583F;
	Thu,  6 Jun 2024 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683470; cv=none; b=sB8Txi31i9fb3tKTWvHOTfNTvVrKbTZRE12K66QAlGnN+jM8VabsketZsSITOXPb7l1/wuuWdaO1nsKY34ievV2+uZEAb/TKIu7NJtkqMGkDQRLHb1dXLDlszP0tbWQ3Z8RhckxwUmAaPJ7Bz1TvUfyFEe29F6zgqjkt9cqVjhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683470; c=relaxed/simple;
	bh=ppfIB7aLc92fG32Kmw4K4w3ukMYMiCIRHusRM6r2g2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRX6htOnmvSqUacuVxwWyDx4EoCwoJzFYHnkgJFwPNWmeUlw/E2n4chn8l1UbeKu6YOZ6TJcEa0Kzp+uUbwl5+/VO2MXJoTMgbivpsAtjATfdqdxaAvQ+gkcPcY0NtbqQgDLTVdIRW5ahe3SRMbFqpEbWcGHoapysxLzGb752cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxZJ8pDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxZJ8pDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439B4C4AF09;
	Thu,  6 Jun 2024 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683470;
	bh=ppfIB7aLc92fG32Kmw4K4w3ukMYMiCIRHusRM6r2g2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxZJ8pDKIlWPUIqazWnW+ptuT5HrzBNS1iqNWMsHRSydY8GSPns8UHav7NrwJvlUa
	 nQzJkneWAQ4nBuAESv6SBTn6KEPtw0M8LgvWj0GHvNJcMpn+NT763Qcuk98xIA0NvS
	 /IWOfGBVw57RAlyEozA52ssGG1v4D5UwrA2SCRhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 357/473] s390/boot: Remove alt_stfle_fac_list from decompressor
Date: Thu,  6 Jun 2024 16:04:46 +0200
Message-ID: <20240606131711.715745222@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit e7dec0b7926f3cd493c697c4c389df77e8e8a34c ]

It is nowhere used in the decompressor, therefore remove it.

Fixes: 17e89e1340a3 ("s390/facilities: move stfl information from lowcore to global data")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c | 1 -
 arch/s390/kernel/setup.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index e0863d28759a5..bfb4dec36414a 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -30,7 +30,6 @@ int __bootdata(is_full_image) = 1;
 struct initrd_data __bootdata(initrd_data);
 
 u64 __bootdata_preserved(stfle_fac_list[16]);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 void error(char *x)
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 2ec5f1e0312fa..1f514557fee9d 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -155,7 +155,7 @@ unsigned int __bootdata_preserved(zlib_dfltcc_support);
 EXPORT_SYMBOL(zlib_dfltcc_support);
 u64 __bootdata_preserved(stfle_fac_list[16]);
 EXPORT_SYMBOL(stfle_fac_list);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
+u64 alt_stfle_fac_list[16];
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 unsigned long VMALLOC_START;
-- 
2.43.0



