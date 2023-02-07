Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91642C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667FBC433D2;
	Tue,  7 Feb 2023 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775321;
	bh=vxRVJVFsg3ha/9AJLdmNdeyF3VTK/hlw1dKoKN2CMzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVcmwMfm83u8D1caKzV/Ijj0bgZXJRWp5yt5UiunIuuMCh8dCzfoJV8pG6aVi4GvQ
	 GNVlMTdNRyFJafEvjs7Yjs0hUFSzehtomP6AREnpm/KiVJH9kWnX/qmTRFbrSyKTrI
	 nKmaWTdkRMezRu7Zuc35qJMuDD/58aponc9UPUWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 182/208] drm/amd/pm: drop unneeded dpm features disablement for SMU 13.0.4/11
Date: Tue,  7 Feb 2023 13:57:16 +0100
Message-Id: <20230207125642.713925190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

commit 1538709c9f1c207d30afd95ea41b3aeb973f67e7 upstream.

PMFW will handle the features disablement properly for gpu reset case,
driver involvement may cause some unexpected issues.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1499,6 +1499,20 @@ static int smu_disable_dpms(struct smu_c
 	}
 
 	/*
+	 * For SMU 13.0.4/11, PMFW will handle the features disablement properly
+	 * for gpu reset case. Driver involvement is unnecessary.
+	 */
+	if (amdgpu_in_reset(adev)) {
+		switch (adev->ip_versions[MP1_HWIP][0]) {
+		case IP_VERSION(13, 0, 4):
+		case IP_VERSION(13, 0, 11):
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	/*
 	 * For gpu reset, runpm and hibernation through BACO,
 	 * BACO feature has to be kept enabled.
 	 */


