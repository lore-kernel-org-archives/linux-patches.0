Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354CF347FD0;
	Tue, 16 Dec 2025 11:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886102; cv=none; b=RqQF6UYqUNZsqbiudyGqdWaY0FZQnOiTA5/2fPJ40DZjjry2uI2QKcCmT2krqSxcuGs3aB41en6mIQWXDvidv2U5T7N2qIq4uYVCP4gD/sGTA20+jshH7yta9Qm06MXLcxATsjjtO0bkFc5YybaWGWIPFE8LofJIs+tMI7XCTuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886102; c=relaxed/simple;
	bh=eHQEWqLf61PCfFmTMMmKjDbFnvkKtfaKLAMYoBrvqos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeJwR5eAz4BeKdb5RX6ZkZHSxmA/wsqEZC9578Xgwh7sCha5H8b3AqxdlZHCMB4H3netCvIaFLwVlHbxuigQ0FuhCBMQ9JdPaRokADpkopdfCUZ29YF7EJpsoe8GL+ITBLJz/qwEhcwOmmm8uqbdZ4ClDEeivYxXoocUOaTMOSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEzByTqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEzByTqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54D4C4CEF1;
	Tue, 16 Dec 2025 11:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886102;
	bh=eHQEWqLf61PCfFmTMMmKjDbFnvkKtfaKLAMYoBrvqos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEzByTqngCEeNRXMe/xWx8kTxW5ecdiiVagHO5NE5qexURlPuN4UCcjoNQ2mfcgsu
	 2BojhdxgL4Stq65au4yqVaYld1J7qNQEmR6siyDrxYS+2g78vhFYPiSG/4Cfve/gi3
	 LqL+aW6SZxPr3woxmTpUUb7lH/CdudzvS5CcWtz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 338/507] firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc
Date: Tue, 16 Dec 2025 12:12:59 +0100
Message-ID: <20251216111357.708032586@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 377441d53a2df61b105e823b335010cd4f1a6e56 ]

Fix this warning that was generated from "make htmldocs":

WARNING: drivers/firmware/stratix10-svc.c:58 struct member 'intel_svc_fcs'
not described in 'stratix10_svc'

Fixes: e6281c26674e ("firmware: stratix10-svc: Add support for FCS")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20251106145941.37920e97@canb.auug.org.au/
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://patch.msgid.link/20251114185815.358423-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 00f58e27f6de5..deee0e7be34bd 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -52,6 +52,7 @@ struct stratix10_svc_chan;
 /**
  * struct stratix10_svc - svc private data
  * @stratix10_svc_rsu: pointer to stratix10 RSU device
+ * @intel_svc_fcs: pointer to the FCS device
  */
 struct stratix10_svc {
 	struct platform_device *stratix10_svc_rsu;
-- 
2.51.0



