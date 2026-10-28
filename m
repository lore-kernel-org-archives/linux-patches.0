Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208147;
	b=JuxFJXdSyqqxKLciFNDNB7jgbFbRV9fuIXVYBS5c1PCbi3NuJF3Ssg+n9MqEnCll8WHG
	 A4CbvIRO0RtLSTj3pF3XX6bElGedP2zfoL/O4BoyUBrVZOvCOQKn6kYsRv49qMK9gEMb0
	 YX/bEPEqRy3bJJLV3dd3IciEbSsNO4x4Bgk+QBzNlgLoizLKwD28GgkBm0s4OObxwgdWe
	 gKdtuTKohNYZlCUcB6480kBI+5e5+kXi+wmVHs/z9+vTc7NEtuIdWyqqk36p11MWwmXpU
	 QJk9ZMbbmxezbrtZzaJMqEbdB5Do4XXKyoQgSJXTcRv0CutkrqP8k2v6CTbuSsfRdSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hMO0jzFniSHVfrce2kLWuZNDPTZpbQ0RNzVJK8PjI60=;
	b=QE7KTv41UtrsRLh46SCGbIqca5fkGFNOMLxIN99upvLMbCAEwh7wQPTkYiA+G/s0LN5H
	 dlR7hqC+6SlREUWrFmLtKKN6WilfKdf+3B4SEGqKWxmpPvKRtJarkANIX2sekK/iTR/fq
	 v7jQc8YEPavfuK15mhr6lUwKXg/6ImhqXU2UHsHgFLWdFwVMpJ+a71Gy+Z85qdBj0aJ8g
	 ucfBC4g2xtaudpv9dgeTm9rQS3+M0OGRL/2dcc5Dc8x5LDfzFpMDczLMiGu13Pp3ctRCs
	 LGtSiR16b5Q86uKOHGr/LGzflZeq8IRnoiMcPAzL6J+u469oPzBZuKHckvHSEd+zAjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ORU/KHGS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7303606A320;
	Wed, 28 Oct 2026 17:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ORU/KHGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35941F031E0;
	Wed, 28 Oct 2026 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208146;
	bh=hMO0jzFniSHVfrce2kLWuZNDPTZpbQ0RNzVJK8PjI60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORU/KHGSTTsZZAEr2STpi+0XVLNVbuDtRoX8QwiS9psw+DJb4HsTHvGZOEcy7/y6f
	 ftcnz9Ne0TVLdYWKYf3NJeask0Y7g+6bkZvhozoRWDJHqKN8SZJTeZvKDjo47wmXjf
	 hSR7ZoDgshfNLj8RHJDTwdbigC/SbBg5+ua0xD58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/516] staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()
Date: Wed, 28 Oct 2026 17:52:50 +0100
Message-ID: <20261028170003.958539610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b08186a2af5fa..c7fab90550f01 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2274,6 +2274,9 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
+		if (i + 1 >= in_len)
+			break;
+
 		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
-- 
2.53.0



