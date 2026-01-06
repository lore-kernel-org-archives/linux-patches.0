Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF02F21773D;
	Tue,  6 Jan 2026 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720683; cv=none; b=O/M4d3YGjcOAFJaQwQBaZVQUOcCOF886d+qi/Ln1ziX3t+ynIdz8qYb1ujViSDNrCzdC6e2RbcEz+SghqcP1PWuWqgsM7xrFP5oDFkqx+hhgZbA0OCTDIFcVD6ZDlpo3TnJ3nLemVCMSUEh+12XW+E5oLlrt4ZCpHEzH0AR3kv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720683; c=relaxed/simple;
	bh=LT2bC3+w9+UAJRVAP85TczaiyQmMpvzINtXmDy7UO3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjX0o42FEZcKpnTGzRY/zJZ9abLvDP6A43P3USiy26FEfnMUuJfXc1EYZvlNPqMNY5VdW+G6NIaQ0HPPVPpvXNngJRT5wJIAFF8DMx0FddcJdCAKrHIfF93xSr+YraXa0jSTJI3NKZSIf4eJUB5zuwGdyUJHWoyQ6u4dvCspS2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFIsEXuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFIsEXuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC3BC116C6;
	Tue,  6 Jan 2026 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720682;
	bh=LT2bC3+w9+UAJRVAP85TczaiyQmMpvzINtXmDy7UO3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFIsEXuEiYUtVm8v+pM8J5wbL3GhhcLn1KVOibrpy0oLpxgQZPwLYwLK+iSrsV/xH
	 AIeOe5WJNMoUdHeOYkIGdujEbCPfGfLot5pBM8JT6XBF3t1w5THf5HO/OFadJieU7c
	 hR5yV/yBXwN3ETbndRYiQCaeBhpLk5TnpmrDsFr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/567] platform/x86: ibm_rtl: fix EBDA signature search pointer arithmetic
Date: Tue,  6 Jan 2026 18:01:31 +0100
Message-ID: <20260106170502.758071692@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



