Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB6911703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A31C433C7;
	Mon, 21 Aug 2023 19:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647967;
	bh=CqNuPus9+gVCCk0O+FoUgPGdf/AyYELMA7YysG9k8io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQX5isYeqsleT02+UP6BV3vvsdMIeYk3KnLk0ibOnT214C8UkfJSgAgEItCSRpf1Y
	 fUHHeO1gH+gMabk2EoldnfW/AwkeysD/3B/3F5NUhmUpdEGqIsHRDdQDOC6I8t1UT0
	 UJUko7rcBqmD+l2r8aDitaTGINeN8fPVpOSM+108=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 190/194] drm/amdgpu: keep irq count in amdgpu_irq_disable_all
Date: Mon, 21 Aug 2023 21:42:49 +0200
Message-ID: <20230821194131.058955552@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

commit 8ffd6f0442674f32c048ec8dffdbc5ec67829beb upstream.

This can clean up all irq warnings because of unbalanced
amdgpu_irq_get/put when unplugging/unbinding device, and leave
irq count decrease in each ip fini function.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -160,7 +160,6 @@ void amdgpu_irq_disable_all(struct amdgp
 				continue;
 
 			for (k = 0; k < src->num_types; ++k) {
-				atomic_set(&src->enabled_types[k], 0);
 				r = src->funcs->set(adev, src, k,
 						    AMDGPU_IRQ_STATE_DISABLE);
 				if (r)


