Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212090;
	b=zUAuR4tlkgkUYUDLFhkQ8IPQXeyaHAzAGFFgnguGt+h2PVP5c2zkLPgbTMVZjJm0uXQC
	 sjZ4AVd8ZbWcVFnQ5ws83Z+kqCo1JLYICfKNLVR79p2CS2MOJAIykh2jVI4SfW9FYek0a
	 gJdi8mNiKwi4Yf7tClDwdGC6cNYHXFLyL5nYLfeq4tW70m+Rf7uZKGur6NUHnkwe37bVF
	 a/JiYw4SQ3HskJFzDKtgX9/mRDvuduk5ZF9Si2IViBMiGQ3sBK23zcEAvMRB8468hJQtP
	 TmqlXIghq7COuJ5tiO34YBlDk65C9Davq7nM3q+h8MygrjoPFxu5IboEDIuaYq8EpXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D3BBhEdgJWz3jtY4Ri1joUZcHSPZce1bp6cBBKNF0WQ=;
	b=ymFphh08ARPctK7AbcgE0yPqTQOWzfblSSI8uJcNFSKC/eO6gcgZfo642CedsGTzzMq0
	 cVboOPXaGEelg2Ksl9Z7iE2+oNHqaWhQoEfE5zKeX2ETTZT14QGBM2FKB74OOlVvfIQql
	 BGa7iW2RweAraSE//WSkS0Ph37dltIY7ggtF272iTRre94WE9Fl7pBOXHUNiVvQaoxmrI
	 RUx4vJRHm4uwyMgaD/7sCIJK7U8/1m4OzC/Av2gHHfzFD7EmIXWIUU0PmCYZuV76RsQLP
	 3ExGR0aocgzzTiFZQubx74D9OtlDKJwGspc/+b/vXjkcVhx2GC18D/0zq+6lx0MWPYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAbEOi8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331F1606A31C;
	Wed, 28 Oct 2026 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAbEOi8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFB41F01825;
	Wed, 28 Oct 2026 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212089;
	bh=D3BBhEdgJWz3jtY4Ri1joUZcHSPZce1bp6cBBKNF0WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAbEOi8zdZLLtCK0ALumYhSun8KQ66FbpewVMWfwt5a0tGs5Sdz9lbOfbN3DIGVeh
	 T8hOsKKpCDuryHu4pWfAm2FP+uWmfzRJYBEJz6iopuI+erGVk/Y1q6qs/FTO5MigQ2
	 a8U20C21CWe27nytsBuClaAIFPL/zuwckaIhMd1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0034/1887] staging: rtl8723bs: fix spacing around operators
Date: Wed, 28 Oct 2026 17:35:30 +0100
Message-ID: <20261028170500.001770989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Vivek BalachandharTN <vivek.balachandhar@gmail.com>

[ Upstream commit 2038fe84b8bdf894b634f777096685e78e8f3774 ]

Fix several instances where operators lacked spaces around them.
This improves readability and brings the driver closer to kernel
coding-style guidelines. No functional change.

Signed-off-by: Vivek BalachandharTN <vivek.balachandhar@gmail.com>
Link: https://patch.msgid.link/20251205021417.2705864-3-vivek.balachandhar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For this stable dependency, retain only the spacing change to the IE
advance in rtw_restruct_wmm_ie(). This supplies the exact context needed
by target commit 28a289beaf226 ("staging: rtl8723bs: fix OOB read in
rtw_restruct_wmm_ie()"). Drop the unrelated operator-spacing hunks.

Keep the existing bounds-first WMM match condition from stable commit
4dd2d9cf563c5 (upstream a75281626fc8f); applying the older condition
would undo its out-of-bounds-read fix. No functional change.

Stable-dep-of: 28a289beaf22 ("staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index d7fdac14e73dc..0c8b1541f243e 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2025,7 +2025,7 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
-		i += (in_ie[i+1]+2); /*  to the next IE element */
+		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
 	return ielength;
-- 
2.53.0



