Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A0134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CA7C4339B;
	Mon, 12 Jun 2023 10:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567069;
	bh=GnL4xtEkzUVBYtrvSVlvpWCd/yY67muBPjOwCTmfZ1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coIemJoMF4PvP6oMn0aOQVBR1vIQ8AjmMRS6I0o+HVTsrNEcZ6Q9mprcSoLlV60cO
	 PJW/4zfkuIcRu6ZH7gpi8RWYQ6MjCSrXNj8C+wK7LNooHPL1OUs2SeNm/B2C/IScSp
	 P0gzBvloTCz6WAsnOE4eplRuqvpIplV7cInqaYas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kis <imre.kis@arm.com>,
	Balint Dobszay <balint.dobszay@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 138/160] firmware: arm_ffa: Set handle field to zero in memory descriptor
Date: Mon, 12 Jun 2023 12:27:50 +0200
Message-ID: <20230612101721.386941308@linuxfoundation.org>
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
index e234091386671..2109cd178ff70 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -424,6 +424,7 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		ep_mem_access->flag = 0;
 		ep_mem_access->reserved = 0;
 	}
+	mem_region->handle = 0;
 	mem_region->reserved_0 = 0;
 	mem_region->reserved_1 = 0;
 	mem_region->ep_count = args->nattrs;
-- 
2.39.2



