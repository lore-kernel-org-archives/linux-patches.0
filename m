Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF0B4EF137;
	Thu, 17 Sep 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667584; cv=none; b=C3ApHM1zOHNvYAEGFxAeVB67sFl/mjCzGcLEiGaD8OMy9PkArtvI/WXfYH46T1bJ8AD/bWeTEalLqHdyn0choJCUpFvrkt7p3J850qCdtSR7Gtm7Y1kzsNgeH1OrRF93H9bbDc3AaU1dtDFvxi3TxA8C1DqVnrzbVU0iOCdqkX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667584; c=relaxed/simple;
	bh=io2GZ4bGERERKhBId6D21tGN0wxC/VapvYm4HYh3zg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvFkHsne4iP8st4y7VbtEJi0Vs9bcHEUOM8vsv2DzMLRbaofNfWVZwl9fZngATshdAFtFgNPNbVUkLU7tXedUZNN+3nBYNbmnPYo9CBLp1Je5zxXNMifZPw82o3lm0hs8u4nZ9DO0c+AN5Ppsa86JGvhqu4WapVMhkJdzAs6z7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4B4N4OJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4B4N4OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20C11F000FF;
	Thu, 17 Sep 2026 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667583;
	bh=Ck3Aj9Vj2IA5MA9T62kkelC8Ai2f4GhEZ/ptZNO6Oc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4B4N4OJP972bNFTie1kB9Bj9EevGml0LcdULGev1LrkesfRpBH5k9xzJI0q0ajS+
	 SO+sMQTuv2yyBsPdhmpE3s9SzNaxrBf7nM1T2RFeA4PzeY9BYG20K5JIbh/JUGuS9Y
	 KQ9iiv41X23KJFzzJ766MjtWKyeW0BA89W6WYPss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0142/1102] netlabel: fix IPv6 unlabeled address add error handling
Date: Thu, 17 Sep 2026 16:01:25 +0100
Message-ID: <20260917151543.088212865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 56872b930feee7ae07b9720ca950dd9fa65596ee ]

netlbl_unlhsh_add_addr6() always returned zero after
netlbl_af6list_add(), masking failures such as duplicate
IPv6 static label entries.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20260522022910.398416-1-zhaochenguang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_unlabeled.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 6007cb000da67..c9684ddc2395d 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -295,7 +295,7 @@ static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 
 	if (ret_val != 0)
 		kfree(entry);
-	return 0;
+	return ret_val;
 }
 #endif /* IPv6 */
 
-- 
2.53.0



