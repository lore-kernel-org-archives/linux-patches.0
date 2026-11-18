Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044633;
	b=U27I3A+y6QoLhwZnbWvfum5XNR0G706d3wNhpn5SS334sVeOkRQ8HpodZZG57LOkGu7H
	 L6xMGXIPsEHcybLDEE2FSO3o4N0sSigQ5vg9gyVgvDHORRCUE6nxKAbLMaNRIdHGVnE2m
	 4Yk8uXFxFv2PqrwU/UQsfwDiCAR9b9HCArZBv1gwEs596TpRMa64fv6GLxJJpM6KYq7up
	 IU3azw8WtpdcVYNKr9oA5JbYIwHju2eDH5/jI+KlueuQ2eA1BdF7kDebxj4wycdt0l5w9
	 l42GE8wIC3LFMztnA7Pgyg5c11n29qwL+3g4C23PkpD2EuU06YqHHY9Jn0e01o8XyfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ViolQc+V7BfyTpFL9NGYWu5hfrJSlv69RV7oS4HVd4c=;
	b=wRbWAoauH8nDJHN65UGHoEzLRBx7RgQYxnlFjMDULNbWRqWArHI85krTryIli6I6U4af
	 bqZZxtGwQjEF1trZOCfjIEav+Ijh9l1v4h/RY2cz8ts3dcpkMrwepApFwsvlhUMOGMqsy
	 KDo/DUgnjVaCyp/BX1sbp6b2kwPiVmJi/fwdqZ+wVbyxqIbnwRtUt2JfZ0emahMI60VJs
	 H8m5qBmWKyU9u8Xed568Q1gD1R1V0Sfk6V3tolD5cucuATZX3tZ+5KvSV74hPnd4fifpt
	 7tPUpr1p6P7H1IerYjELKoJw+g1AHNTIlyR2q8bwarJoBkZCt4kxzrNfApzsmMomQuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwfAlNq5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B711A606A336;
	Wed, 18 Nov 2026 23:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwfAlNq5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161F01F000C7;
	Wed, 18 Nov 2026 23:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044633;
	bh=ViolQc+V7BfyTpFL9NGYWu5hfrJSlv69RV7oS4HVd4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwfAlNq5SrZdwpdDgR98BFTJG83z+wCQVM5nnNstdggH9z1/5PGnm4cotnvX6QV7k
	 yJyab4fAQb0SlIHApKxtqYxfG/GfUXW1ah3KvIX3PWuYulPIkrU/7ftXz+RyUN9XyK
	 S0vSRQ1b2XuND4NmOYPoltlsS32pnQw+m0IMySsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0638/2857] HID: mcp2221: validate response report length
Date: Wed, 18 Nov 2026 15:27:52 +0100
Message-ID: <20261118150224.485573744@linuxfoundation.org>
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
@@ -748,7 +748,7 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
-	if (size < 4)
+	if (size < sizeof(mcp->txbuf))
 		return 0;
 
 	switch (data[0]) {


