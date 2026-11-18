Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051160;
	b=dObdOkQeYBBjtcIqkiLjHw1T7MTFuPmb/gQH+/Mdf9TMFwqYy/IMdVBUiGDRSo8c6iUX
	 /zjUDLmU8/xNK4EJpxzGWJ9cEGRffhPEL4o0vXMdkne0vT5ov5cWxM/9U8QflAVNoZs9O
	 jgs6mBt4TYqwI1l8uuwsYaCXDEeu8DUu4F9GoQJsSMzX9ppLJE1P6PJV487LfWbGCaflw
	 bCiU2vIQRuIibGZd0EeRHwz9qe4zpqT6bhGsn1meYKvf+Q/STWk91WmYrzNEZQ01MWGmm
	 dhzAJpBhb94YzZ8/yCkTJDjaGhFytARD73CPHhdluzYo2xMETT9cgsC7xVlRCHmgbZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JlJw5RLtwsb/JxCjKBQDaaty1otCWEqrbLnUNNxhcvo=;
	b=tFVOG071bApSrxRtM25o/qtb5zhpFMzLpGfK30aqGz3rjWqUNL8DMJGKYbjyRVA727Br
	 HI7TouVz9SUz6IDKJI08yBZ2Hm3Q7v24iaRaeWJgWHgzA1BKKR0b9irqAxkn84ox5/67h
	 nuB/72CSI36CEgeBV8PpBE9TG4j42J7u/BFUh3W2jy1fIg7doPHUOzvPSTIrsj/VKXon6
	 GiQDzl29yWvif6I8J4CM1NZQZy/G9Xrjuy3E4W2NdZ2UTJP+Qh9Gy5q72dJaHhgP0srY7
	 /V9hiZKH0E8jgz+wH0uaT+5ryJOSN4B/ugBcIdFyhSJXKZaJXijedeYvn8Zm4BrmorA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbZVgGfS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E867606A320;
	Thu, 19 Nov 2026 01:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbZVgGfS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB991F000C5;
	Thu, 19 Nov 2026 01:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051160;
	bh=JlJw5RLtwsb/JxCjKBQDaaty1otCWEqrbLnUNNxhcvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbZVgGfSdl7fVwbGm1cly0hWS9Ztq9MPDIZbTcZ8P7MhD0J7DVFWAH3F6R1ZjxB8k
	 T5icp2+vHwL2aVm1buKYgS89Yj0ntILAq4irye8dKcGJB+aA2oOpv4OF43CBIbRbvl
	 dThzgk9b4CSWdnkkjCDgH+xUW8BM5k3OerOYA7CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0110/2214] driver core: attribute_container: Unwind device_add() on attr failure
Date: Wed, 18 Nov 2026 15:29:46 +0100
Message-ID: <20261118150014.309702502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8cfe7ad274bb42c4653b645267410d4a3a23db98 ]

attribute_container_add_class_device() first calls device_add() and then
creates the container attributes. If attribute_container_add_attrs() fails,
the helper returns the error with the class device still registered.

Callers use an error from this helper as a failed add and do not call
device_del() on that path. Undo the successful device_add() before
returning the attribute creation error.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/attribute_container.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 01ef796c2055a..aa93a0756e16a 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -455,7 +455,12 @@ attribute_container_add_class_device(struct device *classdev)
 
 	if (error)
 		return error;
-	return attribute_container_add_attrs(classdev);
+
+	error = attribute_container_add_attrs(classdev);
+	if (error)
+		device_del(classdev);
+
+	return error;
 }
 
 /**
-- 
2.53.0



