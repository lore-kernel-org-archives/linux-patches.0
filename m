Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829178;
	b=BkZO4ZyMcnWTwIdvxWqTaPYGsC+q0adbKigVNqIZd4zFRnLfoPn3XL7WMdF6ncGLXJQY
	 BK53K4EwCL2QGpPPpI3VgNK4u5TukN6WW4nkk99WaU8lBp38t/Skl9d4fGJLx/PB/1GHQ
	 mxu/jOLKYVOoI5j+aObEzIUatDQF5d/kuK+5L0k+dQKao411pgSl9IAW4LtozBm3VVd7V
	 HzgQltkH2+Rc61+OEr4+niREjhSHl8j0FFDKwnyIjrKRE1oSDTukykBDpWK72XmGApdeg
	 32SFfP5xaIPuMS+nmBK2rlsqM1Dd0AB8VovxZKCP6tjg6aw6icRRaJEscMnvMwnjUqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/xUG3rG2FP4DO5TLtU0B0XfUuSLlGX7cY+hUCAnDvc=;
	b=sXscHvnDoIQ41q3OpciDBxTRdo0+lveS64B7kB4rasfMnSpWblyIW9MFYco64AWT/rJN
	 3bIrsKfTV3mnH/vCjXV8VdZijsORavbG7UXVy3vELT7QzGE9sKhyeajctQFWemgw0UM8k
	 9FxLd43EGlBe2j+apBW3+w8cnlBbNWq8/d/gCkgK4cXGZUOT746syWAxO4wFLttEzjtB0
	 42TQMPWCxbhmGbYuSu/MvtSeFW3des5pazgh3d1hxTzYxRvhCJDQCbIhMzNVmvpObqviJ
	 pVtynprYSCC5vy6weh7MQ5rxqRratQAv/0UNybChvW6CF4ZoMqGQxsB0MrYVTfSx4ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFpfE+Br;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C350606D817;
	Wed,  4 Nov 2026 21:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFpfE+Br
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF30D1F00919;
	Wed,  4 Nov 2026 21:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829178;
	bh=g/xUG3rG2FP4DO5TLtU0B0XfUuSLlGX7cY+hUCAnDvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFpfE+BreSUU67HUiIQi8OmyO3fWPi3feqeobstB5Nn2cks3X/sRw3zxBuXOvD29E
	 74LwSS6+ZbjlSKG18ZHJ7g/pDxaf0KMN1zVGHKA8AR9unlBz53h+hwhsnnDX3XAPki
	 upcWXhGY48ARWf1fd/LJIqgSkOybfSo/PpGUck7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 495/547] HID: mcp2221: validate response report length
Date: Wed,  4 Nov 2026 16:11:19 -0500
Message-ID: <20261104211052.440007759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -865,7 +865,7 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
-	if (size < 4)
+	if (size < sizeof(mcp->txbuf))
 		return 0;
 
 	switch (data[0]) {


