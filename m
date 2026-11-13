Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591005;
	b=0jMyR/jrB9C+nt2/myQgy4Y7p33REq3C6sieNIo2njrTayiFzCi06iLsB/mb7wHclfkf
	 Yd0rkLVH2HuCksYQOlfbQdqQYdip1qpItAvyQTqb/xvNNTY+uS5MYar3iKnk3cxENF2LE
	 kkG+M3nI7SmfQ6P6VMAWkMDWLlYs2GDCedq6azWE1J91xtgHmiSDmh6CxzQxJaztENqZZ
	 ooFMkYjlfadH0HvSwacdlQvrVyHELPOisBYCGzNOz9+5hVhwaETxVOGtWQ1CQoAUSugDp
	 x+rJ/hzbc7oZ/+l2X3CezpR3pUySSvJiZz2uECoooOYeyuX30fusqUIwKCkFKtzDMNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zfmvpGPGH6wCVw91NKqHVfayyeyzBR+VcZcSC4KEyAw=;
	b=XOPY23p9xCF6tG+lK9W/9kdlQ9mgynH7Nfk6gzryK88sqMWBdutAkdJ/N7/x4b152GL6
	 P5m/X49bNGmKGRG8d2wzVoH5jWPl9sdTi0e9EJpyqgbt89NTbrCMDPGK0Ub84CIrbFcy7
	 gEwQv6zvKKymGbHy9lhhL3N8bBZc4gocTAXJzoJZOHbo4A0+JuJU65gzL6LFPS5Hvf2S5
	 o32mGbfJAGL/PtDRQ/9f+elAeBPhnSWDeYWpA62CG5tPf0UGWrTOScuGQIq60XluGh29Q
	 jTDu266JEERcjMCD2H0UbpRZCiqxvh/MoHHWAMGbJZM3fQYnCpTj+aBs55P0IG11t1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BL0LpzDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B860703FC;
	Fri, 13 Nov 2026 17:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BL0LpzDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38331F000C4;
	Fri, 13 Nov 2026 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591005;
	bh=zfmvpGPGH6wCVw91NKqHVfayyeyzBR+VcZcSC4KEyAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BL0LpzDx6n8BsWu6V/bvoQo1iMKLwgVOdbgT2YZqY5Y0ol4FW802CNVVSMSgJA1YP
	 u0/5RiioCsnh04aeKkyVuh7thcx8cc/MzI4WIICdnNuOjmXUWLL4YDCuMk/SKFqrEA
	 M+yvzPMqYbVQvq3ZLhdGIJGJBnsbvR3QvY62Nkk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/670] net/9p/usbg: also disable endpoints on p9_usbg_close
Date: Fri, 13 Nov 2026 10:45:39 -0500
Message-ID: <20261113153817.984255002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



