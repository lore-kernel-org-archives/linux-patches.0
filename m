Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208144;
	b=sotEYE8UQM8WPP5tJWiBK47EWPXqDUpqrcTBnJIChhk9Zd/kWG70pz3W9S0XATtZVJXd
	 w9F7wAriPf/K1C65QSRLvns2VpohVohwHy2YIB2vw97gZ+Y0GIiLDTCLATh22jtDc4rOM
	 L8J5Cq+xXPQpGro9Mnp2iQYZe/QU+82DHKA2f+wPlzi4CqxJLob9ZQbrRItLJVMdJvykU
	 8sjTDs2MSKi4sCQavx+wISpc6i/7WA0PBWyb0R2RNVnrk3xyZN8TFwpOqIei5ZKDJhIlr
	 JHS34Qym8bVnjhwp/hoHh0DcwnLwghfKsOpC+5Vy1Mrj53hdAa/C3/LsdpAYTqYFJPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vggXA15JGflXNIlkpyvguTS0T4L4lOlRZcqye1cyE5U=;
	b=4ahqzCLkyvwIlLUSEch+sbhXgNt6mX0V48zmbbqUA3tAomIK6iY1WiRLIVubdvWWIS8w
	 jiC2N01ii0EL+UYkZ4Kov3fOrl4MMV+6wvgLx/kmKs5Hk4ZD/oqs4Blx6iYRS2NMcMS7+
	 tOLu1tlPE3x9RzNVyxXMiZ8l2aQGja2zJz3KURPxJV3U+x8eHaSuIWdCm1ULF3SZ7g7gK
	 6Qp31yc6fLj0unYoBrOnHyZp8omydYzgcnvVjZZycoEZuNLDg07NUlFBWKNUH5YwLPwRA
	 CCF228K8NdblL3IKkQVR4fz2x8QoB9MdOSpG2SclBxwGV8tJt5+QOglyAAlQQhr/qfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8SLWBaY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C4D606A339;
	Wed, 28 Oct 2026 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8SLWBaY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC291F031E0;
	Wed, 28 Oct 2026 17:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208143;
	bh=vggXA15JGflXNIlkpyvguTS0T4L4lOlRZcqye1cyE5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8SLWBaYm0v1drn15isX9N911cDlN40Jkn5otbR6wtdbmy/ro7Hnxxd5b5b9Y5j48
	 jdFyBdKOuZrfqEUBSIoAcyynU0gCjnpFr4ENRVkrkp+YX6Z/p875L5i7W6+bLIYlNV
	 chGIBp/Y0RpxMTasV4U3qCnVRDYlmpRspnkGkT5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/516] staging: rtl8723bs: fix spacing around operators
Date: Wed, 28 Oct 2026 17:52:49 +0100
Message-ID: <20261028170003.935188763@linuxfoundation.org>
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
index 3517a5a4c492f..b08186a2af5fa 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2274,7 +2274,7 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
-		i += (in_ie[i+1]+2); /*  to the next IE element */
+		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
 	return ielength;
-- 
2.53.0



