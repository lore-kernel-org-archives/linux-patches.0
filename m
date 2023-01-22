Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAFF2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BC1C433D2;
	Sun, 22 Jan 2023 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401311;
	bh=mwsiSDhFnGKTbBTN/m5cyJGzHiDtjtPlj7bldYwKRwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irJx0I08gItU8TsNMeydpmN6b/4GmZw5JfI4mWk8J8f1hu9ISZxvMBkefYvmLaFzF
	 mGwmnudKtRqO1bgONX1/MCIZnMWzalH/8b1icgwHFpgQl6Xuz1PObpoMJDKocPCB3j
	 w7Aod4A2HqDlRbyCWuPaijNbjjlffgn0rkRSA3qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 162/193] drm/amdgpu/discovery: enable gmc v11 for GC 11.0.4
Date: Sun, 22 Jan 2023 16:04:51 +0100
Message-Id: <20230122150253.804949793@linuxfoundation.org>
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

commit d5fd8c89ed206b2df3933bc4ea129401b2b60869 upstream.

Enable gmc (graphic memory controller) v11 for GC 11.0.4.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1552,6 +1552,7 @@ static int amdgpu_discovery_set_gmc_ip_b
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
+	case IP_VERSION(11, 0, 4):
 		amdgpu_device_ip_block_add(adev, &gmc_v11_0_ip_block);
 		break;
 	default:


