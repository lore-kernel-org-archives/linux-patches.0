Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210409;
	b=Pc6+ZIxQ/CWZ+Ykvh5pLr3vbia2a/IBZ/lic5ld/FZEmKW8EacAxfB6tszEFSWAGXKQk
	 h6vLwKhIlP5pFshf0LrXJYNAi8K6Vr2Uu6ZgIW7D9Pm6GU+IdGktpVJi2dRn07vSapdYS
	 iQSEuqQquaEWFY23dhrjFQrpQVPmcA3WMcJ5lEu5qdGhVSJWbJ4l90SaKPMKTWAzN87yF
	 dIZr0OW1mCqJ/i5C5UUhx2L+2/s6d3FPjfZGXZ6rJhXVmG5Eou9NP+qnIQuagXSkR4bnH
	 7z75mcBDp7BCcenhAaQKT4yfAWtRvUxXffD9x6MCWyD7z6cK7dA50SJc3gZ+QncIfUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jfYV3u/zuWqegdcYjN/OqXk8Ez/u0r5dnerdFeQzvGE=;
	b=J60zBoLUpguBnAtX1tJSk/uO9HY72LFXbXaSCOJiuIFN4hI+PkHLSNUtlDjxaKrKMNpg
	 uId5WWxvX7rYWBiNmuP3lRUvgs/hP1KzlpeGSsJhhfWS1oQt2DgQ91Wlq1Dtt7hZPgOMl
	 nny+1RNPv9qlJK4EjLKZLn2pPxNi7hGfd6dtmB8knmJEte4KroFNUEhCe9JnwhPpCkUd7
	 OBOekWueCXPyfEUJcBfGeFnqb9rcK+NSHGf3Y3Yp1JNlcV7zMXnVMk974L7N7tXSDb0+W
	 ka0C5zgfFT09Wja5d1iKBKh9SaUWXVh4MNOS8DRjrkIc6bFOotRJBrYUkrf82mtXDXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRzg1jvL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6AB606A31C;
	Wed, 28 Oct 2026 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eRzg1jvL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FA91F01825;
	Wed, 28 Oct 2026 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210409;
	bh=jfYV3u/zuWqegdcYjN/OqXk8Ez/u0r5dnerdFeQzvGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRzg1jvLHoyH3WRCX3RdjtCATjPt1b9peGBz1eeBoXWN0gu/Yz6RG+xWC84eSGXDC
	 qMN5yxoQvPHJ3KNH4S6tj0oXwu1yoTRP3dtiRZ2tx4t5qa/y7uzUXYNh1u+VJPe/LK
	 vMad1qk0Y5xHhKCSGm0LvebSxs+BybBiEVAtUmB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/571] staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()
Date: Wed, 28 Oct 2026 17:52:44 +0100
Message-ID: <20261028170008.430164913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 28a289beaf226b30b1e6e7d7b1a2946fe2d6e852 ]

rtw_restruct_wmm_ie() scans in_ie for a WMM IE with:

	while (i < in_len) {
		...
		if (i + 5 < in_len && in_ie[i] == 0xDD && ...) {
			...
			break;
		}
		i += (in_ie[i + 1] + 2); /* to the next IE element */
	}

When the "i + 5 < in_len" match check fails simply because i is
within 5 bytes of the end of the buffer (i.e. no WMM IE was found
near the tail of in_ie), execution falls through to
"i += (in_ie[i + 1] + 2)", which reads in_ie[i + 1]. If i == in_len
- 1 at that point, this is a 1-byte out-of-bounds read of an
attacker-influenced IE buffer built from association/scan data.

Commit a75281626fc8f ("staging: rtl8723bs: fix potential
out-of-bounds read in rtw_restruct_wmm_ie") added the "i + 5 <
in_len" guard to the match condition itself, but did not add an
equivalent guard before the fallthrough advance, so the same class
of OOB read remained reachable through the non-matching path.

Add an explicit bounds check before advancing to the next IE.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260728125456.32359-4-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 1f97583a6536d..29a83f1e1fbfb 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2023,6 +2023,9 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
+		if (i + 1 >= in_len)
+			break;
+
 		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
-- 
2.53.0



