Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1214279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FF4C433D6;
	Wed, 30 Nov 2022 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833548;
	bh=ROFODb8dEYach/u8m5pXA6xTJRd8jjideFXN7LF/duM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMXn4aB068wyecVv93Z/sRuxJUcpAn1zlE6bcSmBFgV1ugrhfqoAXm/BGoqGsRfcV
	 77fpRffc+2q73mm8qvK+JWY0noEnqSHQ5oMJJqbyGpopQpDPytvNyUkllWCyaFL5rd
	 9mF/Qn851ciJZqNWdLpiOQD5uqa2ZyT29AslN1Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/206] net: wwan: iosm: use ACPI_FREE() but not kfree() in ipc_pcie_read_bios_cfg()
Date: Wed, 30 Nov 2022 19:22:41 +0100
Message-Id: <20221130180535.816798810@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit e541dd7763fc34aec2f93f652a396cc2e7b92d8d ]

acpi_evaluate_dsm() should be coupled with ACPI_FREE() to free the ACPI
memory, because we need to track the allocation of acpi_object when
ACPI_DBG_TRACK_ALLOCATIONS enabled, so use ACPI_FREE() instead of kfree().

Fixes: d38a648d2d6c ("net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221118062447.2324881-1-bobo.shaobowang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 01df23835be0..8b4222b137d1 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -249,7 +249,7 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	if (object->integer.value == 3)
 		sleep_state = IPC_PCIE_D3L2;
 
-	kfree(object);
+	ACPI_FREE(object);
 
 default_ret:
 	return sleep_state;
-- 
2.35.1



