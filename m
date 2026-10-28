Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212093;
	b=TUR7npU3ooVPUOM3daM8QA/K+pL293hW6vCONqRmbTumLxtW+RuheXGtwUHXKrnN7Q8O
	 lX39UAzlKf/+Bg6msBHnoGIEX7TAMkPdfzv2ncBZy0Thi/NbEQrXePez4Uaeu/re5pX0D
	 HMS2O+xjl5m/rRbOgoxiGNv9sWiredzrej0y7+coZkDvyz9YNv6Cllj3kWe92U+2N6l7j
	 jQpLEMNw3VoVsQwqKTugckqzXCPlXXxFmURcSOHOYfRpiyQM5XEG1iBQs9paRgACQV1hc
	 8RKzx/egmuE7B5E8RsjaHGPjD+eU+Ia6zbYgwqNFkNRuGlwcubINfNNmAKJwzTc9pVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+aCr0SoZapYPHRMYZzfLtRtacCbpu8dDQO1i39v8SY=;
	b=ypRXRhW4AHUGfH50wkneHu/1NvjvZ+EHyJZCeREJ4bBulNN0k+TyZefT6TJoMNqGzDwM
	 qDocaYiH7bq/j5iTowBGHbovM6dSJnjEuNq7R3aoNPLi8gyUzK/LBE6S3gz/UCchyF/pk
	 lUY3P8w52gu83ZhXdz09W9dy8v0n3urODHKm26ivrmeXcF8IEn5POYuNb00PyrWMwSHg/
	 nSMtHYMECDi2OYcQZkcbIQCTwzRu1vTb0mVL5i+as23enJShqiyKY8uoyc0h3jYivinkL
	 HbBjRXJikq5X1FBC0D+Toh7smtSe/FgX23mfv2B6dQ+kILfvso86ipLqo3K0QKL5tLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTpo8QuN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF11A606A31A;
	Wed, 28 Oct 2026 18:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTpo8QuN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA371F01825;
	Wed, 28 Oct 2026 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212092;
	bh=x+aCr0SoZapYPHRMYZzfLtRtacCbpu8dDQO1i39v8SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTpo8QuNqa5QVLGykxug42qqArnJRU1p+yT7l3YwqjSgyACm7bkDijd0tBP8lypIJ
	 Be0nV46zvOl3O7Y1m8o9GCLUy6KC+3KVHwODjFxGviGy/x0kzNgbJH2d6GIAG2aeOV
	 u+/rgDzoi0sevIEsYOo5Q0Dz3sAFko23Q6sPUmKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0035/1887] staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()
Date: Wed, 28 Oct 2026 17:35:31 +0100
Message-ID: <20261028170500.023934666@linuxfoundation.org>
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
index 0c8b1541f243e..258972f6de3fa 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2025,6 +2025,9 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
+		if (i + 1 >= in_len)
+			break;
+
 		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
-- 
2.53.0



