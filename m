Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAE81C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32165C433D2;
	Mon, 20 Mar 2023 15:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325213;
	bh=qxMJbuTffKRO/gwxIhhTMKwdCZG9qWZx7vkthIRAxaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkui+Y3rNBn3I4jOPBIbgAHuQSwvVp4rRup4RNJy3UhfbaAWN2qw7+3FXq6zkslsM
	 6NOZVZm5cIR2aaS/Oh0/CjA3u327hHDaHAhh1YiijDL2awUzoohWAWcZvhkWXVozYH
	 zflFSTm9CYqJC3nFUzeTQQcYrHQF0ub/GbnTaaCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 017/211] scsi: mpi3mr: Fix throttle_groups memory leak
Date: Mon, 20 Mar 2023 15:52:32 +0100
Message-Id: <20230320145514.029517029@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit f305a7b6ca21a665e8d0cf70b5936991a298c93c ]

Add a missing kfree().

Fixes: f10af057325c ("scsi: mpi3mr: Resource Based Metering")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230302234336.25456-2-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 758f7ca9e0ee8..9c716d92c2564 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4357,6 +4357,9 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		mrioc->pel_seqnum_virt = NULL;
 	}
 
+	kfree(mrioc->throttle_groups);
+	mrioc->throttle_groups = NULL;
+
 	kfree(mrioc->logdata_buf);
 	mrioc->logdata_buf = NULL;
 
-- 
2.39.2



