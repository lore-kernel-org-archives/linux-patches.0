Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051107;
	b=f2Sc7JDv//NEW9PaFSLib1HogvwGhijlZCEFjK3cAcZaMZMYcDM0hqKskDGsz8/Nv4AU
	 x4OypydGYVks6VHcVRsEgV1acIZ1b1HmKq/l1Ru/s83JxuYNYadV1PdfezYmlv6yOWRX+
	 a1IYg7D2gRF2RsRr4ScYtUnr56BUtd3IwhJTimlF7hugqRgkC9RARvI8QqzEfzJg1D9/E
	 Y0uoauOMjgY8afGZn2CHOi7xjhNECYloMUQCTZJZj5omZb7466cnSRyJHjVsRxUoQbkdX
	 h0zPEbZvOGX9D7vjoKETYBnVGZqDqtQi8LRah0DOKSQaOdMhBeOim92PjOyWF1UM4zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=09X7NMXsyFbLiH+RjJ0gVX7jrTYYf+XktI6YCShsEOw=;
	b=YapZWnHUaB92vTKaIRiaMScC+t5+r4lyKNwQRlOoggKbWeHxm1l0wOsro5ybsjt6N052
	 fzgv2cy8Td9bQpnYTIph6g+CTWkp19K7iTh4Bh5QzUHCHk+Xvc+SPodfkNQodcgdZLCqc
	 WwmTN3BXieTZOrEPRbz1jIXrEHC7ZSelLER39ABdwio11ifWpdVm069qZ4JI14SVjodut
	 hpA5Ctip5NlDZWO7pVdS/WGYkryIzRRiSECuDqI51TomxF4mhH0Hl1GzF9ljlKuchwVkE
	 9QItbTc2eT+T3ThWVyx2vK53QfDD1Bx0JmcHqevgamAibPjjpvd4j02MguWKG0gVAlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQmbBAAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5F0606A325;
	Thu, 19 Nov 2026 01:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQmbBAAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6F31F000C4;
	Thu, 19 Nov 2026 01:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051107;
	bh=09X7NMXsyFbLiH+RjJ0gVX7jrTYYf+XktI6YCShsEOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQmbBAARIdPyQOyW1X02SOpKfuqZKB3nkjbIP1c1wj1rGQfMvhVXBK8UDN68Wu6MB
	 tXVR4mwGHrY1erJmdfqe4TqQ4b/vfWoHSXdgVcL8hdy5QwCErTbmWrhkmhhqPU9Edx
	 cHwbJ6Sf9PKZMn+OLRo4DDlqp9daH1PzPZ81fdc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com,
	Michail Tatas <michail.tatas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0092/2214] USB: misc: uss720: Fix leak in get_1284_register
Date: Wed, 18 Nov 2026 15:29:28 +0100
Message-ID: <20261118150013.649711147@linuxfoundation.org>
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



