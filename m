Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DD934CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A58EC4339B;
	Wed,  7 Jun 2023 20:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170645;
	bh=+fiaNuWvO+sr04cZYnicJMdcQuv/ZE7YZM98jLombUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzv621HZBX5VkyFqdiL/+9uohHaipTmI48zkE1HWVOxLuO6MMA1K3Z1QDrbazoUst
	 Q2NCDRpASCSTeqIXjKBjfpWJoK5iC1vF9iEVK8PEYWu3581IlJnA8VnrlKMSjhB/LI
	 qJl2v297ebbpTaO5qsq1Ua22u21kWYDh+jcY+8EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ikshwaku Chauhan <ikshwaku.chauhan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 164/225] drm/amdgpu: enable tmz by default for GC 11.0.1
Date: Wed,  7 Jun 2023 22:15:57 +0200
Message-ID: <20230607200919.763095971@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ikshwaku Chauhan <ikshwaku.chauhan@amd.com>

commit 663b930e24842f3d3bb79418bb5cd8d01b40c559 upstream.

Add IP GC 11.0.1 in the list of target to have
tmz enabled by default.

Signed-off-by: Ikshwaku Chauhan <ikshwaku.chauhan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -526,6 +526,8 @@ void amdgpu_gmc_tmz_set(struct amdgpu_de
 	case IP_VERSION(9, 3, 0):
 	/* GC 10.3.7 */
 	case IP_VERSION(10, 3, 7):
+	/* GC 11.0.1 */
+	case IP_VERSION(11, 0, 1):
 		if (amdgpu_tmz == 0) {
 			adev->gmc.tmz_enabled = false;
 			dev_info(adev->dev,
@@ -548,7 +550,6 @@ void amdgpu_gmc_tmz_set(struct amdgpu_de
 	case IP_VERSION(10, 3, 1):
 	/* YELLOW_CARP*/
 	case IP_VERSION(10, 3, 3):
-	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 4):
 		/* Don't enable it by default yet.
 		 */


