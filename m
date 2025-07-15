Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F982472AE;
	Tue, 15 Jul 2025 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585513; cv=none; b=SkH+2YTB/gG+WI5SjfkapIfCoFHn9ognE+L7jyb8TByNU/WpsJ8uS9ztD9y0QjPTeNFZzX3V3pT+JmoJabOcmzHZhtb+xeV1v8+w9cCXHZRRR86mAg7qNP+J+XUqxfjLjsv6BsKVUzrb4IY9nAmW2qDmnmXAMgtLPUK535U44SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585513; c=relaxed/simple;
	bh=lrjwa8sbEm6F+AJJWwM2/4B+muj4eKa6HFttNLsjQqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nduf/7jWey6QeQ/ep2rwyKnYS6NsNMMYvAUOsNP6kpxt9QyGtrOb9uXumdf9pNbTUxT4mP+eN9jCxWV4cyHkCh17QLAGG530HHIQDV4O7aqcTEa0G5geYc9xMDeudYVkYX0gf3rR65ug+Lh0J57yLMoBtnfy2duaNd6Td1Bz9AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZvVzTTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZvVzTTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABBDC4CEE3;
	Tue, 15 Jul 2025 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585513;
	bh=lrjwa8sbEm6F+AJJWwM2/4B+muj4eKa6HFttNLsjQqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZvVzTTG667E0lbp4Wp9rvyl+HHlCFsK2TBXt9aj271MfmjVK7MK2j7bq+4WiV1V2
	 R89nGUfXPdB1ITghRCniZqIa5Mv3GZYg8jD9WGpDA96J3jPF9OPvh6btstitjZj8hz
	 SwImlnPJQqgDKfZZESpGRq8VHh/hXuMok/zDdC8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.12 051/163] x86/mce: Dont remove sysfs if thresholding sysfs init fails
Date: Tue, 15 Jul 2025 15:11:59 +0200
Message-ID: <20250715130810.805566106@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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
@@ -2756,15 +2756,9 @@ static int mce_cpu_dead(unsigned int cpu
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


