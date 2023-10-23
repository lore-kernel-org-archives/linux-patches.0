Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403CB14263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUgr4Kvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD959C433C7;
	Mon, 23 Oct 2023 11:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059319;
	bh=PQ+SVLY1BXc7vfU22Dw4WBgvWkAATLkowOmpJ/idphY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUgr4KvfQY2II3h0Cf1ILmflGUD6itW5SgW7Sgf3vD4bnOnQFcwzJBrhKgGmkmWs4
	 brc9Yq+GYnTp857nLvXmiXhgn6pgwikx6NjW0MCIBJJub1PGq7GzBVbCIrOlfqBvo8
	 nUBQ4r+w2v1lYki30yurEfSq75P/jq+V0JII0VUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 137/241] drm/amd/pm: add unique_id for gc 11.0.3
Date: Mon, 23 Oct 2023 12:55:23 +0200
Message-ID: <20231023104837.206555059@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 4953856f280b2b606089a72a93a1e9212a3adaca ]

add unique_id for gc 11.0.3

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index d68fe5474676b..7f7a476b6829c 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2077,6 +2077,7 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		case IP_VERSION(11, 0, 0):
 		case IP_VERSION(11, 0, 1):
 		case IP_VERSION(11, 0, 2):
+		case IP_VERSION(11, 0, 3):
 			*states = ATTR_STATE_SUPPORTED;
 			break;
 		default:
-- 
2.40.1



