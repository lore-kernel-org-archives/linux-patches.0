Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F672F0051;
	Tue, 15 Jul 2025 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587862; cv=none; b=H08tInPM9jjqBrkA47OkkemltCJMTSJT9GjwF0vClDRowg7DRZibS8gkW+5XsFj41v2UG0EeJz2Ug4zWRxHTbpvw8gNoEnK7XBAw6JDmYTJUATK9Og1aacAiQHgqXD0kGX4G+2Z9YjT+/+kymAn9xVtqIS2eeqItU2xwvmufQj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587862; c=relaxed/simple;
	bh=8rpYbgDssQvJqT/o7mMAXVibkQpd//WoEKuq47YMqkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VN/7TWRMFi/mYwkAELcl9Om/YRMSxqNh6u1Sja+icyQcO72zGjNo44XQwdEQ7NyPSLwNOgXqDNn5vDfWVwHyHOmXA3pM7ZwsVFkDkHNmcF5g3bVwXYJjcvoXmx1aLOTqZfRee/gPLqvLKFHLae5fDiRsV9lLoPe7yxF+AXTsb4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXRkeyJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXRkeyJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9711C4CEE3;
	Tue, 15 Jul 2025 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587862;
	bh=8rpYbgDssQvJqT/o7mMAXVibkQpd//WoEKuq47YMqkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXRkeyJYGRhSt8UlLEy6+b0k0mCzGjUF1FbtgmYMU55cqzNY9IUvOWBTSH15CABs1
	 eEexBlQ7Rw1Y0SEXVDqWVT6nFTFMwu7rI1wSwbWPauK6/7EvMaQFIBfMAjYPa0C/9U
	 ZkBnCDGNV4vkMvuR91taDeXZwQSaNYKxVy9TS3bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.10 172/208] x86/mce: Dont remove sysfs if thresholding sysfs init fails
Date: Tue, 15 Jul 2025 15:14:41 +0200
Message-ID: <20250715130817.865443187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 4c113a5b28bfd589e2010b5fc8867578b0135ed7 upstream.

Currently, the MCE subsystem sysfs interface will be removed if the
thresholding sysfs interface fails to be created. A common failure is due to
new MCA bank types that are not recognized and don't have a short name set.

The MCA thresholding feature is optional and should not break the common MCE
sysfs interface. Also, new MCA bank types are occasionally introduced, and
updates will be needed to recognize them. But likewise, this should not break
the common sysfs interface.

Keep the MCE sysfs interface regardless of the status of the thresholding
sysfs interface.

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250624-wip-mca-updates-v4-1-236dd74f645f@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2627,15 +2627,9 @@ static int mce_cpu_dead(unsigned int cpu
 static int mce_cpu_online(unsigned int cpu)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
-	int ret;
 
 	mce_device_create(cpu);
-
-	ret = mce_threshold_create_device(cpu);
-	if (ret) {
-		mce_device_remove(cpu);
-		return ret;
-	}
+	mce_threshold_create_device(cpu);
 	mce_reenable_cpu();
 	mce_start_timer(t);
 	return 0;


