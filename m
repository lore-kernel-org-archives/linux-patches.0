Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333202590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B193FC433EF;
	Sun, 22 Jan 2023 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401272;
	bh=ekXyULMs7HgD/y3cYUydBC9BMq9XqU6J4rCDj4MQJf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1i/hsJZ9ln1uwTmOabYNtwhMXm9es4dST1Qoo+a6Tg7czBmYcq8/P1n/EBKLnlj59
	 k4LuIHVVLhL00sLmrD1nPU7jtds6q9dtZhMSSz/5eqICjAyUH/KGSxRsBVHwJMWFhh
	 uYgDHefDCCDvt7Oo6IByoqeSt5LtRf4hQV+dPGb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 176/193] drm/amdgpu: enable PSP IP v13.0.11 support
Date: Sun, 22 Jan 2023 16:05:05 +0100
Message-Id: <20230122150254.471856139@linuxfoundation.org>
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

From: Tim Huang <tim.huang@amd.com>

commit 2c83e3fd928b9cb1e35340e58d4b1bd2eea23ed6 upstream.

Enable PSP FW loading for PSP IP v13.0.11

Signed-off-by: Tim Huang <tim.huang@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    1 +
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c  |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -139,6 +139,7 @@ static int psp_early_init(void *handle)
 	case IP_VERSION(13, 0, 5):
 	case IP_VERSION(13, 0, 8):
 	case IP_VERSION(13, 0, 10):
+	case IP_VERSION(13, 0, 11):
 		psp_v13_0_set_psp_funcs(psp);
 		psp->autoload_supported = true;
 		break;
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -46,6 +46,8 @@ MODULE_FIRMWARE("amdgpu/psp_13_0_7_sos.b
 MODULE_FIRMWARE("amdgpu/psp_13_0_7_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_10_sos.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_10_ta.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_11_toc.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_11_ta.bin");
 
 /* For large FW files the time to complete can be very long */
 #define USBC_PD_POLLING_LIMIT_S 240
@@ -102,6 +104,7 @@ static int psp_v13_0_init_microcode(stru
 	case IP_VERSION(13, 0, 3):
 	case IP_VERSION(13, 0, 5):
 	case IP_VERSION(13, 0, 8):
+	case IP_VERSION(13, 0, 11):
 		err = psp_init_toc_microcode(psp, chip_name);
 		if (err)
 			return err;


