Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334373815D8;
	Wed, 30 Sep 2026 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784240; cv=none; b=desqADjQ/Ndx1vdTFI5XnUDSiPVx7BpQV2MxuPHHl+/lb56mBgPnu5OTPUNcHqqCLE78snesYSaXgQS6d7jeBZY8rHIioDfEY/jbMDxSVsTC5yN+Iy6hM9PnMhNZzk1N91lndtZjkkl7DL3NIimCOgUfU674MeeuBk/OS0vIHz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784240; c=relaxed/simple;
	bh=vbVWZrA1yXFZI2DOS+mga+qdGLVYNtzdW4npvjtB8cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et9jBxHEuKMMoyuEyRaU3FZcSmn2R5jJr190pgSn/pum5LFyzpCy6THomtETM78BJIeR/rb8R1ebrXZEvTZzOVQCcXLT7Eb0vN5UY2U7G9twYJSzUMemmVIwm1YqXmuRozpDcXyAVieEAARPoz2mPeC72f6wHkUi090LtN0hKyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kF5dGDWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kF5dGDWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118771F00893;
	Wed, 30 Sep 2026 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784235;
	bh=smysiKcgjIREOYneW6XAm/AHAn4evpSebcDWDLAd4gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kF5dGDWvm87FnYyQXewqu+Lrxis4QatlAkCA8bppjOSkYuETprZ13021e4UuS2qQZ
	 GWPU5tsfCnZEpXhoaPmhyOMe7hvqPAYaAwiYsuUvdxBjlhxpWXknJWB3YZ47zTWhY+
	 tVD4sNY8NWiVP3AMnMbLigbJ2/Hv/pQL4ygYLiVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/982] netlabel: fix IPv6 unlabeled address add error handling
Date: Wed, 30 Sep 2026 17:13:41 +0200
Message-ID: <20260930152418.635396090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



