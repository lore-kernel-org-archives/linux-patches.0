Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205DD1AB6FC;
	Mon, 14 Oct 2024 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918850; cv=none; b=rFoYmBJI+RJpHSuf2aO5d7HBH/UzXezZB3L27I0AIPgBRe064p2xihMy4IcQIK1mcoMt/KXJHYr0KVOwNyId+JfAlr/f/xKUZx2TiMhoiVUpQTUb/9JmoQibvrb+J7zQOYsGkDNVtp0WESWu/PuIjU4OQzjIPsJhujjOlRX04pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918850; c=relaxed/simple;
	bh=BR5dclqdxoawdGaSVjs8/YORZudM60Qe3G7gmizOPs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPpCtshuNBwn2xiNRWX+6RulQQ//Df86+6F8usqYTPsYPtr4zkHf+ozLK8SZKY/44iMLrPLMo36FwVWZN6wXG+vU9ULLYxfDHUAkHpoBDXpVe+Zv1nNpQvEtY20k1ADY3GrpoQupptsfLUqKQ1KGSJR/+rAgX90sy20cXoRGdUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiPRQ5IE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiPRQ5IE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096B7C4CEC3;
	Mon, 14 Oct 2024 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918849;
	bh=BR5dclqdxoawdGaSVjs8/YORZudM60Qe3G7gmizOPs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiPRQ5IEDZUL9y+WwjjKYUJeOD03KdXzIdQzArMVRU/j25Voco+cXg1fbocm1Y43B
	 GuosoJ32dzSwAp50ZUqv93+spOLXi1o92U+vE/iEx0uriRx7956lOUzgaSETHpDlaN
	 rm2xxAugzzNkaUrkPUQScOo8ASNWLX9qeiMbunvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 441/798] bnxt_en: Extend maximum length of version string by 1 byte
Date: Mon, 14 Oct 2024 16:16:35 +0200
Message-ID: <20241014141235.296750001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit ffff7ee843c351ce71d6e0d52f0f20bea35e18c9 ]

This corrects an out-by-one error in the maximum length of the package
version string. The size argument of snprintf includes space for the
trailing '\0' byte, so there is no need to allow extra space for it by
reducing the value of the size argument by 1.

Found by inspection.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20240813-bnxt-str-v2-1-872050a157e7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7260b4671ecca..799adba0034a4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2980,7 +2980,7 @@ static void bnxt_get_pkgver(struct net_device *dev)
 
 	if (!bnxt_get_pkginfo(dev, buf, sizeof(buf))) {
 		len = strlen(bp->fw_ver_str);
-		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len - 1,
+		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len,
 			 "/pkg %s", buf);
 	}
 }
-- 
2.43.0



