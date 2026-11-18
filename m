Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047800;
	b=mnMKGVZNNduedeUOxK6lpWIs+SZJajI3eIxd6qhtk0TrqRqLDoYJ4adBVyU3SKELm/ei
	 6jt+KaRl50ld30rGb0a1NTeL4jVncZnJNWw17x60hn/mcNuAL7qWs7MyjV7EiBOzW+fSC
	 Prs4hHV9b90wnmVfouZarblVhY3dQiLEB6uIIAxFL8cUjzNgdZINbm0DtBVp4+VUkzaad
	 2dXRS1c4WM5ECzIp0rmbaIf7YMVEoBSuK1dhRirj/SCWbgqbMjMQTFQuYPGwNdCEFFsBk
	 PN+QqQg09sgoiVWQbOQ7KCxqdW7ZJUBcxKxIcR1baRWunNBJQrjrC4WFSH8lbChcLNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lHBge/179IP4Dz5xPMVYzRpLnJaaz6r9GJOR15lSyyk=;
	b=v8JvmAcH68HdAZVwp+MGotrSyc+lA7CzRrr8wDPJe5GPWNv4RauxxQCzK1+k+g3ZeZT0
	 UjNCf8OsrTdAb393q//kqL2lVErc4Nn3m8MGU6Zy7k0HGLfg2+S/GlsOKwBXx/qrc4nvV
	 xlR9H9NwQ0KZmiuwxoroSXdnEE4Tb/lNF4aWWuoCvmSA0oW2DBv9Ui+G1XJApwMKMePOZ
	 /5gl0f0VJWq3K3luoW7R2jVUI1dASwkkKJPapjSgMuNiTTZdAMWlAgrFMnO6V2iA9emKb
	 CJ9NFXolT32RF8vi1vWoDV88bS7/3uphJ/is7kOsvK9ENxgbe6+9YPlDBd0wfqGqjng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FB4es1uv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F979606A325;
	Thu, 19 Nov 2026 00:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FB4es1uv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9321F000C4;
	Thu, 19 Nov 2026 00:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047800;
	bh=lHBge/179IP4Dz5xPMVYzRpLnJaaz6r9GJOR15lSyyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FB4es1uv1av9ukvRxCz2glad03qOALQvVjhg5wX1SQo0RtCuN6od8R0EdZuPxx0a2
	 /BWwqGBtcw1NW27kgnlPzaUPP/IeiHyu+ZgHA5G0RIaaP8/AToAA2kMyE+jkNrFqsK
	 83PRuVxkOPJZfYqTeLdfQtgizA3Ke1Uls+Mbh1Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1766/2857] staging: rtl8723bs: remove return from void function
Date: Wed, 18 Nov 2026 15:46:40 +0100
Message-ID: <20261118150304.873098098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



