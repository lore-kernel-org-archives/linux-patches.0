Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C14F4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A83C433D2;
	Wed, 15 Mar 2023 12:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883821;
	bh=CBKuUt7ee39XOBhPZAz+aBCn5t2eTdY7hKuqXcrQxmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdgoJnzd0aPSp4oCeqJtYiGDPwLNIx+iYVssetIYFQL3DbZmqxpCL1zc84coWbBNf
	 zK/YCmyZofAe2BS+4kqgUb3xd1pd4tj5XoRKlB5lvLKbwzj9aUnPQBdy/AzrTpN/Rj
	 Qor1JjLoCh4TFBweUGquXniOui1yHTj8R5hSMjNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian Koenig <chriatian.koenig@amd.com>,
	Shashank Sharma <shashank.sharma@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/143] drm/amdgpu: fix return value check in kfd
Date: Wed, 15 Mar 2023 13:13:20 +0100
Message-Id: <20230315115743.961521783@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shashank Sharma <shashank.sharma@amd.com>

[ Upstream commit 20534dbcc7b7bfb447279cdcfb0d88ee3b779a18 ]

This patch fixes a return value check in kfd doorbell handling.
This function should return 0(error) only when the ida_simple_get
returns < 0(error), return > 0 is a success case.

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Fixes: 16f0013157bf ("drm/amdkfd: Allocate doorbells only when needed")
Acked-by: Christian Koenig <chriatian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index cd4e61bf04939..3ac599f74fea8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -280,7 +280,7 @@ phys_addr_t kfd_get_process_doorbells(struct kfd_process_device *pdd)
 	if (!pdd->doorbell_index) {
 		int r = kfd_alloc_process_doorbells(pdd->dev,
 						    &pdd->doorbell_index);
-		if (r)
+		if (r < 0)
 			return 0;
 	}
 
-- 
2.39.2



