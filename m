Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054693;
	b=m1t5H4qni2x87U2+DKmty3Kc/98CzoRBEsLbZW5gfu2+gL5scZCQVT37kfdzpaRC0RbF
	 cgnBQnpx08nYPYnPNzzABIHfrRk2EaRS76Q7a8ZX+yQehzomZoDQBy/iNW2dhlj9Vo0MR
	 qqnFypCpq9ocEqco5Uv0icQSM8RGot9JBEm//zoYpf34OTzgKg3K+snXmqacqtXv+2OKN
	 nhhk/kyT9RnzHod/OaqiwSuIPqUkxhtz1aCoYZPQ/YIIgihK1gpdgGev4ZuKA+JmzGzna
	 43TB30QNHjyMrjpc12/pB3xVlKZBNmQqthMVq4tf2+29infglPI840Ygzd0k+bjfYPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eieTU7iVroWcyCM8QypPxIjU9flyPO/p5a/JAuegHz0=;
	b=cyg/tMEFjSV1Mda3ZGc3e0kLk2q2/cku1o5UjhfCTeIdjWr2D3SMB3JuSHCqcptQm/gA
	 qCBpYkycwXW9qbK0NvZLVDSXPfzNoZZF4LNyw0m7ov40vEuQ73M3LGx/T7Ds6SRb6+n/a
	 Ab9/zACo6dxKifmO1LiHeJaPF9YyD8ZA9K72YXOa6TZ29k7Hy9fvg7gADXPudYfrf8tEh
	 Roa25bpLD+UMdfWXfKwO/y4qFfyUFpemQo63jpHqCXpC+PLEv3uE4Lix1HoXbBUGI6ZiG
	 CzDyhO+oDnfWj66xn8pgx6uj2r+sAIclqQmJqQ94fWEurP9VQb05y//XnGjKxrmrXYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNBiWbJC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD16606A320;
	Thu, 19 Nov 2026 02:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aNBiWbJC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8671F000C4;
	Thu, 19 Nov 2026 02:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054692;
	bh=eieTU7iVroWcyCM8QypPxIjU9flyPO/p5a/JAuegHz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNBiWbJCWE6i17vmgTT9GnNqIsKq4VbuI8nKmoh4eK4zvgM8DcekWoO3bJon4PfBX
	 09VK6QGfBLn3TbnACRN65YMyyeC5h0iDh0LlPlOMFS1nbVMJxdKpit/Tn3LW9X2SHE
	 c793decspwDmPppihh+I+nHF1Qop179IoXP98iio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1364/2214] staging: rtl8723bs: remove return from void function
Date: Wed, 18 Nov 2026 15:50:40 +0100
Message-ID: <20261118150106.022161081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 279347be77c40..e3308f3953217 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -1149,7 +1149,7 @@ void rtw_suspend_common(struct adapter *padapter)
 
 	if ((!padapter->bup) || (padapter->bDriverStopped) || (padapter->bSurpriseRemoved)) {
 		pdbgpriv->dbg_suspend_error_cnt++;
-		goto exit;
+		return;
 	}
 	rtw_ps_deny(padapter, PS_DENY_SUSPEND);
 
@@ -1171,10 +1171,6 @@ void rtw_suspend_common(struct adapter *padapter)
 
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



