Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAD179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211C5C433C1;
	Wed, 30 Nov 2022 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833764;
	bh=46UvzyelCq8GbyjFibm3Z40Nu06JkthG4HN2tCshAk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJPgWOMCN20H4AZUsYJZslCYfVe0jtwClGy1cuOwlKrhviyc6S1jWsGv/k2F3ja3n
	 bi0bhtOm3He4nzh/sjd1OuU5hZ6r41t6MJj6nwHyacsWYoZaqAzcOBDqCmvsHHcsMk
	 tJhOYMRFNmdKUIINRMEiYxVo76ZyidYnwhln4rP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <Jerry.Zuo@amd.com>,
	Brian Chang <Brian.Chang@amd.com>,
	Tsung-hua Lin <Tsung-hua.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 203/206] drm/amd/display: No display after resume from WB/CB
Date: Wed, 30 Nov 2022 19:24:15 +0100
Message-Id: <20221130180538.189500424@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tsung-hua Lin <Tsung-hua.Lin@amd.com>

commit a6e1775da04ab042bc9e2e42399fa25714c253da upstream.

[why]
First MST sideband message returns AUX_RET_ERROR_HPD_DISCON
on certain intel platform. Aux transaction considered failure
if HPD unexpected pulled low. The actual aux transaction success
in such case, hence do not return error.

[how]
Not returning error when AUX_RET_ERROR_HPD_DISCON detected
on the first sideband message.

v2: squash in fix (Alex)

Reviewed-by: Jerry Zuo <Jerry.Zuo@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Tsung-hua Lin <Tsung-hua.Lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1374,7 +1374,44 @@ static const struct dmi_system_id hpd_di
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Tower 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex SFF 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro Plus 7010"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex Micro 7010"),
+		},
+	},
 	{}
+	/* TODO: refactor this from a fixed table to a dynamic option */
 };
 
 static void retrieve_dmi_info(struct amdgpu_display_manager *dm)


