Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F0515A48F;
	Mon, 29 Jan 2024 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548266; cv=none; b=XR1rw14Sn50XlMP76dliJ0n9Ubc15hZwBHpX1F0YzixvXFLjfgTXODmIMp7jKpICa6q3y+ljBiQyWQNVr91DNVaCiqxgCy5D3hCTRKoJx1OriYKJEhpdEurTfQS9Li4SMffoXNdMU2vAHHhA/vi2EvTG953Omc/dfMRMI2djRfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548266; c=relaxed/simple;
	bh=9mUctPfTMI7KNnDCHXWdzLFR8DlJP0W6Gs44Xqp9cH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9V0QFRlgJJOFxqxYaeCWRI2h53txLsLSBxrqtJVJSKF9QeTtkfTsRf6rLDA1huCd3KHhlC03N/yV87QSYbjmCajdsCmP9cCMlPZ/eL/y+39wDgLqcRn/sgHoz1HQL2ByHEPjmOrG4GCllzsosYE2Uz30cqnPfqVx8uWRBybPc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSBOWmhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSBOWmhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DE0C433C7;
	Mon, 29 Jan 2024 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548266;
	bh=9mUctPfTMI7KNnDCHXWdzLFR8DlJP0W6Gs44Xqp9cH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSBOWmhORh1hFexCHR8LD4+ToOA5LGPEhWG5hzBRm228LH0XPBP0VHQHeo3PYZ0eQ
	 fBPlgecypLdaAVxOw4YPouycGV7PgWhlM3UgQo8AV4yBEMkwYa7nVJKWsgd7sHw3CU
	 70UHduO1GyFUiWbnmZhVVkPdWwjsSll+GEkjwkYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 260/346] drm/amd/display: Fix a debugfs null pointer error
Date: Mon, 29 Jan 2024 09:04:51 -0800
Message-ID: <20240129170024.044151445@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit efb91fea652a42fcc037d2a9ef4ecd1ffc5ff4b7 upstream.

[WHY & HOW]
Check whether get_subvp_en() callback exists before calling it.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alex Hung <alex.hung@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -3647,12 +3647,16 @@ static int capabilities_show(struct seq_
 	bool mall_supported = dc->caps.mall_size_total;
 	bool subvp_supported = dc->caps.subvp_fw_processing_delay_us;
 	unsigned int mall_in_use = false;
-	unsigned int subvp_in_use = dc->cap_funcs.get_subvp_en(dc, dc->current_state);
+	unsigned int subvp_in_use = false;
+
 	struct hubbub *hubbub = dc->res_pool->hubbub;
 
 	if (hubbub->funcs->get_mall_en)
 		hubbub->funcs->get_mall_en(hubbub, &mall_in_use);
 
+	if (dc->cap_funcs.get_subvp_en)
+		subvp_in_use = dc->cap_funcs.get_subvp_en(dc, dc->current_state);
+
 	seq_printf(m, "mall supported: %s, enabled: %s\n",
 			   mall_supported ? "yes" : "no", mall_in_use ? "yes" : "no");
 	seq_printf(m, "sub-viewport supported: %s, enabled: %s\n",


