Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D491DDC26;
	Tue,  3 Dec 2024 15:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241027; cv=none; b=EkCxt+J40Dy6maFQJAMFLq4HWw6aAuFIfEQbQeEOhHcHeuo8xLZ2rzgg53upPfGVHnU6PzcOe0oiuTIBqsdGI78sIgp61jh1Wkg6niYFSK1FmgAidu7V4FRZP+i0blaUGd2Y+SZS4ZNMB5O5u1WPBxi9mcKxNv+rBqeoAXoM4pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241027; c=relaxed/simple;
	bh=ns86m1wj9DL9HTZ9Ar5ygHJlO7uakSEZu7IiE+Bgk/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfBmFyFxlz1WQIT4RhKYEy4VAK49WGVkZf3shRRMlc+lomr+Z3G1s8DFx4/x0rqXNBh8LF/gHI5LpEOjYwrVAWtkSndJ1JW8FMHRFcGH9nQhxFCKJW8kY9itaGm0rvwoVmY9fhW39Nsqc8xuzriggUpbxTMmWuudkdb8lIVA5HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUAPF4F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUAPF4F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2D9C4CECF;
	Tue,  3 Dec 2024 15:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241027;
	bh=ns86m1wj9DL9HTZ9Ar5ygHJlO7uakSEZu7IiE+Bgk/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUAPF4F/vt3v+DNWFZry4tVqsH5LUeu9cytg2B6/HRJtXcHUjbWgCVS/EQ4LIutI7
	 /A7JV8G4YAZsnd4TslC8wOKDqE3yv53A+wCqY9bdiCG9FbM6zSAd52oPUA9HQaSfc+
	 0R1aaMLjmjStTVCghb4n1cNgqJ0rCOKnEqCcUQ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/826] wifi: rtw89: coex: check NULL return of kmalloc in btc_fw_set_monreg()
Date: Tue,  3 Dec 2024 15:40:29 +0100
Message-ID: <20241203144755.544185936@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 81df5ed446b448bdc327b7c7f0b50121fc1f4aa2 ]

kmalloc may fail, return value might be NULL and will cause
NULL pointer dereference. Add check NULL return of kmalloc in
btc_fw_set_monreg().

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Fixes: b952cb0a6e2d ("wifi: rtw89: coex: Add register monitor report v7 format")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/516a91f3997534f708af43c7592cbafdd53dd599.1730253508.git.xiaopei01@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 8c2db2a493c8b..8d54d71fcf539 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -2492,6 +2492,8 @@ static void btc_fw_set_monreg(struct rtw89_dev *rtwdev)
 	if (ver->fcxmreg == 7) {
 		sz = struct_size(v7, regs, n);
 		v7 = kmalloc(sz, GFP_KERNEL);
+		if (!v7)
+			return;
 		v7->type = RPT_EN_MREG;
 		v7->fver = ver->fcxmreg;
 		v7->len = n;
@@ -2506,6 +2508,8 @@ static void btc_fw_set_monreg(struct rtw89_dev *rtwdev)
 	} else {
 		sz = struct_size(v1, regs, n);
 		v1 = kmalloc(sz, GFP_KERNEL);
+		if (!v1)
+			return;
 		v1->fver = ver->fcxmreg;
 		v1->reg_num = n;
 		memcpy(v1->regs, chip->mon_reg, flex_array_size(v1, regs, n));
-- 
2.43.0



