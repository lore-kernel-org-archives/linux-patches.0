Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039228;
	b=x6Z9QVZF6Imo7ibmZbATQxboAgPM5dEXx1OTZv3Gh40tgY/Wi3ZEnLL+ckNfHpGAI5R5
	 kQDT3kwJ26hDy3oft/gr1cvx6TdnQLPwJFVZr0IySvGlph4ph5ygyP5CazT7slcE20XeL
	 jC2cFKeK/TmKCLk9IVRc3M3U9amBqE47RqPPqkMceH4V0l7JOTeQs/JgQR6+O6nhzueRF
	 zLJkzoyS8YlPEnkFT2Fhl4FoKtLn8L5fePZrD9/Gb7L7BVOtpf5x62aFJC/qPd0120emd
	 5PfsSaDh8rAt+KNLIZdOHi55CNIKyTFFyKtxW4wiDT15Vb31eTfjBbVCkVYfZMvuZxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xvSTV2XWpYohB+KJAJx0Bc2nv1kIAE3JdODXhvdQjgI=;
	b=lOAM55d1NtdL9qyRUvCzwlrjlwME4Y2J5mCUy+yrK7Sp60KT1fHT8nhd1auWN6YMSfG0
	 Smk8lEXqzylium22mvMIINK0dKYlWw6/l1IPVyqjiYH7HdvBUQN8GYwSwz4uB3QiQIF6x
	 H78qyKID1JRHtLclY+NXcRa70RODL1EQ50RPqsCUyu5svdcmxNNUXKCiFz0zKrXOthZK9
	 3Fn5VdMLy6xjXatmv0k5cqMAt8BS0SEY6HPfpHNSrZ9lnQAsfcpjks1iicyRI6Q15SHpp
	 zsCHCNRRSQ91XQduUuDZy7GH/wxamG9f8JGp1oA4E0VXS9mMN3hhb2QyfT4bncLQpDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqMV9ZYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49413606A320;
	Wed, 18 Nov 2026 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqMV9ZYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45861F000C5;
	Wed, 18 Nov 2026 22:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039228;
	bh=xvSTV2XWpYohB+KJAJx0Bc2nv1kIAE3JdODXhvdQjgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqMV9ZYPU2D7i0syKsTZmiedwetVkTeiXE5ShUjqW4KH4cDgn3VZZ3oQ2swkJOK2S
	 auLS7gzHYThZHoZhltCgkLt2daxYuumyIebp23IrF0k7Scfpmj+2X/M6/dTx4tbsVU
	 ml4mFU24PoWVv3Mh4UgVNxa8fju4jxRxh3y5b2Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2025/3318] staging: rtl8723bs: remove return from void function
Date: Wed, 18 Nov 2026 15:44:07 +0100
Message-ID: <20261118150422.791659163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 68bba3c0e757a..6a44fb1b8593e 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -1145,7 +1145,7 @@ void rtw_suspend_common(struct adapter *padapter)
 
 	if ((!padapter->bup) || (padapter->bDriverStopped) || (padapter->bSurpriseRemoved)) {
 		pdbgpriv->dbg_suspend_error_cnt++;
-		goto exit;
+		return;
 	}
 	rtw_ps_deny(padapter, PS_DENY_SUSPEND);
 
@@ -1167,10 +1167,6 @@ void rtw_suspend_common(struct adapter *padapter)
 
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



