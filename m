Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFB323507B;
	Tue, 31 Mar 2026 16:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975769; cv=none; b=lBVMqoLx8VDrY6k4aBaebQgXiORR6vAgHK/kz0iVBuJCztDgqqbsxDFRRQihZh1le1PiMeb7jGykXhN1mjXwNR2l4CRt9/J9sQbZ2j8xMNK2BmS/YDR7p68fNjiN1ykljqlozxOjpqfpHeFgqAIhGiqfU3gTVurEtCa0KNUunqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975769; c=relaxed/simple;
	bh=7Dq0Jv7kzY5EGDfU8j7joVsZejaSgVYyuDDuz0zqM/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gFAAAWm5kFffKkcsQ030vh3dsLqdTf6bG8m53fW2uMAKOmhHGXga/j0QgaT6mlokhnzHjWnI7Y3Y3LXEuVMflVAtUXaxii4yJbaDWPqz88jFi3hIpmGwystyORupKdYzW0IlDlJw0atTTqnwoydI0FbYmOTEP/h36c2GtWn772A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyGAzeaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyGAzeaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362AEC19423;
	Tue, 31 Mar 2026 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975769;
	bh=7Dq0Jv7kzY5EGDfU8j7joVsZejaSgVYyuDDuz0zqM/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyGAzeaQcWRcejFVMyvHLcBIptidRuifrVaVdBEPMnDqf+q5zXq75w8rfNguFvumM
	 BRxvKntnUwcgfHa18k95TOCcl0mJ6vwIWUuMy5MrSYA6NfPuTPEJvFQhwPtGzgyjR3
	 Z8cxfRp6wxq2eMGQQ9x6VB6i8gqO/tlUYodCEkDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Lubomir Rintel <lkundrak@v3.sk>,
	Randy Dunlap <rdunlap@infradead.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/244] platform/olpc: olpc-xo175-ec: Fix overflow error message to print inlen
Date: Tue, 31 Mar 2026 18:20:30 +0200
Message-ID: <20260331161744.638546198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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



