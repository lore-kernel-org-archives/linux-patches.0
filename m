Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A65D35975;
	Tue,  6 Jan 2026 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721652; cv=none; b=NZQ45wkyppsgI8C4hJQaWLnOe2ng6+nPsY86YRjPZvGxTMqfpTOaeqdDsdAYzoahVQW/j2Tn5Mlgb0DSK1FMP5vhj1oBFDiJ7AsmwW7BAUdge6C50psGHIJXwqlLd1/+0uOiLX4sr1YrvuDpW3mXWxmpFCHCf8G8w+NQSDWQhik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721652; c=relaxed/simple;
	bh=+X7wGytDnV/d6ObMeP6BUi0VD/PZO10sIUoyFoS95g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AY+7N7YWSACPr1x3FtAdVkQJodX2/kyetUF/6tobQ6GUq0FaymW3bo8sGjmEHvY+Hx16hNcs8EvbXB36OsMYFgHkj+yOzgAnIdeeAMXBWPsxtuROHCSFevydcFv1hhNAynpnOv+b+6O81CX1xaFZBHYzkduZL9MqUdcFZcbur4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zYVyRen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zYVyRen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90256C116C6;
	Tue,  6 Jan 2026 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721652;
	bh=+X7wGytDnV/d6ObMeP6BUi0VD/PZO10sIUoyFoS95g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zYVyRen6gcvbP90l2Rw1sEbreBsEGeAUunGFRTYFbTp6SojLUE+5ezbBcIrYTyWE
	 i8N/V3tFHU5n6bhv9EnCq6ZrzFbqBDgncpd05lBr2p6zY9ugS0rE9MARY0eiDmcMLf
	 RzN4puHk38fDVG1MTGLcxXyb0GeBUuycWtOG0DJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/312] platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic
Date: Tue,  6 Jan 2026 18:01:46 +0100
Message-ID: <20260106170549.018509370@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 15dd100349b8526cbdf2de0ce3e72e700eb6c208 ]

The ibm_rtl_init() function searches for the signature but has a pointer
arithmetic error. The loop counter suggests searching at 4-byte intervals
but the implementation only advances by 1 byte per iteration.

Fix by properly advancing the pointer by sizeof(unsigned int) bytes
each iteration.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 35f0ce032b0f ("IBM Real-Time "SMI Free" mode driver -v7")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB78812D887A92DE3802D0D06EAFA9A@SYBPR01MB7881.ausprd01.prod.outlook.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ibm_rtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 231b37909801..139956168cf9 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -273,7 +273,7 @@ static int __init ibm_rtl_init(void) {
 	/* search for the _RTL_ signature at the start of the table */
 	for (i = 0 ; i < ebda_size/sizeof(unsigned int); i++) {
 		struct ibm_rtl_table __iomem * tmp;
-		tmp = (struct ibm_rtl_table __iomem *) (ebda_map+i);
+		tmp = (struct ibm_rtl_table __iomem *) (ebda_map + i*sizeof(unsigned int));
 		if ((readq(&tmp->signature) & RTL_MASK) == RTL_SIGNATURE) {
 			phys_addr_t addr;
 			unsigned int plen;
-- 
2.51.0



