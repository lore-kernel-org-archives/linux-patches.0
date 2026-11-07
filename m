Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063257;
	b=I5qu1lN2SUwIhCsSutqY6cWjHUfkQUE9tAotR3U5lB9HknLoFnrbIYlWOjsiAXwxB6G+
	 S90hClRx3UflaM5pCrX0Ac5JH4OG3xJ3oY3+5uNCZV5Vxv0+cgCclGmYj7Zpq5p7vnQHc
	 BDLGTUXj5DX/7Ubzn4dN3MS/E6VJVUOTmN/voVdqPgf44ke1RzuDxW8KVMk8DO9u+Vcez
	 d2VFc20XU19/PM828qN1uUV21UV+XOysej1hsU2rByIPnE1r1cgQSjqPeiJHx8JoKFiYR
	 96E1aoTbpbz6J7+tTnfHQOdWDeZw0QAeCdB8erSfFPbchh1j+abfUdrK88zeZGHUoEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u0EXgpN/ZznXDaIUGvi1T5KW9k/+blKU4dWJmkkv9Ow=;
	b=LFaL5golbf702uqUAXimejvjebeqmJG4M1Nt6LT519YnkJOlxxVZ84eAeboYGRz8n4Cm
	 NYJPxfX7IeMbY7eYamhBwggv33IK291bf7Lk8ESeoX/6DdJYYzNQ6LvkQo78pCX/AfBS7
	 mf+/KJ88aldHINFVbPCRCOh2jFUlUHmbVVFnOcqvKCkArKcMUf3/nYLarizlBcf/RzysA
	 dH/IeuqWr9eNiJSDXM6kyPmTIif18zeHp1WrdEh3r4Tv+c2akodjfyDOMRKeIm5p4dery
	 onZWwAK/3TJanIOXucTDjWZZVP8A9cz70vC61DLMR3TzE05MKuKSAnD1EI6HTN8Dz3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MV5o0kr/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A40606A32E;
	Sat,  7 Nov 2026 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MV5o0kr/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444BA1F0089F;
	Sat,  7 Nov 2026 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063257;
	bh=u0EXgpN/ZznXDaIUGvi1T5KW9k/+blKU4dWJmkkv9Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MV5o0kr/Bdwq4PK0PpIPvXPUgZf4Hlra7ZrLrqiYkWsyyjPwKv7z9XBmAv4H2jZJr
	 fz+eHUFYBeHrTQ17VjqKU3Q8Q2HPZ9+aydSto7BkDyY+8AMZjRRokXtZk1yZiquQ8d
	 NQaR5scCi9uIXov9llKXMIsB66TtwyNpBn+a1ZpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drobyshev Vladimir <enigma_137@icloud.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 458/869] USB: cdc-acm: add VeriFone VX820 device ID
Date: Sat,  7 Nov 2026 08:52:20 -0500
Message-ID: <20261107134909.218913682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Drobyshev Vladimir <enigma_137@icloud.com>

[ Upstream commit ddbddee6592ecf6cf6c24d888780f9ad45a3e30b ]

Add USB ID 11ca:0219 for the VeriFone VX820 to the cdc-acm device
table and apply the SINGLE_RX_URB quirk.

Signed-off-by: Drobyshev Vladimir <enigma_137@icloud.com>
Link: https://patch.msgid.link/20260929173833.105208-1-enigma_137@icloud.com
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 884dc80868ca9..990482982a28e 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1819,6 +1819,9 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x11ca, 0x0201), /* VeriFone Mx870 Gadget Serial */
 	.driver_info = SINGLE_RX_URB,
 	},
+	{ USB_DEVICE(0x11ca, 0x0219), /* VeriFone Vx820 Gadget Serial */
+	.driver_info = SINGLE_RX_URB,
+	},
 	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
 	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
 	},
-- 
2.53.0



