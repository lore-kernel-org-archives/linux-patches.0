Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530D76AA0;
	Tue,  5 Dec 2023 03:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqhDPrfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BB0C433C8;
	Tue,  5 Dec 2023 03:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746534;
	bh=/3DC3lcw2xo9aJ9q6KhSx7JDNb/0WpdErXGzb981nik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqhDPrfjhEpZHmkfp+rOq2JWbGpQk0JLHvCOP/FJVh2UYU3d1IFLQGURflrLL7JIM
	 uyONj23ZnGv4wdI3Ota3mRzNIpB+zMbQIjtvGJi3x6XKYTpOBdbY/2ztyIhpsKPfnm
	 I1mwfkrBIf2JBGMnpUohTeyYPZdu+xckBQ1aFOXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 026/134] drm/amd: Enable PCIe PME from D3
Date: Tue,  5 Dec 2023 12:14:58 +0900
Message-ID: <20231205031537.060706958@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2195,6 +2195,8 @@ retry_init:
 		pm_runtime_mark_last_busy(ddev->dev);
 		pm_runtime_put_autosuspend(ddev->dev);
 
+		pci_wake_from_d3(pdev, TRUE);
+
 		/*
 		 * For runpm implemented via BACO, PMFW will handle the
 		 * timing for BACO in and out:


