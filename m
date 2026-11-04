Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829519;
	b=K40o0s9I4PA22nFKz4n3H/ktNYjohUwPMXOxCdo3vFVaBArTjuQvebTAK9NqVr8+jwkH
	 kwtipGJdd7GL16XIReyXYnmspQWKGRLTnPoHGcuTkAgBn34lDy9jpMnDEFxsQ3sVIImPg
	 u7KwYHpJm7Ne7rCMaZK805+wdkxeSmAvajNvE6v9omxidBmx9cuuj35rmlDD12pym1M98
	 5Izir+TKsOIT78A6QdeKf7ChxQeAbouhlIvJ5an/J3G3BU6ce+Az3e26krj/xWv0v8l+E
	 h8AEVnXnr71n9Ez2/7UODfux6qqpGKNDVzjIpLCcGiwifF2H8J/nXZ0DaGtxPc2uUtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ftdCYY5maLMXYOX2diBpRJtiVHrvqJteCLjz4q3B7fY=;
	b=YJPT1tQhJNPRQ1J/Yufvy/Iq6puwfzJ4AgYbrG1rIKnW0+R3owA2PEuVIP5htdAGWUUf
	 /sbaNc6nlaITBnXIsl/N0NdCgbO127WZkeaJ9fHFKvnvdULOHWOhSKKlVqCopJWtPq9wz
	 bMfLrO5UFRxeboavqKrJ4qd6WAE58stNYfuWaoyh/V/bbSilg6OztfKmCiInF38Or2XEp
	 Kdl1WqWicTdSnwPeA2gkbLEEso/RHNXdYBVw5I4BGCwt2qdtITaIaD5DoaiNxOYeEm/CY
	 qy8jYV6zPToyrH6nk9nfbn730LgLps8bSeXxwfzfmbvXUSKLnpCzL957WrSmSflH1eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mJFNN8Dc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C54606AB38;
	Wed,  4 Nov 2026 21:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mJFNN8Dc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F241F0093A;
	Wed,  4 Nov 2026 21:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829518;
	bh=ftdCYY5maLMXYOX2diBpRJtiVHrvqJteCLjz4q3B7fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJFNN8DcGOJs4wN/9FvZ/nfsJvXkbj8gsr4jTOsefJRfrZ8m3Mv0MDHy3Rd+3L2FH
	 43VQutnsIaIBRercZEf7c7ZaZSoBEBr3IDygo7n2iZPKFZ2i3CDO4QEDxAttdi5OBi
	 spznCwbdOs0R+oCiDPW+JmCnMrpVJRNX/gwzejFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com,
	Michail Tatas <michail.tatas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0174/1005] USB: misc: uss720: Fix leak in get_1284_register
Date: Wed,  4 Nov 2026 15:58:27 -0500
Message-ID: <20261104211048.649154311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 6ebcfaf525989..a405a36d8d42f 100644
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



