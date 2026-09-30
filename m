Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB793DC87B;
	Wed, 30 Sep 2026 18:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794149; cv=none; b=fAcUP4zdVjKM6qvsnAwS8RUkzSTfHdTmaU3iMgI9r/lVuQKfR4skQITXLYTLPkZ7N/To7cJOsH4FmXp8OEbkjdsXAOjDHSGIQl90ftJ6Nt9CM2SZB/n8ZCAFucnWY9Qrk+meGMQCRvMG3lcrNkau9UXcmFh74NIbv2haNiDDtzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794149; c=relaxed/simple;
	bh=/YvmXWPi5F3Q3YNBNVxS+Pned4Ffh9lPBeiMFITgesk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXVdeZWVZ+K4W29hkx/wlTZoGMXOYnWYsHHigRclVMIJzcFCpfa8rUCNLd9l+bfz1bABnb0idMYL1ps9CKDUq93pa04tS8rZng27MJxeWjEd2YIqV8nXN1n6M/yA+Mwifq/ZF+DcVNjWCLyt3EokFD5kSm7ZZYTJV+ohqPHdxKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V78C9fvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V78C9fvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132F21F00898;
	Wed, 30 Sep 2026 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794148;
	bh=J7e8NtqCMgrB41jahIKmsR8rtSIb9vggl1sIymBMTPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V78C9fviIqtBkaV1X7Bfn7QAI3ekdDf++50j7NuMjchZKidJi9o6hGsooqwTCFUWv
	 fJtK5sjWWQy9OfzZt7AxdJms02SuTUWT/wrZtEr6uKCfJBkxZuSmXwj7T3cbzU1myw
	 k+DBKt1haY7a5/G6Wq7E15R04CusKtWTjJ2RSeMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0102/1193] netlabel: fix IPv6 unlabeled address add error handling
Date: Wed, 30 Sep 2026 17:13:06 +0200
Message-ID: <20260930152436.499541713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



