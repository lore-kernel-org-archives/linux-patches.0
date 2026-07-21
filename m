Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD98382385;
	Tue, 21 Jul 2026 22:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674633; cv=none; b=szIAJMPXDrcjSx1vF+MTPfUtgkPu/ncsKF3v3W5+pl46rd0kMUUAZJWfW/7GFTeujT0YRGESKGFll0f/UO4XIRdzTMCvDplnsFZ7A/jxR+IFuk+EFBz9PgUOjbKAD1KelKqWRETNASNMwXUnFsnkB8uK9UbAg3tSY3b6LGtQd+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674633; c=relaxed/simple;
	bh=ZIgSPJOFdReL04ReKpJeizxfiNvcBqvbeKmxnv9dCFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFLO0e2fvqH2e/AIZyg/kq0lW2xdPBzIYlKqRkOmnUHari199lEQD63HRtLjhuPjDsi8lpFRaPgpaq+4knOqbcZefezV7STzlaV3x7bY54jWNyjTcOuwd5itKrLJ4e5OtpHJzJPiP7k8ldxih+vRBVhPw9SC7Jalgprypan1WsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejB9/J+H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejB9/J+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960E31F000E9;
	Tue, 21 Jul 2026 22:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674632;
	bh=JUZYSnqCBtZXJf/bUBKQDNWMpTmgzk+lVq+F598lUk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejB9/J+HCz2MeJjDaYZzPrEn0FReakBbWASWKxYXJVn73b9MLFlWjXM7jMFGy7ShR
	 msiH1hEt4m+pheLfBLYzwSprWSOoj3KhigSOJKTOoXNv3/M3BkM0NiQL+uLVDNaTdX
	 3yl/SNm0FYSfWIxm+7KKYtc/XuOge1oG6LOd+3CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Aiuto <fabioaiuto83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 614/699] staging: rtl8723bs: split too long line
Date: Tue, 21 Jul 2026 17:26:13 +0200
Message-ID: <20260721152409.596588378@linuxfoundation.org>
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

[ Upstream commit 98dc120895a9a669e35155ee03b98452723aba95 ]

fix the following post-commit hook checkpatch issue.

WARNING: line length of 103 exceeds 100 columns
30: FILE: drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:711:
+
receive_disconnect(padapter, pmlmeinfo->network.MacAddress, 0);

Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/4e87fb741205b9f314aec739921405a7ebef908a.1618480688.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1fc19d61f66 ("staging: rtl8723bs: fix WEP length underflow and OOB read in OnAuth()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -835,7 +835,8 @@ unsigned int OnBeacon(struct adapter *pa
 				ret = rtw_check_bcn_info(padapter, pframe, len);
 				if (!ret) {
 						DBG_871X_LEVEL(_drv_always_, "ap has changed, disconnect now\n ");
-						receive_disconnect(padapter, pmlmeinfo->network.MacAddress, 0);
+						receive_disconnect(padapter,
+								   pmlmeinfo->network.MacAddress, 0);
 						return _SUCCESS;
 				}
 				/* update WMM, ERP in the beacon */


