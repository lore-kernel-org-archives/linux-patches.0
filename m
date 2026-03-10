Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82802BF3E2;
	Tue, 10 Mar 2026 11:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141171; cv=none; b=K0b9Z+k/2QemsfQ85B68AO+Od+LTaVr3HDE4sV9KAuBxITq6tQMO+T/bLYiVs93RRi94RFnjH6uH6MuYfM3BIZH3/lgkweY94qVpGJlH1QtfxLcB9xxi9MDtSIyFYb5n4/MW/ExtnQNZHhFgtHXdEMISrTue79hDSSKWc6zEvmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141171; c=relaxed/simple;
	bh=JKi608qZyMpKuBvdScc+RP+MxXRHNdweq5xnN7SwXzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VKXCoqa8iMr+wpWbVpQY3IPP4MORAxAJxTVLsppFpRzDMA6PcwODHRB1F/zLTQBrde48q2DX2H9DiKx+r5fqd/93dWiBDKLUMLLbUYkG8AQHmsr6H8sohOk0VNW8K4m6cyWkXFYSCp2B5JofVmIJJ1L5Ww5CpN9toTCjnELMXQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7Xtp230; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7Xtp230"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A97C19423;
	Tue, 10 Mar 2026 11:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141171;
	bh=JKi608qZyMpKuBvdScc+RP+MxXRHNdweq5xnN7SwXzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7Xtp230GCDZh7T9kV7z9txh3Cn5oEWapuC6lgDS7sH9pFgn4ngI5TQqEYJtoPobu
	 nWMAWEiCuASMq2XWcgoFZd4qVYF6TTyHaVZyIRCLuoPe5LV2WfIafAMa6+yoTWVnLz
	 noBfjRMK8Iel/028w5SYLbTLEwZDbQblvF9lKpjE1g/AmpDDtR6E8ri4cK2fmPCMs7
	 A9CvD2P5T43UYf142AjBHhQTdTSiTOJEo9JK8RGhmzlPMIBZ7w6qnYo6QW5CQWmTKL
	 pqjR3wtOP7N4osXWxltZCGf6Hi7dhANDCvXdOCxCGOF4hQ2tbqO+biTd1fqwEpcPmG
	 /VYRSomHFNiGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Paul Kerry <p.kerry@sheffield.ac.uk>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 172/311] platform/x86: hp-bioscfg: Support allocations of larger data
Date: Tue, 10 Mar 2026 07:03:39 -0400
Message-ID: <351741268fcdfdd10b777be90daca6522aed9453.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 916727cfdb72cd01fef3fa6746e648f8cb70e713 upstream.

Some systems have much larger amounts of enumeration attributes
than have been previously encountered. This can lead to page allocation
failures when using kcalloc().  Switch over to using kvcalloc() to
allow larger allocations.

Fixes: 6b2770bfd6f92 ("platform/x86: hp-bioscfg: enum-attributes")
Cc: stable@vger.kernel.org
Reported-by: Paul Kerry <p.kerry@sheffield.ac.uk>
Tested-by: Paul Kerry <p.kerry@sheffield.ac.uk>
Closes: https://bugs.debian.org/1127612
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260225210646.59381-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ kcalloc() => kvcalloc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
index f346aad8e9d89..af4d1920d4880 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
@@ -94,8 +94,11 @@ int hp_alloc_enumeration_data(void)
 	bioscfg_drv.enumeration_instances_count =
 		hp_get_instance_count(HP_WMI_BIOS_ENUMERATION_GUID);
 
-	bioscfg_drv.enumeration_data = kcalloc(bioscfg_drv.enumeration_instances_count,
-					       sizeof(*bioscfg_drv.enumeration_data), GFP_KERNEL);
+	if (!bioscfg_drv.enumeration_instances_count)
+		return -EINVAL;
+	bioscfg_drv.enumeration_data = kvcalloc(bioscfg_drv.enumeration_instances_count,
+						sizeof(*bioscfg_drv.enumeration_data), GFP_KERNEL);
+
 	if (!bioscfg_drv.enumeration_data) {
 		bioscfg_drv.enumeration_instances_count = 0;
 		return -ENOMEM;
@@ -444,6 +447,6 @@ void hp_exit_enumeration_attributes(void)
 	}
 	bioscfg_drv.enumeration_instances_count = 0;
 
-	kfree(bioscfg_drv.enumeration_data);
+	kvfree(bioscfg_drv.enumeration_data);
 	bioscfg_drv.enumeration_data = NULL;
 }
-- 
2.51.0

