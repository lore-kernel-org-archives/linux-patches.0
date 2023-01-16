Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB5233EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75473C433D2;
	Mon, 16 Jan 2023 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885023;
	bh=cMUV+0rexTPjeMjaEKnfHP+cJEkFgXqd2FS4IWcfO0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6C+FQ4wO/5mFGv8Q7c4RzRHLTZIZdod+Fa5JjKoqKzJB4x+q6z+UA1xZXEsThUdv
	 aPXNT65N9TYDXyku/93m7+EtTvl+TbPcYadxa/ovOSbOAOe/HMiehNN/wlk7AWKDZ8
	 YvBFjy//31eV4qgS/plrFecxDeO6OfVIBN2dgIIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/86] scsi: mpi3mr: Refer CONFIG_SCSI_MPI3MR in Makefile
Date: Mon, 16 Jan 2023 16:51:20 +0100
Message-Id: <20230116154748.986348913@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit f0a43ba6c66cc0688e2748d986a1459fdd3442ef ]

When Kconfig item CONFIG_SCSI_MPI3MR was introduced for mpi3mr driver, the
Makefile of the driver was not modified to refer the Kconfig item.

As a result, mpi3mr.ko is built regardless of the Kconfig item value y or
m. Also, if 'make localmodconfig' can not find the Kconfig item in the
Makefile, then it does not generate CONFIG_SCSI_MPI3MR=m even when
mpi3mr.ko is loaded on the system.

Refer to the Kconfig item to avoid the issues.

Fixes: c4f7ac64616e ("scsi: mpi3mr: Add mpi30 Rev-R headers and Kconfig")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20221207023659.2411785-1-shinichiro.kawasaki@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
index 7c2063e04c81..7ebca0ba538d 100644
--- a/drivers/scsi/mpi3mr/Makefile
+++ b/drivers/scsi/mpi3mr/Makefile
@@ -1,4 +1,4 @@
 # mpi3mr makefile
-obj-m += mpi3mr.o
+obj-$(CONFIG_SCSI_MPI3MR) += mpi3mr.o
 mpi3mr-y +=  mpi3mr_os.o     \
 		mpi3mr_fw.o \
-- 
2.35.1



