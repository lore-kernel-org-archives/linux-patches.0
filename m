Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67E9D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B27DC433D2;
	Mon, 12 Jun 2023 10:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566322;
	bh=uq0SVz5UqtJkl8ieMNLcZhzMswHJEEXgcxp9PenjSck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzzmLdDT7rsUgRGvIsJHjM4F/ZXC2Hgig0/Ok7dqGCvKhXYw+CzRthQ8MUA2svS/2
	 7yLCtANNPKkc30m+SHAV7VjLcmUhBSJkYqHTCSAFOQE4Weqa27Utz3ol2frKtFr80J
	 BXgURqm8NaFaJeFB6RuWnGs+xE3qwMGXplfy4Hww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kis <imre.kis@arm.com>,
	Balint Dobszay <balint.dobszay@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 80/91] firmware: arm_ffa: Set handle field to zero in memory descriptor
Date: Mon, 12 Jun 2023 12:27:09 +0200
Message-ID: <20230612101705.428434163@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Balint Dobszay <balint.dobszay@arm.com>

[ Upstream commit 3aa0519a4780f1b8e11966bd879d4a2934ba455f ]

As described in the commit 111a833dc5cb ("firmware: arm_ffa: Set
reserved/MBZ fields to zero in the memory descriptors") some fields in
the memory descriptor have to be zeroed explicitly. The handle field is
one of these, but it was left out from that change, fix this now.

Fixes: 111a833dc5cb ("firmware: arm_ffa: Set reserved/MBZ fields to zero in the memory descriptors")
Reported-by: Imre Kis <imre.kis@arm.com>
Signed-off-by: Balint Dobszay <balint.dobszay@arm.com>
Link: https://lore.kernel.org/r/20230601140749.93812-1-balint.dobszay@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f53d11eff65e0..e4fb0c1ae4869 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -454,6 +454,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		ep_mem_access->flag = 0;
 		ep_mem_access->reserved = 0;
 	}
+	mem_region->handle = 0;
 	mem_region->reserved_0 = 0;
 	mem_region->reserved_1 = 0;
 	mem_region->ep_count = args->nattrs;
-- 
2.39.2



