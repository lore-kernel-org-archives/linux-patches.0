Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0D32DE702;
	Sat, 12 Sep 2026 10:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207599; cv=none; b=sdztwy58yqVspW3Cr6lvrgCoE7fvuhqUI/2qxEtfPuWOigOn68NqTUbIt/NH5zV1rvw1QUlY0dvw23WGF7mdkhqhag6aLqAzafvNCbFmKSBKjh0vhV8ywbpp7k0kMP/NLvD4jGmrAiNffNFp/3jJCzA3bZocSQuCyb3iGbPluW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207599; c=relaxed/simple;
	bh=aYWOBtKGiPIWp5EMN5yNvZofEJVA+fOcOAIlBhZWMbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl7BG/tXjSef6YTxGqbXoh4UNhuK9LOwiHbVYvmvhmK6n1Y4FqrrzCZoB7rPYn3CtKiw2G16Y/fQvkDGt6k9E/alScbOlnSBRPtR1fbPjDiAQrqOee0xRLqchL9lqWkbrC5Jqbt/U6XMmbH7iCdszOCOLSUl4dUNd3IuohAr2JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oihBKmQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oihBKmQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2271F000FF;
	Sat, 12 Sep 2026 10:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207598;
	bh=TQlllyC45Cac6y7sT229vd7Roca4VY51WSt2YcOqxXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oihBKmQ1IepOx0fCtdmVt4LEbxNbPQJV+igqjALUYNOBqbYmJ2rFxdQX3X7s7OCro
	 T+MpTvmOyveHBgzvPjRrCsp2V6hpivh1mFj9MoK4nMhGWaXSPi6bFp+cg/zYjgvDU8
	 R+OlWUJhYjclEvMCQbRXrCxpn9DCEkAX4unOg9cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayana Mariyappa <nayana.mariyappa@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0444/1518] staging: rtl8723bs: expand multiple assignment into separate statements
Date: Sat, 12 Sep 2026 08:43:33 +0200
Message-ID: <20260912065633.494124778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nayana Mariyappa <nayana.mariyappa@gmail.com>

[ Upstream commit 5080a15d755be4ff72bc92df97475cf69ccf5e58 ]

Split multiple assignments in a single line into separate statements in
osdep_service.c to follow kernel coding style.
No functional change.

Signed-off-by: Nayana Mariyappa <nayana.mariyappa@gmail.com>
Link: https://patch.msgid.link/20260116120511.48272-5-nayana.mariyappa@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 41b8209376df ("staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/osdep_service.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/osdep_service.c b/drivers/staging/rtl8723bs/os_dep/osdep_service.c
index a00f9f0c85c5b..19b378b498091 100644
--- a/drivers/staging/rtl8723bs/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8723bs/os_dep/osdep_service.c
@@ -226,7 +226,8 @@ struct rtw_cbuf *rtw_cbuf_alloc(u32 size)
 	cbuf = rtw_malloc(struct_size(cbuf, bufs, size));
 
 	if (cbuf) {
-		cbuf->write = cbuf->read = 0;
+		cbuf->write = 0;
+		cbuf->read = 0;
 		cbuf->size = size;
 	}
 
-- 
2.53.0



