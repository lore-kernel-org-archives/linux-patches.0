Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7094B76051;
	Mon, 29 Jan 2024 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548632; cv=none; b=fT4kyPMDpzqTjUYMqPf/K7gqOWMoyVCIHjFWeRsNpjNwSNLHBJNONQRpS4XsxaLaCvJ5cw8vdAqm91j7UpkMGiRlj6ZLaLT2pkmWAQLy+w595gQ9pmFRmWFZTz45gFQva+63BJ+4C9d43QvMUwMuToAfiuXHLtRX6nrbTqiYwww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548632; c=relaxed/simple;
	bh=YQyhMyeEMHnSsZcIMYHYvErFBUHwaedmZw9HjloZEVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtWQph5cELOEljytWYt3XnWJW7Dm/NNMvqhcYFfNMN3xNLoMpdN5+9YyDZCDT0iNKgMbRuqwaOMH0cf2DHfHRlRPoKMrMeXeBfiKllT+MQzJseEAD1Lc55VnibCaaFIlfu9Jv2GpNF1HlfvH+E2E/viJxyJFtbM+VG67a55o+vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQuMxoKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQuMxoKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A77FC433C7;
	Mon, 29 Jan 2024 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548632;
	bh=YQyhMyeEMHnSsZcIMYHYvErFBUHwaedmZw9HjloZEVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQuMxoKAwiI4scFr+YCtHogzif3INRiTZoSA6y1za7OS9mDz6HfmnHUBOvXkv7SXs
	 YONOaAsh1u+KgbgAhuZo/+u6vARkM2ko2+DjQdQ4EOY7aIAgS330U9cSan94QqjTjD
	 mcLhz/uajlZjNWfiQUSEZnb8Sq4N9uhHlQtySDCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 272/331] drm/amd/display: Fix uninitialized variable usage in core_link_ read_dpcd() & write_dpcd() functions
Date: Mon, 29 Jan 2024 09:05:36 -0800
Message-ID: <20240129170022.824973145@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit a58371d632ebab9ea63f10893a6b6731196b6f8d upstream.

The 'status' variable in 'core_link_read_dpcd()' &
'core_link_write_dpcd()' was uninitialized.

Thus, initializing 'status' variable to 'DC_ERROR_UNEXPECTED' by default.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dpcd.c:226 core_link_read_dpcd() error: uninitialized symbol 'status'.
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dpcd.c:248 core_link_write_dpcd() error: uninitialized symbol 'status'.

Cc: stable@vger.kernel.org
Cc: Jerry Zuo <jerry.zuo@amd.com>
Cc: Jun Lei <Jun.Lei@amd.com>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
@@ -205,7 +205,7 @@ enum dc_status core_link_read_dpcd(
 	uint32_t extended_size;
 	/* size of the remaining partitioned address space */
 	uint32_t size_left_to_read;
-	enum dc_status status;
+	enum dc_status status = DC_ERROR_UNEXPECTED;
 	/* size of the next partition to be read from */
 	uint32_t partition_size;
 	uint32_t data_index = 0;
@@ -234,7 +234,7 @@ enum dc_status core_link_write_dpcd(
 {
 	uint32_t partition_size;
 	uint32_t data_index = 0;
-	enum dc_status status;
+	enum dc_status status = DC_ERROR_UNEXPECTED;
 
 	while (size) {
 		partition_size = dpcd_get_next_partition_size(address, size);


