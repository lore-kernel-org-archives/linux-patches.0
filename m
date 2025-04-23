Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FDD29B79B;
	Wed, 23 Apr 2025 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421469; cv=none; b=kxdl9RSCYnSy3+tP1UOILfGpW1ZzQSv0amQLMnkDc0yVzuT0zLUvcUaGxfzT4XO4ywKNCqYgF4rfY0nvHImLHmQRevYQ/3qC0knms6xVidhSRFUXjIczRk6NtG2F3UpA/AHLErOc/gdOtQbM5EqeMblXsm6oogKmZ6OWTs62vGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421469; c=relaxed/simple;
	bh=Y7G7pjhdlvTQ1eUrKKkUeWnePrBtp5J5MGMO4p+8xr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYepupgd1KBvnNNeA+ahl9caLgfMOjC6PXF3+ehLK+n77SuCFRf/YxjHHPeTeCxKzWRFUlgd2vVfPen6sLPGJwHHW+iJEIvdKU3mdrygu/SfGckVMrLpADS438SZEVvZLObxo8AA0iijLI4qN31KGO92QXDSStduogF8Wxbehl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6YGZcsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6YGZcsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D78C4CEE2;
	Wed, 23 Apr 2025 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421468;
	bh=Y7G7pjhdlvTQ1eUrKKkUeWnePrBtp5J5MGMO4p+8xr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6YGZcsbLv1rwYI4Ppl3LeTUnBfzIDdjTxWAPks/xVkbShogTXI8cCVCUC8ireRnS
	 CLSyMtYcFaOBJ7lRjezk0sGy2ZzK34woLsGINEgsrpCNUj9JfCl5gZ5hulfKitPROS
	 vcfTJb4yVDNHpGM5Hhx2sHrpfjpTFqauhd5SNHi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 192/241] drm/amd/display: Add HP Elitebook 645 to the quirk list for eDP on DP1
Date: Wed, 23 Apr 2025 16:44:16 +0200
Message-ID: <20250423142628.361739470@linuxfoundation.org>
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

commit 1c5fdef30ed120613e769a3bd2a144cfd4c688d6 upstream.

[Why]
HP Elitebook 645 has DP0 and DP1 swapped.

[How]
Add HP Elitebook 645 to DP0/DP1 swap quirk list.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3701
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1719,6 +1719,13 @@ static const struct dmi_system_id dmi_qu
 		.callback = edp0_on_dp1_callback,
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 645 14 inch G11 Notebook PC"),
+		},
+	},
+	{
+		.callback = edp0_on_dp1_callback,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 665 16 inch G11 Notebook PC"),
 		},
 	},


