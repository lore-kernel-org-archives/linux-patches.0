Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680776FAF;
	Tue,  5 Dec 2023 03:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzMjkdVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF7CC433C9;
	Tue,  5 Dec 2023 03:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746991;
	bh=1vc3EouIa3+22C4v7PfSFVrSUnkYujnZ6qNjbyaVdEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzMjkdVlG3Wpmg/YR1fnZGDe3WvNPjt5IDTQvdwF60vZmS3BdL92CbId8pFdaKkCM
	 drFsBLyUZ40kFKZI2XRbuV53ywSGmsboHj+9h7PT4ebv0tMqDMbp5RF2xIRm++WzaP
	 PJGGJzbzNaZLszHauYUlE9YhxV64EAG1Y1utIlBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 019/107] drm/amd: Enable PCIe PME from D3
Date: Tue,  5 Dec 2023 12:15:54 +0900
Message-ID: <20231205031532.839491897@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 6967741d26c87300a51b5e50d4acd104bc1a9759 upstream.

When dGPU is put into BOCO it may be in D3cold but still able send
PME on display hotplug event. For this to work it must be enabled
as wake source from D3.

When runpm is enabled use pci_wake_from_d3() to mark wakeup as
enabled by default.

Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2200,6 +2200,8 @@ retry_init:
 		pm_runtime_mark_last_busy(ddev->dev);
 		pm_runtime_put_autosuspend(ddev->dev);
 
+		pci_wake_from_d3(pdev, TRUE);
+
 		/*
 		 * For runpm implemented via BACO, PMFW will handle the
 		 * timing for BACO in and out:


