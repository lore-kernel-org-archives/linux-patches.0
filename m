Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035516;
	b=HP73KkqvSEgcBVfTSyKjTiw+2pa1G2Dfg0aYiyeNFA4olwjLFJK5jpFEcOUTAT7/nVFD
	 9Nk8yW5bS0UsxQ5BX9NSqlLwccRIn9Yu4WmIS335BLfoiCMqUEAykOkHQfr1SLh3d52TF
	 y7V+CtWUycyoaxpaaebKGeQphGg87jBsMzwIVayOiALgNtA6T1oJEMHLdWY10TwPFIXCT
	 n/rPeHxSjyQdTiE5HfXP2W0Pf0sB1ZJCvrVJNCyv9It6CjEEykJ4h+26R94auO7QL7NvP
	 Iu8EerVgmL9vQ25FMCmfaQMRihim9Kv+v9EXYpJIc6nhGjpKM8GKwMVNtX1JKzOx/9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F6egDRi3oixXMDBcf3IsDKmQYdFCzNdXI5NoR81bMuA=;
	b=EcB670Ir/sIUnHSQsv8vBcn9KxirBcHQ2I9sgx1ozk0QrTi3MJ7IEV+7RqtxjsCRl1dz
	 QmJHXaTcxEkSPQlXRI+SMXlHI138qbolxyxQNiLXhIF6P42xNrv24f/ljs0FhyWb2aSwH
	 jYASq3PG2h99ZOXWVkd8aSZ0v3qCqzarATiL/P+6/TsPQ3/4/fWqa+ruam8bx37MPaNRw
	 It0LG+zCpV5WWASlbX1J2rgWkMBVz9fK7UzgKZgO95KbTM+9uIWqqDiIeDTFm3eLGcsgQ
	 ChGXUyTg2FUm9Y+3GrJedX11PCKNwSpDvX+ef1Yl7VV5VQTU5KnhAFMMTpi4B201I7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fTFnmu/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0720D606A320;
	Wed, 18 Nov 2026 20:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fTFnmu/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5855F1F000C4;
	Wed, 18 Nov 2026 20:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035515;
	bh=F6egDRi3oixXMDBcf3IsDKmQYdFCzNdXI5NoR81bMuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTFnmu/gTfFLOnxb/a5PaQTRapRsQbVuCGQZ3jbcwNURbqx6lOT7/FQE/8hoVi8fd
	 bZPymhD5o7f12c0cWoc3Ko1DyXtv3mj2khTY9F+PfUicyVVtGYj0GlVjk/Pr7DN0+c
	 dlNIV9/xE/ebC1omTs/SKBFtkGVcaxYBNQuuTUvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0731/3318] HID: mcp2221: validate response report length
Date: Wed, 18 Nov 2026 15:22:33 +0100
Message-ID: <20261118150340.466512072@linuxfoundation.org>
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

commit 1ae40774d386b7a51e4799200106429a7e14e8ec upstream.

MCP2221 responses are 64-byte reports, but mcp2221_raw_event() currently
accepts any report of at least four bytes.  Several response handlers read
far beyond that minimum.  In particular, the I2C status response reads
offset 20 and copies ADC samples starting at offset 50.  Other GPIO, SRAM,
and flash response handlers also access fixed offsets beyond byte three.

The HID core invokes raw_event callbacks before validating the report
length, so a truncated response can cause an out-of-bounds read.  Require a
complete protocol report before dispatching any response handler.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -768,7 +768,7 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
-	if (size < 4)
+	if (size < sizeof(mcp->txbuf))
 		return 0;
 
 	switch (data[0]) {


