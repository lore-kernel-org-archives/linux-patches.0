Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDD613A26F;
	Tue, 27 Feb 2024 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043085; cv=none; b=Rur8Jj3wbym9dRto9VO/jQapc6wiqzJpoep37appLty6BSR59Bd/lhTDWrjitte2DZN+4Gr5oOCN/XCU1YMShN7sHE3CsuqIH2tBm2Nw8H5sD6klpvkkbDBMBVBUGkWEe98KGjMY6tbDyd/4H2u061u3Ckw1l1xnQug/sv/w1ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043085; c=relaxed/simple;
	bh=wLeM+CGlfPiV6Cm9Xjie6Ii/HgOt6dvKsdVeQAT+0+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7erFOL+Z5aeBQnyN0U+KaHmeCayJmljwFhBzWI21liV633MihoxJ1jLE8/zTHSt+DyJtB6ggGDdaF4seZuo+g9NI/ow6jPYlRkx677lPR2oh25MTfL0+T/sb4UY929VXPVcpll00dyeREi0iatVlFyyyVqEIvuvzGOYx8kCOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVannpw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVannpw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8EDC433C7;
	Tue, 27 Feb 2024 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043085;
	bh=wLeM+CGlfPiV6Cm9Xjie6Ii/HgOt6dvKsdVeQAT+0+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVannpw6b1dvrcHQJdz17pTJZ2U9tr3GixXuDVC5nidXLvyxJysMvhbmybuyR5yE7
	 Q5j0GZhzwcsG9iXljX1I2RTVkAqtodCfiuAHVIAt+NN31q9J5M/CzurO1NQ9qzBTKB
	 spTx5hA0lscth2JC8IcC05fSwD+IXJDF1fbYylPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/245] tls: rx: drop pointless else after goto
Date: Tue, 27 Feb 2024 14:26:57 +0100
Message-ID: <20240227131622.628878021@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c8285c596b5f4..92eab4a7a80b5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1784,10 +1784,9 @@ int tls_sw_recvmsg(struct sock *sk,
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



