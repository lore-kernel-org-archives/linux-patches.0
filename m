Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5107D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC451C433EF;
	Sun, 22 Jan 2023 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401251;
	bh=WXxgpOT5R9mT5tSAywEaI+6GteTNLlSREdECU19kVnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uH/mZNq1b4ZabekQd52Dnw8LmnXsN90w+BEX2mrMASHE/1VDlNYSZl+Y3o/Fql5Ws
	 MRJB+qovWmyLNrn+3x3m19bw03CpaxgtIkQxu5URwnSURYHBZ+zLxcEFG6Qt//KC3J
	 zRLW+P3n5F0XM04DAb4DSY3JfFWmkZ6wyA4ahM8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 168/193] drm/amdgpu: add gmc v11 support for GC 11.0.4
Date: Sun, 22 Jan 2023 16:04:57 +0100
Message-Id: <20230122150254.089378221@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yifan Zhang <yifan1.zhang@amd.com>

commit d0ca8248999e4c5b02ac64f40536ff46dc14dda7 upstream.

Add gmc v11 support for GC 11.0.4.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c
@@ -749,6 +749,7 @@ static int gmc_v11_0_sw_init(void *handl
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
+	case IP_VERSION(11, 0, 4):
 		adev->num_vmhubs = 2;
 		/*
 		 * To fulfill 4-level page support,


