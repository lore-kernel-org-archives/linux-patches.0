Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE5C28B4EA;
	Wed, 23 Apr 2025 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420989; cv=none; b=juvg9l5ow2aC7Cagz3LoRW7ozN85/YDY0QmI2YWyULxwQuRdb9JU3S1+v6T67sDDwi10BBhzm1Ihg1z4yzr1PIQKUHlv7gMKjfKMxWDGOCgWhH69zR1xooPN6t/9gSEqSixtPH4yPBPYQUrfbdKcN/zysrACpV43xv4avQaC0xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420989; c=relaxed/simple;
	bh=/02+Pcx7QULbou4fzP2IoBFDpbb5B+KUY0Uk8il9WJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFD3nEXOBhhBflj3lxNniPA4ioXUmtYhuiZl8Vx5rMn1Hue1Pft/V+b+0UNGfNFOGjnIXQuaoyHAsrfJI8v1zganhksy/SKDjyBt5cVA+X0QjDSIPb32V+sns2e3cei3+bPMpZQpGEwF847x9dHOr07bZR1duuXXLTDo84C3bXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkQvmUei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkQvmUei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99E7C4CEE2;
	Wed, 23 Apr 2025 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420989;
	bh=/02+Pcx7QULbou4fzP2IoBFDpbb5B+KUY0Uk8il9WJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkQvmUeiKOhgkXaouybkQtZX8jwOyJrKJ8LHWQWX6SDKDYxxJze8VQRevUJsnZJTS
	 hdG/frGhtlC1ePfHUQoKqonJrtK/BPWmLowsfPEgY9maF7/O/lq811JWl/0l+oJC7Q
	 kV5Q+bG2wsTSKLWWIiWGPZ84SUFYgpeBe/wx+qRQ=
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
Subject: [PATCH 6.12 180/223] drm/amd/display: Add HP Probook 445 and 465 to the quirk list for eDP on DP1
Date: Wed, 23 Apr 2025 16:44:12 +0200
Message-ID: <20250423142624.501080826@linuxfoundation.org>
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
@@ -1704,6 +1704,20 @@ static const struct dmi_system_id dmi_qu
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


