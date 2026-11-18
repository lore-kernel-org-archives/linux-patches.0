Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043616;
	b=olQi6kEpcZYBz1lXhSRwZWbQs8/CmbCvXeqmyv7+uZmk92JmMRGcVnSxEPz0hUxwGxx+
	 Mo4/nI7Ppv/bGRxbcGWfJPk2yQA4NPSy4wX7niYjdEnIElGigrmrJdY3JfnW1olNLlNJY
	 lex6KSi059aMzi04njUS1a4ZjvEC5M0KlfHMHfswZCTkwa9ITAnqtW6yadLyhKxOBHBFY
	 Zz9M/SS45vYh3ng3FDxNzKZh7xaEb9UInPyG5qwYe0lcJy5qRtzlabWBZxhP2cQR4Y4aZ
	 5XqE7UxMEKzK0kkkkL6ukswPMiF9I1Yj5CHoqAg2RHQkrNeuceNGXboS2JgSN0lU88Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMc0INuKDTx0B4XhER7xvBHvlOCr653n1Qp9Sx2BOPA=;
	b=BIf9k6D9DkZIgnqRph+dwUrgVqD7wf8x3++q2vhQCn0Y7CLUaO/Qqb04AFWT6YFIAIx1
	 oAolWWiC5686OXBLDUhTPusrhY07oU6C4cwy02Y44NS6ZfSy9bT1CVUX7uLSIwm+FerRL
	 vHy+3j0RkdHpoMnvtqNxD7aIdMOgQFbSjkS3Vtf+MxTlhrckIrIEYLLhF1+ZRg+9wr2gD
	 C8UBTyGCafvAbfy5hjVW1WajYRopbDbisdmR2S/nm50Vy96YqMjiuqpcClu0JL56mqLv0
	 zDitJoNiAgFReAqMTIHtFOTq9lAEOHV3XUqqrnlVqSPEJr/y6LC0fCmKmmApu9VvNuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVuiSwyU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA9E606A334;
	Wed, 18 Nov 2026 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVuiSwyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42DB1F000CC;
	Wed, 18 Nov 2026 23:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043616;
	bh=bMc0INuKDTx0B4XhER7xvBHvlOCr653n1Qp9Sx2BOPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVuiSwyUYWAdT/nb7l+jP4wLoub78XBFvLEFmFYc40D8n0YG2oBUzJ6RczsIGHWWl
	 epXexvcaHzq6Xetc/g5zxaZiYlJr8Vp9H5D/tt4Vfj8+MGp8o9XlG9Iek7AG8zt4Lz
	 GgCd9+iJmUfm6pZSpWTkeNM0L0fIFaXZHZJAfuxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jenson Johnathon Reggentin <mail@jregg.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0272/2857] docs: block: fix dead http link in blk-mq.rst
Date: Wed, 18 Nov 2026 15:21:46 +0100
Message-ID: <20261118150211.223430723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jenson Johnathon Reggentin <mail@jregg.de>

[ Upstream commit b40a680ea4efe4ef2addada63e304a94d19500d1 ]

The current link http://kernel.dk/blk-mq.pdf leads to a 404 error page.
https://www.kernel.dk/blk-mq.pdf leads to the correct document.

v2 to add the missing www. prefix in the actual file change.

Signed-off-by: Jenson Johnathon Reggentin <mail@jregg.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20260819192422.42189-1-mail@jregg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/block/blk-mq.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/block/blk-mq.rst b/Documentation/block/blk-mq.rst
index 31f52f3269714..9a8b3899e5581 100644
--- a/Documentation/block/blk-mq.rst
+++ b/Documentation/block/blk-mq.rst
@@ -139,7 +139,7 @@ completed.
 Further reading
 ---------------
 
-- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <http://kernel.dk/blk-mq.pdf>`_
+- `Linux Block IO: Introducing Multi-queue SSD Access on Multi-core Systems <https://www.kernel.dk/blk-mq.pdf>`_
 
 - `NOOP scheduler <https://en.wikipedia.org/wiki/Noop_scheduler>`_
 
-- 
2.53.0



