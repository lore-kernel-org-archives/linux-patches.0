Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035513;
	b=1okBBg5Zu+fbJ4ZJuFPy7ILQ+ap4qleiBSpa6cfVEjG9a5jCJPnicnfJGnxVCOQXfm16
	 4ZWS8AvDcDHgcM8Dmu1zn2N8ePOzxxEO2wPIIHAP9gHLXKyll1SqmPQZtdvldov868fA5
	 X+g5Z7b/3yj7mhvkPDhbYXFy00N6gihzG3moGhYUXvm+CRj+FiuuQz6Me9mKxrUzmfygu
	 2CwoJRKkIBIRUChliaIp1WsdXVgOX5ZpeatwB+2JaqrOUSwHle7fCvUPuaWKa78CmQ0w2
	 JV9yUB0abury6uqHh/H/pSZnMXKJnHubCcJgc53B1BIBV6aVKAyL4hmJ60bRQWO03IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UapJaL9HPaaI4Aia0waWyJp4YTH3C7Zl8hD5T1F4JGk=;
	b=0gJU9a8YZ2VgJhSgWTvUmlE5Rd9yMQg2+z6LkexaOmzKH/Z/6APKjcX9eVRFKH+oFcG3
	 Zs8sVSA2zXHND1t9O/2Ca8JFLjPiwH6WeRAx78Kv5T+cDpdOzi73zs3krZqpeg6H1mYa8
	 7w1aL4nxg0Wo8H9LFFdxcCENOPS5Pnx0y3Dlr4dNe+Bi7rqjWDtz0K9BEHhN5EiCObv4u
	 V3327Wq6KpY3A1HYOJ3FCcHN1NQcsAk8HSRG0bGuLENIp2PzXAjYhk/SoN2bsO9Rh7byS
	 zcKFcCYP6M8AmIm0Fct5IgHIPc5396gpqs071gMusvh95MqMWb9oMAWK6p2B+1XGwyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjuUSAJS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D20606A31C;
	Wed, 18 Nov 2026 20:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjuUSAJS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B42E1F000C5;
	Wed, 18 Nov 2026 20:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035513;
	bh=UapJaL9HPaaI4Aia0waWyJp4YTH3C7Zl8hD5T1F4JGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjuUSAJSWeN17Dw5qyEgUrDYln0X4bhMTVMjTihEP68y7qtJYJPZ+6mMsIbEv7ulO
	 044KyHiLdhCf7vaiMOdoYQqVg/HVIIFCdKT9IEWh15mG/Kb2gswG5Xfq5hw0bJbemJ
	 zHVzYUn7nMh6SkaK/EnYcwOjlxzA676pARGTY8Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0730/3318] HID: mcp2200: validate READ_ALL response length
Date: Wed, 18 Nov 2026 15:22:32 +0100
Message-ID: <20261118150340.432929307@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 26ce0e6bf0b27fc6a2f490f38555dfd0a27c9605 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  mcp2200_raw_event() casts a READ_ALL response to struct
mcp_read_all_resp and reads fields through offset ten without checking that
the response contains the structure.

A one-byte READ_ALL response reproduced the issue under KASAN:

  BUG: KASAN: slab-out-of-bounds in mcp2200_raw_event+0x24b/0x3a0
  Read of size 1 by task hidtrigger/89
  Call Trace:
   mcp2200_raw_event+0x24b/0x3a0
   kasan_report+0x139/0x170

Reject an incomplete READ_ALL response with a protocol error before reading
its fields.  The common completion path then wakes the command waiter with
the error instead of leaving it to time out.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 740329d7120f ("HID: mcp2200: added driver for GPIOs of MCP2200")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2200.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hid/hid-mcp2200.c
+++ b/drivers/hid/hid-mcp2200.c
@@ -296,6 +296,11 @@ static int mcp2200_raw_event(struct hid_
 
 	switch (data[0]) {
 	case READ_ALL:
+		if (size < sizeof(*all_resp)) {
+			mcp->status = -EPROTO;
+			break;
+		}
+
 		all_resp = (struct mcp_read_all_resp *) data;
 		mcp->status = 0;
 		mcp->gpio_inval = all_resp->io_port_val_bmap;


