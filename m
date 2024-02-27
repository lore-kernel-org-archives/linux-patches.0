Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48EB1468E5;
	Tue, 27 Feb 2024 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044239; cv=none; b=P54aXNfiyRyNHBUT4/ii9Yd2AOQOi9lbOGPEGWmLmNfgQImO2q7d59M1BM+kH6XhsfKU04wkfxHAHkPrOjZlaL8asS838GXOnIdAxFDg2dxAmsgyH762QZyq0on50tv7dbQvZUaXVDJMKK949h6Q1HyUNIChpkSLAw+yh1TsZCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044239; c=relaxed/simple;
	bh=IfogYSfWi/qth8RRVHaBNnddOVxeRqmCV2Rh4RKADac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyrQtlCbsL3etHYanv1DZ2n5+ntzOi5/P1xuuvlrKuBdiNrpRQ0UYy57bcyQikPxuJJCMYDkHmyGlDs0BePd7pGy5F6Wi+HSTBkaEEa5ZE+tqxvaBivFjHzatImGp73igKJvE+m2jBsstM7euUA5/YR5mYi0Ta3Ha2xzu0HBIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNFzrpmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNFzrpmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE34FC433F1;
	Tue, 27 Feb 2024 14:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044239;
	bh=IfogYSfWi/qth8RRVHaBNnddOVxeRqmCV2Rh4RKADac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNFzrpmOThEF/PgBHNrjEGzqLnFuY7rFW6tvdt80MvTqcj2FxkWZaWRVLnhMtXHtx
	 WwC5arni4YnEeGg8WR5Co4RyrsIYTYw0q6s9AJmoD8LY7TKFcBEgXdKpxST3+f/QRs
	 NMOuYhXOUgRqkldkBrrqGpLVrph7QHX+u3jgupKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/122] tls: rx: drop pointless else after goto
Date: Tue, 27 Feb 2024 14:27:54 +0100
Message-ID: <20240227131602.401282001@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d5123edd10cf9d324fcb88e276bdc7375f3c5321 ]

Pointless else branch after goto makes the code harder to refactor
down the line.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fdfbaec5923d ("tls: stop recv() if initial process_rx_list gave us non-DATA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d11094a81ee6c..732f96b7bafc8 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1783,10 +1783,9 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (err < 0) {
 		tls_err_abort(sk, err);
 		goto end;
-	} else {
-		copied = err;
 	}
 
+	copied = err;
 	if (len <= copied)
 		goto end;
 
-- 
2.43.0



