Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214649;
	b=tk4Fp3Cxcx2EORDA5VxAJB636gs5BbgVUMcn2XSVuf1ZasV9VeiEqhMiDe8O8hXlnC5g
	 UgshLfv2J+t1mqUI0AWHCIoKdwir0BXgCKPB3TkSubKt/8FnuvsuKNi6x/t3+FxQnffvw
	 8nPpAcOhN638AhopI9xz8dWrwfqmqKBqrCV/oZ9rfznXB7uk7GX6AEFwRCKEewMajegDD
	 /mbMTEqXp7rnZ3A9ScR94ndvlEhUeF68vBttKp3sP8ubaBlZZMxImNzTWWcnwlnGYKhtI
	 ZgR7pT87DuQL/5rdUvhJORA6pj3AK0175KR58X/rmAeuTdnrHCfgiQ4mu8cWkOZAMbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=INIYMzRwAgsZxC70n/x/d0jmkpwrpm3ByvopJKBEg80=;
	b=yMgxKCpBTDqBn6coy7nNrLe3mfpBvItq5or67PeygevSumo6qNvFo2om2cUDhhJ+IlSw
	 0JEYh6EmU2n9USyA8CZZp1rwM1QwW7W+DLdLLsXXoJLTqIKKpsL7kIZWab9SWQMg9ZjTk
	 Tasl87eAxUpYeWqcfLBqWexQFy0RDAsLB6I4A7qKO/i4YrebVBx6TioccczcbAIVa3V6T
	 naBecQrd9TTdbXmirIfVQ1xRM8jNT14W5fa8Q+Oj2kbDPwZYfA0gFUTWgMTWaQSfASuQ+
	 Xr1FRI5MF4QjWY9XqWyN5V4dbdZXFvMM9tHOj05vmKZz7zNyYTNU0wChL8H5xEclGAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQN6JDlP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679C4606B7E0;
	Wed, 28 Oct 2026 19:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQN6JDlP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C6F1F01825;
	Wed, 28 Oct 2026 19:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214649;
	bh=INIYMzRwAgsZxC70n/x/d0jmkpwrpm3ByvopJKBEg80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQN6JDlPhdtazNOYeFVq+YfAm0KKc7QZEPg7dzc76BBMsfPKb5W/9MIg7tWJuXrjX
	 3iiDWvxou50P/yy+MReQibLOycsEVVU96NilcRoiNJmSUCb3yzfAZKmmswjcUmIKGk
	 VZEX7UO3r2qNe1gx8bRTCcO6oHvTrYo+ghQtayiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0932/1887] drm/amd/pm: Disable MMIO access during SMU Mode 1 reset
Date: Wed, 28 Oct 2026 17:50:28 +0100
Message-ID: <20261028170520.622726513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 0de604d0357d0d22cbf03af1077d174b641707b6 ]

During Mode 1 reset, the ASIC undergoes a reset cycle and becomes
temporarily inaccessible via PCIe. Any attempt to access MMIO registers
during this window (e.g., from interrupt handlers or other driver threads)
can result in uncompleted PCIe transactions, leading to NMI panics or
system hangs.

To prevent this, set the `no_hw_access` flag to true immediately after
triggering the reset. This signals other driver components to skip
register accesses while the device is offline.

A memory barrier `smp_mb()` is added to ensure the flag update is
globally visible to all cores before the driver enters the sleep/wait
state.

Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7edb503fe4b6d67f47d8bb0dfafb8e699bb0f8a4)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c           | 4 ++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 8aaa437a06139..d1f7ebfff9907 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4907,6 +4907,10 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 	if (ret)
 		dev_err(adev->dev, "GPU mode1 reset failed\n");
 
+	/* enable mmio access after mode 1 reset completed */
+	if (!ret)
+		adev->no_hw_access = false;
+
 	amdgpu_device_load_pci_state(adev->pdev);
 
 	/* wait for asic to come out of reset */
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index ae8854b90f379..cff7f2589d020 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1894,8 +1894,13 @@ static int smu_v13_0_0_mode1_reset(struct smu_context *smu)
 	else
 		ret = smu_cmn_send_smc_msg(smu, SMU_MSG_Mode1Reset, NULL);
 
-	if (!ret)
+	if (!ret) {
+		/* disable mmio access while doing mode 1 reset*/
+		smu->adev->no_hw_access = true;
+		/* ensure no_hw_access is globally visible before any MMIO */
+		smp_mb();
 		msleep(SMU13_MODE1_RESET_WAIT_TIME_IN_MS);
+	}
 
 	return ret;
 }
-- 
2.53.0



