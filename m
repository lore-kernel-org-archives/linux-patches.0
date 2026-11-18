Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028979;
	b=Y7FiHlFmdmAIZIUkGYahHy6tZ1qkZftoUOe14ZMiNN2v9xOn+QxnVEF4uvsj82J3rP9V
	 JFpq8R75b9LM2kFtXTgJgz2joP5H38tQ8970rMM4qsoyM5QUbltJI4T3xiLBer1CZGgQN
	 ZXfWdzQVzingNQK+nC+R6VXyK2guRcwRzvGeI8FjXyZC33z2tCDNujFSJwwGAq/sqahGN
	 MdsqyyTS3DXL3Im0BzYLb1j6i5L8bDlqvk1NG85oHSOgimdGjkXTsBZxGFG/XXgjKmZdl
	 I7bsskqMyRt1pCjXBZUfx4zULEMS/gOitTJctt/48D4/BN9d4VdYU7DbSwf05E10Mzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P1C4oqkoO8ApZLDeNjJwHP8V24g5Hp3h+v+p2eL12AU=;
	b=OUfY2ozR5pQcivuZOF0drRNCWX17YjkA1z8EHITulB3PyLAQ140k0VzJGJX9nugECrKd
	 Yen7FGgLVgCiG5XTow13/X4hQyNNFVTfsxSad8t7voXYg/SAsVcA+zwFLML82Tdl2H5jK
	 3m6qhk/93CSSM0iQLYPI/U+w8fcw8cAji9gW2NTuPKYrDHn1R/SO4lZWtQPqoWrMAGr+/
	 iEQBoIJW7hhGyVFLyr8HYnLLrpIVbu6b6Bc/0lS/oK2nBar+GUcCJwM1r5sD/Tco1LhKm
	 Dd6t95cK5B0RlCIQES161ruh35lkyY64zQY5LVccSYd1TykW1V4bU54WF9mQAa3+o7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PELlTKdn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528BC606A33A;
	Wed, 18 Nov 2026 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PELlTKdn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC2F1F000C5;
	Wed, 18 Nov 2026 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028979;
	bh=P1C4oqkoO8ApZLDeNjJwHP8V24g5Hp3h+v+p2eL12AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PELlTKdnm067YvwcHKqI5jamSIoQKCKi2Vj9n/9DkzrBjkhpKx3yeRHoAcACO5Xzu
	 HVXj5tnOfBGlGDwOebv+c3TkA6O4Nsk2vAwItkPw6/dMW9kfWbDI3arrFqVtXPZggs
	 WXthzSxU0K39SpBB4oGkHSKPl/Dw9fesyuDHiQwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0187/1756] staging: rtl8723bs: remove return from void function
Date: Wed, 18 Nov 2026 15:38:34 +0100
Message-ID: <20261118150015.851044675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Straube <straube.linux@gmail.com>

[ Upstream commit 9279204d37cce549f40cdc677b86405e8628212c ]

Remove exit label and return statement from a void function.
After the exit label no cleanup is done, so it is safe to remove it
and return early in the only place where the label is used.
This simplifies the code and clears a checkpatch warning.

WARNING: void function return statements are not generally useful

Signed-off-by: Michael Straube <straube.linux@gmail.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250615123758.41869-1-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: baa84b1bb164 ("staging: rtl8723bs: disable SDIO function on block size failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/os_dep/os_intfs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
index fc9b9c5efb50e..ea3a5e0d196da 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -1144,7 +1144,7 @@ void rtw_suspend_common(struct adapter *padapter)
 
 	if ((!padapter->bup) || (padapter->bDriverStopped) || (padapter->bSurpriseRemoved)) {
 		pdbgpriv->dbg_suspend_error_cnt++;
-		goto exit;
+		return;
 	}
 	rtw_ps_deny(padapter, PS_DENY_SUSPEND);
 
@@ -1166,10 +1166,6 @@ void rtw_suspend_common(struct adapter *padapter)
 
 	netdev_dbg(padapter->pnetdev, "rtw suspend success in %d ms\n",
 		   jiffies_to_msecs(jiffies - start_time));
-
-exit:
-
-	return;
 }
 
 static int rtw_resume_process_normal(struct adapter *padapter)
-- 
2.53.0



