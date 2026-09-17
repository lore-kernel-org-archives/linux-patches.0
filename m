Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB9E4F68A5;
	Thu, 17 Sep 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663937; cv=none; b=GoZJxpGAeUTyWvtyCIqBOu3N/fsZ8zSB8D4ZKIHpayTfNxOCGG7lZxvVUHF0mdtMg/V3hU8RSZ3nt1LeehQha2mxgydkMrczGprj6qqf29vrMH6+OlENPd7GugR7IvuE6ySLY3SLmYI0vMRDlQR+K3hwawhkhenAdf3F5XZEkts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663937; c=relaxed/simple;
	bh=KtsyC5oTuqeuJGvXNvm9cvkGF802/hAt4DtDwYxpvVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFkRPmFHVcHY8f7wvKRB6g0zJFW0TSL5wKzBKOodHfX2vkoruksH/KAwgJBD7M6QDbK4YbSBC4j3YVxglmmXnL7uawLp7Wx9/bfX2P6DydfHHRYZVtpBvRhY5jZDVHd2PlD40m4gh2buPGOHlL5jlg8Kc2ir8q4IGX8qc+GlWpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAdlsWPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAdlsWPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11ACC1F000FF;
	Thu, 17 Sep 2026 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663936;
	bh=AqFlc3E+7vL+PJEoI6QhSNYwpBqHNO+HctxRWJ8HXHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAdlsWPMB8EC8iKdOjXVjwmILxRV+rG7Ij9IPymozQwajZoYFXNZeawLmvvhMDErZ
	 cML5tJde+YSUK6okJoEzVAbfY7KcSwA85+b+y7jJX335V5nPsMIWJMKPj7CgPxbj9A
	 uQ2pOwx+aCHCfiJgYVN9aUzuBd3ef9znctCyouw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0203/1250] netlabel: fix IPv6 unlabeled address add error handling
Date: Thu, 17 Sep 2026 15:59:58 +0100
Message-ID: <20260917151557.621603267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2237a5261dd2a..0dfbb63d513ce 100644
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



