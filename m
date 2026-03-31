Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE242D73AD;
	Tue, 31 Mar 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976461; cv=none; b=fi7Gwkxwv3p0MBPJ3K10NI6EMXI10F4QxVpb6Gmqk9q8bTYj0F10bdmqpuRowrIK0xJ5xf7xE3hm3Cp5vNNnYiCey8yyF8L/5gLQzEO4vp3i/nS+5IzgC1boJ9ZhBY/1K42r1MQMx9Pj9q5e8DY3ZRARTukBV30NYx7oAY8gw6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976461; c=relaxed/simple;
	bh=fSgOWKpvljbrfLBu50YiU7RDOO828yILsr0VfchxCYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grpyIvv/5J0NhcCBdgDfKlUy0DlCnFvn801uYNbUYotlQE5QClSc6zMwfX+IICxm9amnei6EyTi/enin0r5zW22w8C0MRscSQjy7fmD+VJGxEJU5Eo/VwoX3GCkxQHb0Lq4+pDRbNlgH1blUWLpxY2Cyauo5OUjNtyRfxSt5gQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuQHeDYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuQHeDYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3083EC19423;
	Tue, 31 Mar 2026 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976461;
	bh=fSgOWKpvljbrfLBu50YiU7RDOO828yILsr0VfchxCYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuQHeDYuN1FWI/JqGhm3LTKk3MSZ03Ma9M4P+H+sOJnabelvjQX2QP7B27JhtAlgp
	 QoGUeNFO4BFPivFl4qykbQZLGIAHtH7qyi85tLZUDMSY8VNkKbAaAIzrkEs3zcRqFI
	 BejDtMkMe6GiXQGDqVMxdZMZtu7NOfdvx2SbnLYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Lubomir Rintel <lkundrak@v3.sk>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/309] platform/olpc: olpc-xo175-ec: Fix overflow error message to print inlen
Date: Tue, 31 Mar 2026 18:20:05 +0200
Message-ID: <20260331161757.242176029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 2061f7b042f88d372cca79615f8425f3564c0b40 ]

The command length check validates inlen (> 5), but the error message
incorrectly printed resp_len. Print inlen so the log reflects the
actual command length.

Fixes: 0c3d931b3ab9e ("Platform: OLPC: Add XO-1.75 EC driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Acked-by: Lubomir Rintel <lkundrak@v3.sk>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260310130138.700687-1-alok.a.tiwari@oracle.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-xo175-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-xo175-ec.c b/drivers/platform/olpc/olpc-xo175-ec.c
index fa7b3bda688a6..bee271a4fda1a 100644
--- a/drivers/platform/olpc/olpc-xo175-ec.c
+++ b/drivers/platform/olpc/olpc-xo175-ec.c
@@ -482,7 +482,7 @@ static int olpc_xo175_ec_cmd(u8 cmd, u8 *inbuf, size_t inlen, u8 *resp,
 	dev_dbg(dev, "CMD %x, %zd bytes expected\n", cmd, resp_len);
 
 	if (inlen > 5) {
-		dev_err(dev, "command len %zd too big!\n", resp_len);
+		dev_err(dev, "command len %zd too big!\n", inlen);
 		return -EOVERFLOW;
 	}
 
-- 
2.51.0



