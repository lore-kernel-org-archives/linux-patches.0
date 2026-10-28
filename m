Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210406;
	b=l0GcH15cn4HAgjKdBAQkQQ0M2qk5He2LMD1/fgKU0nwOK1OT7HwWZKh5gEBl3g9nouqR
	 FuKYICq5z+ywPsZ8KNlzlJS8N4uo8DzPOdG1JOFfK6wXj+bUM5DrmEzxozxsUx91hT6ML
	 MnU3c9ypYdmsMqKmjrcd8WgGb5lroCKOk3t2hRedc8EMqDKbBRaf7HXRqhZNCs3eTgmln
	 20N6kI2DqsDoAXUEE4UIN1Osse/HRoTvNXcSIMuj7XGBj4AcF5M7DmBlhZM4J23nlxn4h
	 bEaRs8b9t+7F5JZPmpUbzCmUu4cJz4pzJUCbR1OpD6ZSS+uRsv//Y0XZM/bkwL/4ChA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=22nEYknbc9OenSOb60zjLPQYLnPbBrlLBLPhRNmCenY=;
	b=r3/pHFSlgqzO8t3qfMBoDEyOrtcTdgrnv8jxz78Ke0cYjv3RPT21Tq3kvS2yHoAdCMN+
	 tB32rOT//mIrd3gnglliHdB64XpSAZhq2TJIerhTbFSn3ez4ISuDIW5dg5XSo1GB/K7sw
	 42l4ShEwGhLbE08Dc37t0z8e22swuLClKWaKJv35TEJwQ1wM+zmiIr2+HtNJsnxF3vvA0
	 jZxKmi45lesnZAiag+V8j0bNMf9VM51KPbNU3L6b1ixNvfB7XaRPTuEAh+pbbX68m4d2a
	 FjS3tj00WWpUJvr4Qk2vVCbACMrdl13ihPuKAy1b9Plc4IoozfH9eF78gKrSapjbT1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0i8yBhev;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA79606A325;
	Wed, 28 Oct 2026 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0i8yBhev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7081F01825;
	Wed, 28 Oct 2026 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210406;
	bh=22nEYknbc9OenSOb60zjLPQYLnPbBrlLBLPhRNmCenY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0i8yBhevBQeOMEezsyou+kxK7Jx2C/gMkJ+vCjv6xtiANumO2EaveqdacvreUs5TP
	 iuKfdvpGc8cZLqvSBwuXo3yNf0YeyF7VVUeUL8N8CGu2nWGOJAqFP2hlfuTo73dxBN
	 nIonO/tDDYe0RssvNc6x0T+RRJhJat0nKoVOYrXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek BalachandharTN <vivek.balachandhar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/571] staging: rtl8723bs: fix spacing around operators
Date: Wed, 28 Oct 2026 17:52:43 +0100
Message-ID: <20261028170008.406617492@linuxfoundation.org>
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
index 6604fe7b378af..1f97583a6536d 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2023,7 +2023,7 @@ int rtw_restruct_wmm_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie, uint in_
 			break;
 		}
 
-		i += (in_ie[i+1]+2); /*  to the next IE element */
+		i += (in_ie[i + 1] + 2); /*  to the next IE element */
 	}
 
 	return ielength;
-- 
2.53.0



