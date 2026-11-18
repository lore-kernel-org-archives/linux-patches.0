Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057296;
	b=lldsI1m6BukLpIRW3o/VpDp9lJtqdSnp5bSuNGrFBbvjsmvxm2weE6rGYxsDQt0giyfy
	 N/FS2S5i21gaUI8JhYqZBCdx3hzV8TMltaweJNv66KINDMXQCr9METEWa5UsrI77QjUOp
	 4STySmsxpg1F7hVZYOTfpUKlv/8J/ZyV/y2UaFAl7m0s/cwiiu3wyjomY5NuY3YGUKVQY
	 t5phu+zy5YiGfascOhVnptpMd0cgsgN6FBa1mt31C9tCumQVCFQ8igD63GJDR2RuisLRd
	 dAdoqE0kic5j+UVeHFEWiclDUp087XXMrkbinTzTYMHuW6hAxQuAWfCHHYduFiaT9qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T9XtXY8M3zkul1zKKNLgOUkFS/mszeJyOl0Kr5/RX54=;
	b=mUB7i4GHRsUBJzHEKKf1yDo6r5c9btGqMXFQ5wcvu9Q1Dd1i9tz+kl8HrcnhJehdGmK/
	 zk7r7ndf3Zxr1CGuh9QROT+QUhDWGuFQ+iwcuVjZvmb+HKqp+Xu69J2RuaYXAYekMo6gi
	 lW1mYZc6ShCi60+ECtpBaxTV0sn6286wBc8zrrUOfyh/YkAvSV+8Pa5CddHWAdKgZEWuv
	 Q6Ry6kC6axCMLL45iRq3recMEB8HPK3qC+akdI5e0unTIdt9xrp9cVOKlSayN/oAxyLO2
	 iyfFGtRrIlIAsyRbamGe0+u83mqZByDLTK5L8F1pP6qB2jNpr5emlBYkYcg9D8xvZ7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN49oK+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B8C606A33E;
	Thu, 19 Nov 2026 03:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gN49oK+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27DA1F000C5;
	Thu, 19 Nov 2026 03:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057295;
	bh=T9XtXY8M3zkul1zKKNLgOUkFS/mszeJyOl0Kr5/RX54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gN49oK+2PymFUsM0bHMVglITZDpoFdMvAPKf9blOYZDFKGK8eCrSt01lSG+hLOr1I
	 fGPTfWL6/pzaAY72uReLGi5CNUcb4HH7b3rrFHal/qEBzvqLk8KovHKDLC3MwkeeM4
	 vt60WhvBxUXd0QdU5Eg4h5m+vOPvXpKJXIhGUVv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com,
	Michail Tatas <michail.tatas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0079/1848] USB: misc: uss720: Fix leak in get_1284_register
Date: Wed, 18 Nov 2026 15:35:17 +0100
Message-ID: <20261118145914.429094502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 15902712b9e2a46649cba2f22002d05faec2a990 ]

if wait_for_completion_timeout() times out in get_1284_register()
then we do not destroy the reference acquired via kref_get() in
submit_async_request. Add the missing kref_put in the timeout path.

link: https://syzkaller.appspot.com/bug?extid=56962eb32ba0136cd330

Reported-by: syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com
Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Link: https://patch.msgid.link/allaDTUua9n5DQ0a@michalis-linux
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/uss720.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index fbe00b65f3449..81938702c3c04 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -223,6 +223,7 @@ static int get_1284_register(struct parport *pp, unsigned char reg, unsigned cha
 	}
 	printk(KERN_WARNING "get_1284_register timeout\n");
 	kill_all_async_requests_priv(priv);
+	kref_put(&rq->ref_count, destroy_async);
 	return -EIO;
 }
 
-- 
2.53.0



