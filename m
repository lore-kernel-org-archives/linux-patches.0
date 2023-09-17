Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22706FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BC3C433C8;
	Sun, 17 Sep 2023 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980600;
	bh=rkGtkdCl5XhERT2Y/rhlof33Dfs9We53wkXc/S7L8TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmQvLAaPLmIyTPPtHFYXI9ZlDcz2eLrSHCJ01SzfGLjRM5B+IL1Hqu8FNg34gsjrX
	 3nfYYiKBKsE3gpUFabko/KPcNc3ZYhqGBm30MxbOg0BGI/8rFm/6iKBlbSgnsAD9kz
	 MAvoY/0Z6dS2vBSiGiRNAZhkmJLwOQDpoSGt8uuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 240/285] drm/amdkfd: Add missing gfx11 MQD manager callbacks
Date: Sun, 17 Sep 2023 21:14:00 +0200
Message-ID: <20230917191059.683637788@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

From: Jay Cornwall <jay.cornwall@amd.com>

commit e9dca969b2426702a73719ab9207e43c6d80b581 upstream.

mqd_stride function was introduced in commit 2f77b9a242a2
("drm/amdkfd: Update MQD management on multi XCC setup")
but not assigned for gfx11. Fixes a NULL dereference in debugfs.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.5.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -437,6 +437,7 @@ struct mqd_manager *mqd_manager_init_v11
 		mqd->is_occupied = kfd_is_occupied_cp;
 		mqd->mqd_size = sizeof(struct v11_compute_mqd);
 		mqd->get_wave_state = get_wave_state;
+		mqd->mqd_stride = kfd_mqd_stride;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd;
 #endif
@@ -452,6 +453,7 @@ struct mqd_manager *mqd_manager_init_v11
 		mqd->destroy_mqd = kfd_destroy_mqd_cp;
 		mqd->is_occupied = kfd_is_occupied_cp;
 		mqd->mqd_size = sizeof(struct v11_compute_mqd);
+		mqd->mqd_stride = kfd_mqd_stride;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd;
 #endif
@@ -481,6 +483,7 @@ struct mqd_manager *mqd_manager_init_v11
 		mqd->destroy_mqd = kfd_destroy_mqd_sdma;
 		mqd->is_occupied = kfd_is_occupied_sdma;
 		mqd->mqd_size = sizeof(struct v11_sdma_mqd);
+		mqd->mqd_stride = kfd_mqd_stride;
 #if defined(CONFIG_DEBUG_FS)
 		mqd->debugfs_show_mqd = debugfs_show_mqd_sdma;
 #endif


