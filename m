Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060743;
	b=xmplnRhqym/zMMWUEFwGIR/Sllq4xFenL66p0/x8b08R1xJnab0gBAcR1IdUCaLd/Fxt
	 EpSOjVI0IQDXBBopQRqJTi1CX8B+xppnI13GzJS1TtrA3imuv63DMm4nCr72RcSFICrOQ
	 bapf5g6+NydKGS23ps+GrYmbpQFn8/TEA11ROyXxtObUWFAx+cDNcMQEOiNsp1RC5iigk
	 kUZr5fPIArBAAkn4FLirNKt5Dgy+mUZo9j4hAl4eEaZtAofuZ5RNUwJmC7dU80tVAnHA+
	 JUGBrw1lyDTquoXbK6wkjAtDeV8LehyVCw05n/emZGvLBIucUZ0iEuycOG/r8Nw679w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jgh1QxIXiwNauEyfYeu78ZhCAp3xmDslPDQTggclXx0=;
	b=h0VAjCAZLM6KOq57iN9COGVXKpfNMmEATzikW7ogFzPBQzNYakX7GyxqUoVw6TP7ye/a
	 YT9sKGq5gjb5X9xUsT8E66eWhMb6w2XzjTzhVGkQGo1i50ce2Tu2wqUOQ58KosV6elYS0
	 SXf7yXHwWunOZzSxEd+Gk3NOqleyAa2fY5OOgVqNjVOtKIPg3K7lhcAg6MQcwx8KzToaQ
	 FEj4jsHKRHdvQcthbgX7rgCFoGlNPljVinmhApgMM42+SWQIbZcZhu9qBwMOZbmlpuXBd
	 4rAEoXI13081FqNltP2UKYfg1hkN1tWZtpIEH4202wKDMvDZ3bsoP8h3sJ/xofYFBAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MA7iDC/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35AB606A326;
	Sat,  7 Nov 2026 14:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MA7iDC/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0FA1F0089F;
	Sat,  7 Nov 2026 14:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060742;
	bh=jgh1QxIXiwNauEyfYeu78ZhCAp3xmDslPDQTggclXx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MA7iDC/uIToUY0qiBXr1aJ/F0wtNim42jiSKc8uYwnEFBzDqAlofoj5kE8NoZFolD
	 cL9S8Llrz8oHobzG2KOpCLa9wZWd7ZqZSKqIpBDYhXNLOr019jm5ogVL0zr9FQKlYC
	 1n+f/iV5IlI86xsybXuBrh8sndsM/4lP6CL0Cw6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0158/1536] greybus: manifest: validate string descriptor header
Date: Sat,  7 Nov 2026 08:36:14 -0500
Message-ID: <20261107135002.116007287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 18b6510f642dbcb856c3af8be974d1600f3ba2d3 ]

identify_descriptor() computes a string descriptor size from
desc->string.length.

Require the descriptor to contain the fixed string descriptor header
before reading the variable string length. The existing descriptor-size
check then reports the short descriptor.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/manifest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/greybus/manifest.c b/drivers/greybus/manifest.c
index dd7040697bde9..469da3f39afb4 100644
--- a/drivers/greybus/manifest.c
+++ b/drivers/greybus/manifest.c
@@ -122,6 +122,8 @@ static int identify_descriptor(struct gb_interface *intf,
 	switch (desc_header->type) {
 	case GREYBUS_TYPE_STRING:
 		expected_size += sizeof(struct greybus_descriptor_string);
+		if (desc_size < expected_size)
+			break;
 		expected_size += desc->string.length;
 
 		/* String descriptors are padded to 4 byte boundaries */
-- 
2.53.0



