Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3B73BB67F;
	Sat, 17 Oct 2026 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258322; cv=none; b=ql74xQp9LeCv+BxfkoHK4msWtn73b6cwqp5wgpcTscp1vW/2Z5oKuXtN6RiyoL+ENNhWvDM33jWtHovLWCK+yO/em34KjyKk7s1pn915kTB0lTyEf64zq+OphCGhlMwPzzjeInZ0VMBPV9HcAx80usy3U47bTmTf0cGp3cKu3S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258322; c=relaxed/simple;
	bh=3DssE1W1brWV50SvVEHPfQ1JgdSB1JyBuyR3cBX1bc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kU7KsVVH2Jx6Sgj3HqROZwliPUJOoeR6rMP2oHxWcGfKf8SEfhOg5QPwqNNvWwWqRTHwdw0WoLP4pvJQjxssDU3acauS8yujCdmY47v+xaYeiuFvUX2+9IMMNTGQZ1m53jwOdm2XGX/Nuv4hVflbrB5zFxTMPTocr2Enmij/3Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyxUEEFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyxUEEFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594AE1F000C4;
	Sat, 17 Oct 2026 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258321;
	bh=RaBeQnCwHY8G7B8rrXpPRwFMVOEwoG8B4YibXghGcdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UyxUEEFQGTALfL5LlZIbq5nU6b++d3laUfqCA8MAZX5Fm2lo07ihpIboqFQkvPk8Q
	 89dw4aaQe8SMwUDXMytY0u4RH3dWER9n/Z1FLjywJCjUhCjeD3aZZ99exlp2tn+jYh
	 AhejHTLPGIUNDhV4PxOZLXmTDvmimfgwQbdIYOEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Michal Simek <michal.simek@amd.com>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0805/1674] mailbox: zynqmp-ipi: fix an Excess struct member kernel-doc warning
Date: Sat, 17 Oct 2026 17:51:17 +0200
Message-ID: <20261017160451.777260502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b3734a8291ad7fd61e5a51cc540e414bcfbdc0cf ]

kernel test robot reports 2 Excess struct member warnings:

zynqmp-ipi-mailbox.c:92: warning: Excess struct member 'irq' description in 'zynqmp_ipi_mbox'
zynqmp-ipi-mailbox.c:112: warning: Excess struct member 'ipi_mboxes' description in 'zynqmp_ipi_pdata'

The second one is a false positive that is caused by the
__counted_by() attribute. Kees has posted a patch for that, so just
fix the first one.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312150705.glrQ4ypv-lkp@intel.com/
Cc: linux-arm-kernel@lists.infradead.org
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 90f248ef2a1fc..c3953abe74b8e 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -81,7 +81,6 @@ struct zynqmp_ipi_mchan {
  * @remote_id:            remote IPI agent ID
  * @mbox:                 mailbox Controller
  * @mchans:               array for channels, tx channel and rx channel.
- * @irq:                  IPI agent interrupt ID
  */
 struct zynqmp_ipi_mbox {
 	struct zynqmp_ipi_pdata *pdata;
-- 
2.53.0



