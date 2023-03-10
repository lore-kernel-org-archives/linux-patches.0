Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5348481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7EAC4339B;
	Fri, 10 Mar 2023 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456856;
	bh=bm2WJ1roVdn9VBIkoVkk3KE1nkq8Xz3lJOvX4cwpvjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGEgmMMOFPxMR58NjXdbvd6sy98l8pLmsUZpTIH12Jo+xNDBwZxl1POhRR7cnYCoF
	 eSH58O49TZpRbKnhOwN83w3dj1JaUsybm8aMMZG+4aVSBLLb2FAnqgGdCs3w3Ibmnb
	 jc94wwLt+8zutiDCZndpNbqBKw5XPzU3t/fgK5rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 108/211] scsi: mpi3mr: Fix an issue found by KASAN
Date: Fri, 10 Mar 2023 14:38:08 +0100
Message-Id: <20230310133722.040765188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

[ Upstream commit ae7d45f5283d30274039b95d3e6d53d33c66e991 ]

Write only correct size (32 instead of 64 bytes).

Link: https://lore.kernel.org/r/20230213193752.6859-1-thenzl@redhat.com
Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3fc897336b5e0..3b61815979dab 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1280,7 +1280,7 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
 	if (mrioc->sas_hba.enclosure_handle) {
 		if (!(mpi3mr_cfg_get_enclosure_pg0(mrioc, &ioc_status,
-		    &encl_pg0, sizeof(dev_pg0),
+		    &encl_pg0, sizeof(encl_pg0),
 		    MPI3_ENCLOS_PGAD_FORM_HANDLE,
 		    mrioc->sas_hba.enclosure_handle)) &&
 		    (ioc_status == MPI3_IOCSTATUS_SUCCESS))
-- 
2.39.2



