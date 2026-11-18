Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043139;
	b=sarVjktdC1NdsZm3ZSG7EhYO35XaXQcC3lmEk/ZTQzc3sWun1xHnw3yUBYa1xWSpYayZ
	 Ez7DVnjrKVcvwBsefxyve0nHzl2sVHlFlj+T5A3ciSFZ9RyLPthAP1c5jqE2MwUwtmzi/
	 Uo2HvKuuYQM5YGRsldQOy8CvY3ZHJIvdJ9sR+44c+qoU8Tgj+RgKvzoDUScz+KnjuVK2P
	 ElNfXahqqNbEfzXjrChzVYluIbi6ob0x4UMp+q61a6JVbWJNwuOgfWKeqTCKJpTz5Vnrv
	 isC+fEmfieUosAqDacud9DJG9fDeKHs6gU3tMxH2oKZkjAihb8Ga1m+fE6MDwqNtvHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VXLa5T9EHJkEDdJlC1Ov+puArSdouR9igp5ow3QqfqY=;
	b=fI96zAetSOQDTHhCLPqN179WhkIOVR4YVb4Az8nN6jovMZwPtPzoe72yB2cp3vhTbSfM
	 0SWVQNnHNVDySMT/CFgdXnd4MBr7R/qj7Bi1acZjitVuxFXf4OzoxI+5NpOCAVp4qybdb
	 0Tz7RvTef/21c8WzbzHbGljVo+hAd9Hyx+qPcFudDgAbj5kYnnpUZ0p4ZHlWIrxX5Dx5a
	 WUOtIC64McB9Qm977IHRnShMGiVKVVa5eQeCzcqxNBLslx0TK9hg5xA/hcSKj1Sj51PMF
	 J6Kd0hVM1EXu3AcjdCkBcrftUfp47WIECXZ8I4QMQSONEtaMyZjGDoMJRP7aZ7H7RRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IL5/6rBR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F0F606A31C;
	Wed, 18 Nov 2026 23:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IL5/6rBR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569E01F000C8;
	Wed, 18 Nov 2026 23:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043138;
	bh=VXLa5T9EHJkEDdJlC1Ov+puArSdouR9igp5ow3QqfqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IL5/6rBRY0hYVdFZgSZw0JE1h0ZV8Lhc/j5xvr31+n/+hAD+DkjKMqZigRTaB1hQ9
	 AB8eDXmgw8QhY/l8AVUYmvJI5xJqhNgqt8VQY2kFwxFsUmPLLLFTIcib+tHbAJB28Q
	 /I4vdnG5vV597+nphhK1ac97JVgOB0bTdu/6CbM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com,
	Michail Tatas <michail.tatas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0102/2857] USB: misc: uss720: Fix leak in get_1284_register
Date: Wed, 18 Nov 2026 15:18:56 +0100
Message-ID: <20261118150204.930294737@linuxfoundation.org>
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
index 3bb0405d85c0e..fa66e1d5cfb04 100644
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



