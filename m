Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC872820CC;
	Wed, 23 Apr 2025 15:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420830; cv=none; b=CHPU5u91HqMahioO8k19DmfsXqp7iZvq4XBlcN2JXhABb/74bob1t4YdRC4lq4iHCEpWHwHe5ea1LdLsGd5LhpqSHASoapCmsNbdGcKDedvrN5F1kbo/Bwv/XV51ugMguUZopor5mRB23ise9OYBi7Mf6zv6v1BU2O/CQg71b8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420830; c=relaxed/simple;
	bh=zjDE5/MyZwIct41uQFDVpqJ2LOqJUUHZ9Av+ABeUR6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXoHLP7OREAMB1EhvoxnwBVlx29tmS12zpHZ5Z6xNUhVfFR/jhj3xLzbjQJaCl9LjAdt6kdpyCzYk7aWlH63M3djRyPlFhlQd/0zxqfDVXb53Zh2br2pGypJ+Os2SYN2spBpY8aPEAKjSP1KJx/pNWIoF1Bhk6RIqXA4/BbuR2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO1PZ8B3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO1PZ8B3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB4BC4CEE2;
	Wed, 23 Apr 2025 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420829;
	bh=zjDE5/MyZwIct41uQFDVpqJ2LOqJUUHZ9Av+ABeUR6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YO1PZ8B3MeoJthjenVkrP56n51XaoVg7UYe72e4GGRcAq38iGrHWrdOYpTp/cs9iY
	 vHeogL2A9OlpEDoUf36WwA4koiEZt9fZpmKrzZMHl0TAurTmRr9GjxTCsloONjiESX
	 kuUbPKnx3g6GfzmpRUatefT2WndqExv7QRusyTfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 166/223] drm/amd/display: Add HP Elitebook 645 to the quirk list for eDP on DP1
Date: Wed, 23 Apr 2025 16:43:58 +0200
Message-ID: <20250423142623.930586886@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1694,6 +1694,13 @@ static const struct dmi_system_id dmi_qu
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


