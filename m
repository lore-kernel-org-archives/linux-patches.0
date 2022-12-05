Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A615C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1129EC433C1;
	Mon,  5 Dec 2022 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268543;
	bh=eI4my7pf2pzrQm2ov5/hRsLJkQqVL98ibDBldG0/jHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Meftw4HsEjVQJkEIa/7pfts4F92YhVDUP/6CjGeqL1H4Eh5fIyvt4oOfXNWAW7Nhj
	 n94rmeXxckOfDu5wTXJOSpx6YPBERv61VwFduvwoy17pRLCMysRyoOd6SU4mHyv6sP
	 NcxB32McANQykYTXFx0VMHiQEjDOCiT/yARsWglY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Suarez <cssk@net-c.es>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/92] drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"
Date: Mon,  5 Dec 2022 20:09:21 +0100
Message-Id: <20221205190803.754427166@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 602ad43c3cd8f15cbb25ce9bb494129edb2024ed ]

This partially reverts 20543be93ca45968f344261c1a997177e51bd7e1.

Calling drm_connector_update_edid_property() in
amdgpu_connector_free_edid() causes a noticeable pause in
the system every 10 seconds on polled outputs so revert this
part of the change.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2257
Cc: Claudio Suarez <cssk@net-c.es>
Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index b352c4eb5bbd..aabfe5705bb8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -328,7 +328,6 @@ static void amdgpu_connector_free_edid(struct drm_connector *connector)
 
 	kfree(amdgpu_connector->edid);
 	amdgpu_connector->edid = NULL;
-	drm_connector_update_edid_property(connector, NULL);
 }
 
 static int amdgpu_connector_ddc_get_modes(struct drm_connector *connector)
-- 
2.35.1



