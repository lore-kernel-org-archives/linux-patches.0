Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFC2415F10;
	Tue, 21 Jul 2026 22:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674676; cv=none; b=JwKDoq9du5WalI8f5uU6ADGClqLy6OSwb+0FXCdA/tGeJ6D5Dixy0175SfQzjUu3MItF1CBM05ehX8h4W2Dss3RAhJBcSRXgKSRJgVIncnUdOk27h9sNsA0MiZmBDKzbnEl9IeIJ6q86vItCzRtg666sDRPNKEfMYguUfkH2mpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674676; c=relaxed/simple;
	bh=fbZfa6NavpTkSvg+nBEYFHYFWaDwq413uHAMiz1LpLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shNr7OFapAy99ncoongwhpngulMeOFPbprZkgDz3Ftuvm+4gPgCSCIqCmPJ0DBPW6nAdY1rWBJcZUl9NZpramPo/rVPJLprXZOTmojOMKEGVUxsePQ3m2GQHJKKyqW1YHDtMsMsDjTRTJXbatVieKQcHuERhl4q4CqBixGodq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lb5Vft1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lb5Vft1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0BC1F000E9;
	Tue, 21 Jul 2026 22:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674674;
	bh=7+Z58eNagfg/9Gzn7sgxabAnn+0al9j6d4lu3DKhQYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lb5Vft1ZCMB3s0yuh5BNaIuEOvGCBqpPZynK/NhDuqX8uZhf0WKCCQQkc+wCeUAnK
	 uCqfAZiRs6pFlvvJCU5WKgOUUr+rLNs8lNkdfKGrq2NOc4X6AnZqopI7iiovVdkFH9
	 EDqIT0A9lTx6vrEWfDL8DYgva3Xlt1/PHI//3Wp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Aiuto <fabioaiuto83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 628/699] staging: rtl8723bs: remove DBG_871X log argument
Date: Tue, 21 Jul 2026 17:26:27 +0200
Message-ID: <20260721152409.912960659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit 42c3243ff23d119331a8ace011e0c18b222a1138 ]

This patch prepares the application of the semantic
patch aimed to remove all DBG_871X logs.

One occurrence of the DBG_871X macro has one
repeated argument, that's not even comma separated
value with the previous one nor a format string
parameter associated.

In normal conditions this worked, for the macro
is usually not expanded (the do nothing behaviour),
but if I try to apply the sempantic patch to remove
all macro occurrences, all macros call after that
abnormal declaration are left untouched (not removed).

Remove all of the DBG_871X logs as they currently
do nothing as they require the code to be modified by
hand in order to be turned on. This obviously has not happened
since the code was merged, so just remove them as they are unused.

Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/3473925ae9ee5a3bcd0ab86613dbce80b6d3f33f.1617802415.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ed51de4a86e1 ("staging: rtl8723bs: fix OOB read in update_beacon_info() IE loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -923,7 +923,7 @@ sint ap2sta_data_frame(
 			#ifdef DBG_RX_DROP_FRAME
 			DBG_871X("DBG_RX_DROP_FRAME %s BSSID ="MAC_FMT", mybssid ="MAC_FMT"\n",
 				__func__, MAC_ARG(pattrib->bssid), MAC_ARG(mybssid));
-			DBG_871X("this adapter = %d, buddy adapter = %d\n", adapter->adapter_type, adapter->pbuddystruct adapter->adapter_type);
+			DBG_871X("this adapter = %d, buddy adapter = %d\n", adapter->adapter_type, adapter->pbuddystruct);
 			#endif
 
 			if (!bmcast) {


