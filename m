Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F53E15C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39CDC433D7;
	Mon,  5 Dec 2022 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269406;
	bh=b1m1V5RS0L+Muu1KJ8OrBcOJBVRwBqk92CXQSl9/5Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUTX2c/iK9IFZp46jS0P/KLzz5aOfQdKuMNKa9BpPi07tGtcJsLaFFTeqjFSEpZyD
	 wUQ83wp9EvyCK9YhEqb4Rq/QI6qFjY6DIQqny+GWi0lpNf85kgMCxbhQrb98vt33AB
	 xINpsGpbEjRNQfBK3yV/EXmikEidTi753e4QcUbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Suarez <cssk@net-c.es>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/153] drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"
Date: Mon,  5 Dec 2022 20:10:12 +0100
Message-Id: <20221205190811.249345261@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
index 448ad5ade19a..fac43a9f553c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -329,7 +329,6 @@ static void amdgpu_connector_free_edid(struct drm_connector *connector)
 
 	kfree(amdgpu_connector->edid);
 	amdgpu_connector->edid = NULL;
-	drm_connector_update_edid_property(connector, NULL);
 }
 
 static int amdgpu_connector_ddc_get_modes(struct drm_connector *connector)
-- 
2.35.1



