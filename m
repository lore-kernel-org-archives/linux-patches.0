Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590209;
	b=L2c2Wy41hCtTfoX3Z+DoMy3a24C/m43r+o5yy93i71DiKU2doArd+e/lGv4jFWbxkCyj
	 2zP8rOGYh4mmjl4rcra5aAx+PvQNLiDKYTQOHi36RtjqZ8S5GcweIXgmyAqGF7QLofNfn
	 4b+gTax55CRQAjNywwr/0Dmo0ylAp/CUOXYKLyD0/NDRcSgWQsdIP9yKeJa7Aua8jatvR
	 pE/GVt5gYDN/4AgzTWhYdnwO2EXGr9stk12OroONJZJkU+8QvKk9mCE5VYksRzwLt5IQH
	 EXvOn0aGPragZKQ3SVoPa0YB8b+feGvBoCr/63o5IjkQo4wIJK56PuL/ymaxg9HvmOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGpCWz+GDGt/BMPC/W7Ijx4pMj2VYIhN+K9Bah2s4Pw=;
	b=fJhpxJW6jQUlkVzEqLEei7lk5230LNxm1sIo8miOv0xEQNNlXg3fu0XZ1idKADyMgVoK
	 9IL8WxmZpO1Pt+RlMg8537UmbnyiqB+UoPXLrCQNd5SakdlNCrmt/ESt/aneMvzStBIUW
	 a+4UZB+AkW0kGow+Thd8qhHgZrcu/HoqQVeF+xMeJa/83UTDJOOgSp9HjTLbEmdHh/tmv
	 u4A5UqKWFAb5oxcw6keokiY2kN/WwzGSxSG9uoF0Ey0KgVSrUxNvHeVv68jCbdg5rQkdc
	 sVpg0hTxz+juxQvkYz4DVhn9cUotgBbhXywXrFDVEnziTjH/eBUOGe6aMDfM3Im4+GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVFJl7dq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCDD606A88F;
	Fri, 13 Nov 2026 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVFJl7dq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BC01F000C5;
	Fri, 13 Nov 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590209;
	bh=FGpCWz+GDGt/BMPC/W7Ijx4pMj2VYIhN+K9Bah2s4Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVFJl7dqbOwP7dMjfMyBYyA6FQP/v3wbh8ansoQMHeeddH6GS/xsdIXDESv5xRszR
	 E9IJrc8vDBJRlUTkoeUgb8LzWi7no+4gk/H37QD8olEgK8cM/9f6R81q9Yhijre3zL
	 44FOLvU5DFEm1FMcMMbRc8BOXKJUnr65Ibd6FgKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/686] net/9p/usbg: also disable endpoints on p9_usbg_close
Date: Fri, 13 Nov 2026 10:45:19 -0500
Message-ID: <20261113153827.305428843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit f81cdb9164806eb2df1e1c6df402e03bff7dde31 ]

The close function has to fully reverse the state change of 9p_create
(mount) and the potential call of set_alt(1). This includes to ensure
that the usage of the endpoints is not active any more.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-1-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index cd45d4a8597ad..ff787f5fb1631 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -465,6 +465,8 @@ static void p9_usbg_close(struct p9_client *client)
 	mutex_lock(&usb9pfs_lock);
 	dev->inuse = false;
 	mutex_unlock(&usb9pfs_lock);
+
+	disable_usb9pfs(usb9pfs);
 }
 
 static int p9_usbg_request(struct p9_client *client, struct p9_req_t *p9_req)
-- 
2.53.0



