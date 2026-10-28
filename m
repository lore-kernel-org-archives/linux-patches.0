Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214484;
	b=OF5K/rUGNRbp0rYCJU3U2bvLnGwG0M/qxgnMwPJ/Zk7jy2O7dLCg2+OeFB75y1NmzLDZ
	 Qb9xBqoWoR8q3CJMMlW6LBBvGHUrCX1AyfdRGtT3o5FbR8Tx83SnYyigR1jcyDU/TJcN/
	 g8kQAy/UjjIuQF+zYLdnfTeKnHsgX6yFNLnfozVRTfZOzSmPbNj/dlPOJ60KsQoLhl0je
	 4ziVPuCoQUrK/C8L9a37pus08ZzedC//o3ykqImJlzluWvrY2ZPOL0CdCVJymjzyrTDG8
	 p10QttnUP64grVgmzQrG9+/1tFXItveRXPZD3GYlcTKrl8gs3C9MfHaMlaO6YwBT2OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=457d66qNmdVAInAs2FNohzR01zs1dKtl5+My1G7Y60o=;
	b=tCQF6Jo5MWgG3+Jpjo9A7PUPNpQNAtqQe04hkMXSWqyfMQ5TxxcrBxnd+TdGu4TiD+Id
	 ZOYmlzwCHQXXRph8LrZqQFNDXIHLNH17IzlkhjIjtbHzTZeox/6I3CADgsl4tD/lpoHJi
	 1AwzkT38Lz9o4tSnmqm74RbCjptC+CYAD3oeIeayS8+WYGuvFJpxw3NRwhWBz+2jFuoKX
	 ZDz006eGu3aFX8QvhF6ziokBxatud94g/34U97Y9/GO06CMncWU6UXLdJUry1WfKEwe1N
	 SY66kx8anLyjeE9Tbp+Mk0L9vQbvMJXtqYcf3sUX16t/k933FyyLSJPPQy7J5I+RHqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIkU7h+z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E13E606B7EF;
	Wed, 28 Oct 2026 19:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIkU7h+z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013161F01828;
	Wed, 28 Oct 2026 19:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214484;
	bh=457d66qNmdVAInAs2FNohzR01zs1dKtl5+My1G7Y60o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIkU7h+zWgPFrMmSuFo+MH0OcTd/AB470WsKFomHF+ykrlK4nf+a8QNA8axF2N+uy
	 vown03cPuAS3wnEXfm5p7hSVRiRnRpz6uLEXQWzMzgrll/iIQqRhd1xN1aDYZNOf62
	 zg1BIsmFViAEFJUhS184Q9gfbLXsWtAhxfBKg9Kw=
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
Subject: [PATCH 6.1 0875/1887] mailbox: zynqmp-ipi: fix an Excess struct member kernel-doc warning
Date: Wed, 28 Oct 2026 17:49:31 +0100
Message-ID: <20261028170519.330161861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



