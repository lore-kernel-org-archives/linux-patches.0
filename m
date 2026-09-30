Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3641C51B16D;
	Wed, 30 Sep 2026 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790760; cv=none; b=s90Cw+XSRyExIV5jAeUK0Nta3QVRfbwDGcShNAocSNRwREyBFAzRpmRPDAayplr0rUqv4PXlwepNZMVVVmx0nbf7cCU6NUb78/1kzWuNt0usjDae6N2yo3sV16SnOJb03wG18LAGnQl/TREGLPo7iVKEgF29aJ1JtJcsCHDurRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790760; c=relaxed/simple;
	bh=R3ybNG73v9oRcTAJHFVr/Mh5QLIymSOOrpED0LFu+iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8jzjNIHBKekJvglH6j3cof+FvLSTyG1bT2fMltVIm21VoxrZg356pwLVb6ffShvMwNe2cnsSmCAXRWEbTu0LS7/GynSyhw3q1g6zVH5yeIh+8pzpnUQ1v929JdKjruJo+Fc3EVZieczsVE7mt3ZuA8UFwJ7E1GcUvdTTv9szOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlFVPzkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlFVPzkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F3D1F000FF;
	Wed, 30 Sep 2026 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790759;
	bh=wvFgeZP7Ok4cHfR8bdLQhOoIgf2mifdX8+r0g3waMJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlFVPzkY09I/36/vnHYZWS/VBFF9Hf4w1lkaTLalglM9jXxRLWdt7jZqCIigXFQ4L
	 FrS/AugYmQsWWG3VzhBJuA1uNLRawP7rXrlKO7PI0punesX1w4ebOqOu/syPErDVDn
	 SHpeykrNQws5dqJUmvUHtL0lZAi/ejkFkn5oavNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/752] netlabel: fix IPv6 unlabeled address add error handling
Date: Wed, 30 Sep 2026 17:18:53 +0200
Message-ID: <20260930152359.521566128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c4b91ce446df..f84bb8da1904a 100644
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



