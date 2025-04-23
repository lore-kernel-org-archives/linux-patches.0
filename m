Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931DA28368C;
	Wed, 23 Apr 2025 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421610; cv=none; b=G/cQfihBWsSMOzZAxOfCZbFLXMUKTKoPJET8scEX+IUZJf9Y8mYi/83rk7RaKIf38f4BoA3BAAAV5Nbza0hHS9NoepkJ6/f9neBSq6TkR2XJyLnFXd31jmMre8786iazRnRecMIIpxNMOuI/QIIFvSPyvitsVp5LyWUgqd1Mxv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421610; c=relaxed/simple;
	bh=VZ0gon8WSw6cEqc8UxiYcqRQv/hOtVhGYXGHzf21t4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNk/oOd1BSvyV2/qfjPKLD3GLFWLOxmwoehR6tru1AAzlktLLBOE5F87/FBAz6Dpa4/mDBF4+jEWIgpdjpU8T92ry9Qcj5yDBV8MOUsCKfRtHh5UQ8sTLaC0yyjI9MOAH01m+Bq5hqYQ7Nt3Hf3WSgq9/zyevXy8S729Juy0v/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+BUy0GT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+BUy0GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A74AC4CEE2;
	Wed, 23 Apr 2025 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421610;
	bh=VZ0gon8WSw6cEqc8UxiYcqRQv/hOtVhGYXGHzf21t4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+BUy0GT+7CSp9puNlTN5oTho0Gtm46qyXYdnEWHzDoRnFJwV1DRYIqXrWRz7PJAW
	 xGpiJjhgVLYR6cX1p4k8GpA4N8FaEEKyQuQxo0s/gMG+W1DFlIeaB7eRzk6cNRmEfi
	 3+UWA6tG4J/MAqWAdOkzCf5TfQhY+bsA3Tlrv7BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <roman.li@amd.com>,
	Anson Tsao <anson.tsao@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 211/241] drm/amd/display: Add HP Probook 445 and 465 to the quirk list for eDP on DP1
Date: Wed, 23 Apr 2025 16:44:35 +0200
Message-ID: <20250423142629.166051176@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 139e99d58e373bd11f085766e681d21d34d0b097 upstream.

[Why]
HP Probook 445 and 465 has DP0 and DP1 swapped.

[How]
Add HP Probook 445 and 465 to DP0/DP1 swap quirk list.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3995
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Anson Tsao <anson.tsao@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1729,6 +1729,20 @@ static const struct dmi_system_id dmi_qu
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 665 16 inch G11 Notebook PC"),
 		},
 	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 445 14 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook 465 16 inch G11 Notebook PC"),
+		},
+	},
 	{}
 	/* TODO: refactor this from a fixed table to a dynamic option */
 };


