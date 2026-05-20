Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5503EF0D7;
	Wed, 20 May 2026 17:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298557; cv=none; b=l0NHv7waNgqupxhNmeacaTB67oCOWVIMb3GhsM95S6k9y8fSKwlX9kQaZE/vFWL+Tnt8pZScM6UzCsgbiehy5u3cP5xkZCBdSpBai8qs3+0exhyKU+1bnlhH6oEVpkeA8ZvljihnnMmOZ3O65ADA5YsSlL4nmFtKyPbREO9Mukc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298557; c=relaxed/simple;
	bh=8Ap3PK1Z2xmWCy5QbFD+EUmABykXHOqjU8ZS6GXtoOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myi5GKWOpVZIe9tl0bpCx0At0fI5UDuufXfsI88bK2UDWWkUTIX20W9jkwvn+7B0wFLFu2Y9EoRS9cmT26YseTmfw1fZUIjjNGVd7jYM+re9wM1Z+BVXJNi/1vTx+u7Rq26+QxNwVg8vyZog92Ehctyf9vutN6kqpDheNMM4/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0u7TqpO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0u7TqpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1761F000E9;
	Wed, 20 May 2026 17:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298554;
	bh=3Kz3RBL5mrvY+cohhL7dq/a902HKe484Ih/0IxeCAjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0u7TqpOdG2ynjsxqrMxUiARszawTITl4+Ac+CvtukrnI0KQH2zfshr4PhvBmMzmE
	 PvPB2fn25641Pz+NErW6/P7dPeYH9rkelZGXaGbDbVQ7/sRpH1dGE8MIzBYMV1KdLZ
	 Vk/qU3sx90aGqFuYRtXiGDT7wOtQ79WAdTJ4VFYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Michals <tcmichals@yahoo.com>,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 456/957] remoteproc: xlnx: Fix sram property parsing
Date: Wed, 20 May 2026 18:15:39 +0200
Message-ID: <20260520162144.411785082@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Michals <tcmichals@yahoo.com>

[ Upstream commit d116bccf6f1c199b27c9ebdf07cc3cfe868f919c ]

As per sram bindings, "sram" property can be list of phandles.
When more than one sram phandles are listed, driver can't parse second
phandle's address correctly. Because, phandle index is passed to the API
instead of offset of address from reg property which is always 0 as per
sram.yaml bindings. Fix it by passing 0 to the API instead of sram
phandle index.

Fixes: 77fcdf51b8ca ("remoteproc: xlnx: Add sram support")
Signed-off-by: Tim Michals <tcmichals@yahoo.com>
Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Link: https://lore.kernel.org/r/20260204202730.3729984-1-tanmay.shah@amd.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/xlnx_r5_remoteproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/xlnx_r5_remoteproc.c b/drivers/remoteproc/xlnx_r5_remoteproc.c
index b30f660a1c553..5ef586fd37bca 100644
--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -1022,7 +1022,7 @@ static int zynqmp_r5_get_sram_banks(struct zynqmp_r5_core *r5_core)
 		}
 
 		/* Get SRAM device address */
-		ret = of_property_read_reg(sram_np, i, &abs_addr, &size);
+		ret = of_property_read_reg(sram_np, 0, &abs_addr, &size);
 		if (ret) {
 			dev_err(dev, "failed to get reg property\n");
 			goto fail_sram_get;
-- 
2.53.0



