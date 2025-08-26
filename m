Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3D53002B9;
	Tue, 26 Aug 2025 11:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207655; cv=none; b=IUVTNlTHK7LbGiJr/nlaZk+pvbLwtlH0XqoB7GxQs+sXQQx/aBT8BiGJwzRGqNJG1/psUuLy/40bmbq9CR/+015bptIDQ6k2N5eZZsp4SyOjg7U7qpDyFIFBb17pEVktb33J0ROi5CQgUCf0fMJMI+GBDNn5SLzKglP81ePqXrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207655; c=relaxed/simple;
	bh=VP9KTsmxZUNINOhI8B02GVA/Q0ewrTQwPjnYBPKU1sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxpCk6Hj+Q1kj1IXbarxl1sX8zKF7T2jxtUnqqRWkc5v7a/25j7RSnogxtt8kGjzhnMql1ec7R1vFksd8kQFoQfs+NXE18Yk8JIpm0YEemPWRdwYWJAhppcvzR/6Nlp8dyNVbNsIt0s4jBX6XnvHAZZcolPch9/xku+YPYrgO00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E062t3mM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E062t3mM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AEBC4CEF4;
	Tue, 26 Aug 2025 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207654;
	bh=VP9KTsmxZUNINOhI8B02GVA/Q0ewrTQwPjnYBPKU1sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E062t3mMoQRQ/8Hu0Pyzvro4C5/qutu7AKH9m057m++hQp/pTC++xBbhuqUUsPA5u
	 aPYv+4Zhagau7EruNfJUzb7fM+CnazNUVrUOQeU25MQx8u4DvPKXaw8aDQmCimERFH
	 vys5UMXRCmt7Em5HmXNeZh5f31cISjUJ9OzL4h2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.16 266/457] drm/amd/display: Avoid a NULL pointer dereference
Date: Tue, 26 Aug 2025 13:09:10 +0200
Message-ID: <20250826110943.951651857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 07b93a5704b0b72002f0c4bd1076214af67dc661 upstream.

[WHY]
Although unlikely drm_atomic_get_new_connector_state() or
drm_atomic_get_old_connector_state() can return NULL.

[HOW]
Check returns before dereference.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1e5e8d672fec9f2ab352be121be971877bff2af9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7761,6 +7761,9 @@ amdgpu_dm_connector_atomic_check(struct
 	struct amdgpu_dm_connector *aconn = to_amdgpu_dm_connector(conn);
 	int ret;
 
+	if (WARN_ON(unlikely(!old_con_state || !new_con_state)))
+		return -EINVAL;
+
 	trace_amdgpu_dm_connector_atomic_check(new_con_state);
 
 	if (conn->connector_type == DRM_MODE_CONNECTOR_DisplayPort) {


