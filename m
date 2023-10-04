Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAC31F5F0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbiaQ04o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C64C433C7;
	Wed,  4 Oct 2023 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444273;
	bh=ZfZcfhXkw8Xd9lpa3h5BgYMpOjVFVTZIqoZikRt3EAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbiaQ04oasEve1XBHTc9C7Og86Di2cN1+NfAA5YnZS5ftScmC9fD+4S3h2r3q/Xjk
	 XHfhCei9d6UfIQ8ECVykGBaluuJpyBSTpLnYBkEA0mHpsWBmdAVomJrbSWROqMJ+4j
	 J0TriQiTBlH6pLFkET4peYAnE+EwzE5ugICqMeV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 192/321] drm/amdgpu: fallback to old RAS error message for aqua_vanjaram
Date: Wed,  4 Oct 2023 19:55:37 +0200
Message-ID: <20231004175238.118527553@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit ffd6bde302061aeee405ab364403af30210f0b99 ]

So driver doesn't generate incorrect message until
the new format is settled down for aqua_vanjaram

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 8aaa427f8c0f6..7d5019a884024 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1061,7 +1061,8 @@ int amdgpu_ras_query_error_status(struct amdgpu_device *adev,
 	info->ce_count = obj->err_data.ce_count;
 
 	if (err_data.ce_count) {
-		if (adev->smuio.funcs &&
+		if (!adev->aid_mask &&
+		    adev->smuio.funcs &&
 		    adev->smuio.funcs->get_socket_id &&
 		    adev->smuio.funcs->get_die_id) {
 			dev_info(adev->dev, "socket: %d, die: %d "
@@ -1081,7 +1082,8 @@ int amdgpu_ras_query_error_status(struct amdgpu_device *adev,
 		}
 	}
 	if (err_data.ue_count) {
-		if (adev->smuio.funcs &&
+		if (!adev->aid_mask &&
+		    adev->smuio.funcs &&
 		    adev->smuio.funcs->get_socket_id &&
 		    adev->smuio.funcs->get_die_id) {
 			dev_info(adev->dev, "socket: %d, die: %d "
-- 
2.40.1



