Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831378;
	b=VkdupR/4cjrLbsgeh4tqZWlQaIFMRV7vOiy9VpGxEcWcUtbO5x0jn6ZypguF5kWloZiJ
	 +O4EaxCR+1hmXFuHkIue0f2sf3he5d6efIHLYFHd1wh7MtT+noruGGVu87YDjBCvieSfo
	 t4KZGn/SEXsL6dH+qDZ+y7op8o1fb2ksLlfhpHCkVb04AJqCy7c9r5m76DV+5JWvk6RVP
	 tgQWV8a44nQ1aygLr6lD21eMrdNAHx6PCEQShfoKBgf6aCuaxuflH2T8H60z8AJW/PMR8
	 kX+f4J015Q8dVMCIMKy8rA+3Rn63ku9d2/vPMKWM9i1ORgkJgJK1FXpLa7U7iAlAy2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oqFaObiHM5l3WT3IHgvnPJtXCsKsgRfmKzv9akLPvCM=;
	b=AqmBqfIb4SkAsqsj8T4Wq/ObBHYqmyOQ20XkKiSRlE87WdUalh1Az965YLJMreAC1A32
	 JCjC1X2mHMNifkPLmfxbPgMyD0TLSEOlCGg44NWy4AjJbo76/pNkpMH3q7foIBn1yjWis
	 NvlJkFqMdCniGFMgnPJ6mk8951LWs8Yo1oobpx4K0cQxP3PjQsuFYAawiJZMU2nD5LDP/
	 DAWTyUtJTLb+YjVjMNwObANHuCFvMh2Z7ceZ2n8g2SHjKgZPML5CNAsqL8XOzJnAwyyTj
	 iBm9k10IdcGcfzSAEUSxusdBrJHI6YgzyK1pZqNIzji/KyVP930bl9HqX+mI4LIcDvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFzglgQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92043606A337;
	Wed,  4 Nov 2026 22:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yFzglgQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9851F000C1;
	Wed,  4 Nov 2026 22:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831378;
	bh=oqFaObiHM5l3WT3IHgvnPJtXCsKsgRfmKzv9akLPvCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFzglgQW4RXGoWUyKL9jslLLJYQbu3s7kNXMI7QMeQUlQrCweKwXghzCWhHD/dzHV
	 6oXyt7Vt2PzpiXklhNa75ZSVwWUryl/w/hKPi/x7P9CJV1jqUFMoBBp7c2upzRLtK5
	 t8DvXwPe2yyxk1duy4Wt1vkuqos4uxlhYqeEBgGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 0668/1005] platform/x86/amd: hfi: Fix a use-after-free when unloading the driver
Date: Wed,  4 Nov 2026 16:06:41 -0500
Message-ID: <20261104211102.367219525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 55d8406dfa2fa8ad8ac2f053c2a53a97d8b0ce48 upstream.

amd_hfi_probe() registers CPU hotplug callbacks with
cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, ...) and schedules the static
sched_amd_hfi_itmt_work work item, but amd_hfi_remove() tears down
neither.  The dynamically assigned hotplug state returned by
cpuhp_setup_state() is discarded, so cpuhp_remove_state() can never be
called, and the pending work is never cancelled.

After the module is unloaded and its memory is freed, any subsequent CPU
hotplug event or execution of the scheduled work dereferences the stale
callback and work function pointers, resulting in a use-after-free and
kernel panic.

Store the hotplug state returned by cpuhp_setup_state() and, on removal,
call cpuhp_remove_state() to unregister the callbacks and
cancel_work_sync() to flush the scheduled work before the module memory
goes away.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: bb20421c05fc ("platform/x86: hfi: Add online and offline callback support")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260921170411.1149960-2-mario.limonciello@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/hfi/hfi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/amd/hfi/hfi.c
+++ b/drivers/platform/x86/amd/hfi/hfi.c
@@ -76,6 +76,8 @@ struct amd_hfi_data {
 	struct amd_shmem_info	*shmem;
 
 	struct dentry *dbgfs_dir;
+
+	int cpuhp_state;
 };
 
 /**
@@ -245,6 +247,8 @@ static void amd_hfi_remove(struct platfo
 {
 	struct amd_hfi_data *dev = platform_get_drvdata(pdev);
 
+	cpuhp_remove_state(dev->cpuhp_state);
+	cancel_work_sync(&sched_amd_hfi_itmt_work);
 	debugfs_remove_recursive(dev->dbgfs_dir);
 }
 
@@ -502,6 +506,7 @@ static int amd_hfi_probe(struct platform
 				amd_hfi_online, amd_hfi_offline);
 	if (ret < 0)
 		return ret;
+	amd_hfi_data->cpuhp_state = ret;
 
 	schedule_work(&sched_amd_hfi_itmt_work);
 


