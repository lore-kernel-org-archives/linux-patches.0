Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFF6134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D22C433D2;
	Mon, 12 Jun 2023 10:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566795;
	bh=NFeO/azdVkm0NbDGauNI9Oor0uCFBZ6rERkDyb/E5TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thwMlNLUyOj9gZii1VFpNZ0s9nqf2kx+ITqStE7T3sjAzYUD2bm8liPhMoi98sKH8
	 J4a66xCebijViZOnKA31NimJSGQybqzQQEhWikCp0vlEH0dbEtxGAYPl/nLvX3CPzx
	 YQyuaa4zmrGfT63PWHyVyv0L7/8N6H8RPqt2/q0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Oded Gabbay <ogabbay@kernel.org>,
	dri-devel@lists.freedesktop.org,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Krystian Pradzynski <krystian.pradzynski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 035/160] accel/ivpu: ivpu_ipc needs GENERIC_ALLOCATOR
Date: Mon, 12 Jun 2023 12:26:07 +0200
Message-ID: <20230612101716.651546286@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 50d30040eb856ff6b0382b4d9dc332dc15597729 ]

Drivers that use the gen_pool*() family of functions should
select GENERIC_ALLOCATOR to prevent build errors like these:

ld: drivers/accel/ivpu/ivpu_ipc.o: in function `gen_pool_free':
include/linux/genalloc.h:172: undefined reference to `gen_pool_free_owner'
ld: drivers/accel/ivpu/ivpu_ipc.o: in function `gen_pool_alloc_algo':
include/linux/genalloc.h:138: undefined reference to `gen_pool_alloc_algo_owner'
ld: drivers/accel/ivpu/ivpu_ipc.o: in function `gen_pool_free':
include/linux/genalloc.h:172: undefined reference to `gen_pool_free_owner'
ld: drivers/accel/ivpu/ivpu_ipc.o: in function `ivpu_ipc_init':
drivers/accel/ivpu/ivpu_ipc.c:441: undefined reference to `devm_gen_pool_create'
ld: drivers/accel/ivpu/ivpu_ipc.o: in function `gen_pool_add_virt':
include/linux/genalloc.h:104: undefined reference to `gen_pool_add_owner'

Fixes: 5d7422cfb498 ("accel/ivpu: Add IPC driver and JSM messages")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/all/202305221206.1TaugDKP-lkp@intel.com/
Cc: Oded Gabbay <ogabbay@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Cc: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Cc: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Cc: Krystian Pradzynski <krystian.pradzynski@linux.intel.com>
Cc: Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230526044519.13441-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/ivpu/Kconfig b/drivers/accel/ivpu/Kconfig
index 9bdf168bf1d0e..1a4c4ed9d1136 100644
--- a/drivers/accel/ivpu/Kconfig
+++ b/drivers/accel/ivpu/Kconfig
@@ -7,6 +7,7 @@ config DRM_ACCEL_IVPU
 	depends on PCI && PCI_MSI
 	select FW_LOADER
 	select SHMEM
+	select GENERIC_ALLOCATOR
 	help
 	  Choose this option if you have a system that has an 14th generation Intel CPU
 	  or newer. VPU stands for Versatile Processing Unit and it's a CPU-integrated
-- 
2.39.2



