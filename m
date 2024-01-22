Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F85E664CD;
	Tue, 23 Jan 2024 01:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971675; cv=none; b=plnH/7m4B1Oop4QLauuSs7Sc6Gh2H6SbkA4IGuXMmk6gtro/vav5/QjbWlBsnrFR+Wlvt2HFu+U87oPerjhE0LXehlSKBGaf2cyTANq9VFsuvjWdeUVfvlIzsvUgFyXX48NHI3pk4INv4yf5s5ye+/s9fq1gWl4uuZu1Qw3HL04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971675; c=relaxed/simple;
	bh=ccHr1y8rsEEK8fsyaYjmrsnjx1JRrgSfVBM+cjKaGo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxRiNI3ol7YY0yI+FaWc0wMF762V2E4yICTYs+PvF/lai0CgwceqnilRP1YH5wMf+tsm2KLT0G5M/JOiEYi9z1OpEPoL8TZr4cX8ts+2EJW/yYRFBhDUzMAMfu3X7W2s1NDqr/bMezziflIzPb4FQIvvy6k2lVtTeivQ6xfkZVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7afDQMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7afDQMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D01C433C7;
	Tue, 23 Jan 2024 01:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971674;
	bh=ccHr1y8rsEEK8fsyaYjmrsnjx1JRrgSfVBM+cjKaGo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7afDQMXt+eRaghN+sgnVTMGmQHRMT1QhDytkcyVT2PmpC/us+9MMSN6nTs/tXr7D
	 CNC88ud63GNCfe+R1SsS/MKCUi5+e4pqqmYHA+hLcS9EurCCPLxIBoui4jhR1luISw
	 cpC00FQTC5a8QYUMJOq5JNAoZED2QT16T/d7e56Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 294/417] drm/amd: Enable PCIe PME from D3
Date: Mon, 22 Jan 2024 15:57:42 -0800
Message-ID: <20240122235802.013917484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

commit bd1f6a31e7762ebc99b97f3eda5e5ea3708fa792 upstream.

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
@@ -2202,6 +2202,8 @@ retry_init:
 
 		pci_wake_from_d3(pdev, TRUE);
 
+		pci_wake_from_d3(pdev, TRUE);
+
 		/*
 		 * For runpm implemented via BACO, PMFW will handle the
 		 * timing for BACO in and out:


