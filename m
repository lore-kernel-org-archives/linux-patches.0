Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061777;
	b=a33ULI3K6MD/i1Ah9jQAqBON+OnwnsDGiB/+5Npd6s9LAR7PfAMkOO2J3ZJYQ2WK3lWl
	 RRacPPjEtbWL5EFP6Et4Z75m+Xs7XmOSUXZqCzr0X7o5NCMFpj4vGGdAJsO50qiOvxtFS
	 ghWJhl0Qnw19fenHZfTAqtOEB4+H5qm2IjQghujRLmF+TlQZzjmCB98VO4OSoBJdCSVhH
	 y4xsUV6PNhra25WfvgkQK9KmOfHbBz992rsbgydKSIomyvsyRWzvmqhnSlY890MdtiNGN
	 p/1SZU/CzWx8jHng6T1CEHpSdtI6KDThF8U/PVboBI6/ncr1j0q0RtRqJGU/I/rLzcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2fNa5ht33rCQpTj5WQn53c43AstS2rNvcSX6U6SSl1c=;
	b=rcnLJN8kbl/gQNjNKyBMbzFS9iOGRCaSmiN4IC2KiQnTNZSADA8gFd3lferPaMyP954Q
	 0KrvDUbTscViOvtBs0sn677Qg4bwsh4oKr3Fj0+feVJQZnaxCT657rNul9ajbKHInlID7
	 0KnFVM6w6BUa5rwo9J2xYjHdSDxQwL60W8HlFU3Uj/7BDOaWtnnTW2RljG+qLo2bCDJ00
	 CT13TLuqQ48MA/N7RJmUJG9SpjP9kD1mMUt+mNzcJvyuFcDHgQ3RDX0HXC2x+O++R9P+A
	 dxZdIXVYB86ieVS32Z1vkT4fWizrqQyRI5tuoft8dC7N9XDdH1aHwDYG7kgjCvpjy6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lf+F0DMK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63EA606A326;
	Sat,  7 Nov 2026 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lf+F0DMK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF561F0089F;
	Sat,  7 Nov 2026 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061776;
	bh=2fNa5ht33rCQpTj5WQn53c43AstS2rNvcSX6U6SSl1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lf+F0DMKDaJYaS+wHXvQ5OIaGU1YbjmfLMigZ95qYfsd8CC+BkHLW0lVtesGgarhv
	 Vh+UuijTfEYcg0izthhAhmGdZ+PtSK3ERk9KpeQUdPLS6XpBS1/IcXdivg9u2Mi4I9
	 AGdaUFFDBkT7pNLevoXKiECBJghILBrO8xQLz0do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0809/1536] HID: core: Fix out-of-bounds left shift by 32 in s32ton()
Date: Sat,  7 Nov 2026 08:47:05 -0500
Message-ID: <20261107135020.266196779@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 5fe63b415c636c7f4f6848a8e53bdd4bbf0c300d upstream.

Syzbot reported an out-of-bounds shift (32-bit integer shifted left by
32) in the s32ton() routine in the HID core.  This routine converts a
signed 32-bit integer to a signed n-bit integer, and it caps the value
of n at 32.  But when n == 32 there's no need to do anything; it can
simply return the input value.  This will avoid calculating (1 << n)
when n is 32, which was the cause of the invalid shift.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 69c02ffde6ed ("HID: core: clamp report_size in s32ton() to avoid undefined shift")
Reported-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/6ac9cbd8.a150a118.27e199.0025.GAE@google.com/
Tested-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/dfa0aa1c-e55e-4316-8307-f72a07383634@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -71,8 +71,8 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
-	if (n > 32)
-		n = 32;
+	if (n >= 32)
+		return (u32) value;
 
 	a = value >> (n - 1);
 	if (a && a != -1)


