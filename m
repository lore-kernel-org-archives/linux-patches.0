Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036048;
	b=vSBClTZ777HaTEtFYTCoafKUU1m098yvMe7pBXNE08L8MIag/GlE0y3ExqVex5zF4h0p
	 iBt0u+03JFYsdQBFNmXJj5c/sts6CxQyk+quKvfN7CLSEQTz2mQ+JyaDIF2jid7Y6Qquo
	 UUU6gQkAR3v5GSc2CLgpcM49J11EkqeYNFapx0kuBolq2hTO8na0N/AgxTuKJ/2UBuTjK
	 KVZ5rYMNQmA5xx9b5jLzPUWSlMeBiibNWBIu/7HRIid4pARMMDerQHhIfvKQHJC/jJHC0
	 LfD4z9jWtEw3iaoifX+iZLWslCsmIXvpVaZt29h17DOeQe5aXmwBJk8XdAwSDBr6dSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ma74JDcT3ijP0JZSu9Q5GJCAk4eBh3pxamcwbuqnjXc=;
	b=cqQL0rSEnhtR5ajAdh8efhUdb+hBVMOA9Yei4rkf/AUV693vBCEp+eh2hyVKsvJxP01X
	 rSuVKNqyKd4ydDrBYlAT7OdllX1KaosO6gT4MXS5TEC6iL51eAkpEJ6zmclCRlZdjjXzJ
	 ehpWPxRfqMUL5hdTOknqplU2iBhiQYmXVJA2/xfaaaTW6RuugERwhUSabUHcjxWS+IFBc
	 LGekmcSduE1WGdSch0Sv9q2PRKO6jXCVq7LVB/OfeCM7ErEzjvMVzXdVauPW5eBwM3s3n
	 BpuduoCfeRa4eXlfjYWg1MSQs0t0ddDWcdvE64MSYeMDY3vV/umt2XEPZqG1DtWrR6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qv7IEngi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA9A606A31C;
	Wed, 18 Nov 2026 21:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qv7IEngi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F31D1F000C4;
	Wed, 18 Nov 2026 21:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036048;
	bh=ma74JDcT3ijP0JZSu9Q5GJCAk4eBh3pxamcwbuqnjXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qv7IEngijsxQHNs7zjuafz8AGTfdeuy4uSWpagMkZMlGwVNOQ3/IzMWZZrTgKOzeO
	 QLmjEFL6updC36zeIMkv+9B1zZ2YYXS28nW4JwkdX9LuUYymkBkrDcfIgIFjmdPVXZ
	 kjJ3et8gtnq7/f+a1FCxSp1O6WsilODp23T6WwG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0918/3318] media: go7007: unregister the I2C adapter on USB probe failure
Date: Wed, 18 Nov 2026 15:25:40 +0100
Message-ID: <20261118150347.066661950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 14165cd16fa7c233aec6a407b56b304e7a283911 ]

USB probe failures after I2C adapter registration free the backing
go7007 structure without unregistering the adapter.

If i2c_adapter_online is set, unregister the adapter before releasing
USB resources so that I2C client removal can still use its callbacks.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 59aea928d57f ("[media] go7007: don't continue if firmware can't be loaded")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 6a0733c5925fc..ff479d6495c45 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1326,6 +1326,8 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	return 0;
 
 allocfail:
+	if (go->i2c_adapter_online)
+		i2c_del_adapter(&go->i2c_adapter);
 	go7007_usb_release(go);
 	kfree(go);
 	return -ENOMEM;
-- 
2.53.0



