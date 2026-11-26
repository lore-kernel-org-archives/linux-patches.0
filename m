Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705796;
	b=He5GsDRrMGJF09l3gLBFVaqrrC4Ab3Cv1BRPTu0QNt2QXwt+WyofyRrfdshfcGmgwkC0
	 GWARSSANPfJFGopMGNY+jMwcByeCtR4Mz0Pg1oKaZ1iDa+BXda5IYgbAaTzEHsy0cO/G9
	 +UUtxsjPqosB1tGHAYXGk6nLf3ax2l0QusriO5pvV+xFLkdL3S3UZDOZjtSk8IHnqIpMv
	 qS9ZjpmmA4xwCSLGnuNeBWnEpO2yviqVzb68XYg8ISpwwve/X2YLy26w9iV+ziJ8mR5ml
	 bhsqCGGMjOaqAtQ5PpYBQR8c2kn1htMqYjLBu64jDWafnFTNBcKMXzPaQ9H8kA9Lxsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X39GGht1N+yPlmpfl4RwjU5I1M3zw+H+n8PVCrLc8QQ=;
	b=eQzPJfGb1b+VRKsUZWiY8OKtF23Ag5ITzXXS8DeQ8JrfcoHL8Yj8fCzpmzAOBiJqqq+z
	 5c8wZawv5o3LRb4UZmXPeZ25PmPmZRQYCvwz2s1rFh4I5F7bTRRWQ+j9jAILkiOxcvSdb
	 1Z6o3Zg4fqVKJAnFNy6C9+11HB30Ye3cmMQTWUFavqGjGtEjIA59FB3YTeEKM+lg2ews5
	 w061lQR4/xSgoynqVmrFINIXANyhFlXxd5j+dmcW/aro10vomTGdWIbPIhZCaqgd1rf53
	 /LmnEaxCzzP3uyyKYr1LHwVn22xaLl/NJBWonLXzuJ5w+Je6BkKZuP4EMZbamgNel8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkMR+pX7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA283606A335;
	Thu, 26 Nov 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkMR+pX7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9BE1F000E6;
	Thu, 26 Nov 2026 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705796;
	bh=X39GGht1N+yPlmpfl4RwjU5I1M3zw+H+n8PVCrLc8QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkMR+pX7TB295DsIH3LH4OpnBDGhCaW1+eBTg0BLz+9SzdaM20Z/4tg71A+x+xpvD
	 VbCQ2GrCorN+EIkqFoeb02VIUJbLrTBPkVg+ZVsooj6pDxHkgjBfeToh/UoybXfVv6
	 +RJ86F5Uv/6dh98nqfyByoqY25shKCok9crmU9+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 273/319] usb: usbtest: prevent divide by zero in simple_io() with zero length
Date: Thu, 26 Nov 2026 15:40:41 +0100
Message-ID: <20261126144012.914306410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit fdaca138694111153f96c7d76877734b9dbf0e01 upstream.

A divide error oops was observed in simple_io():

	usbtest 1-1:1.0: TEST 3:  write/1 0..0 bytes 16307 times
	Oops: divide error: 0000 [#1] SMP KASAN
	RIP: 0010:simple_io+0x2c4/0x540 drivers/usb/misc/usbtest.c:497

The variable-length tests (test 3 and test 4) compute the next URB
size with "len %= max", where max is the original
urb->transfer_buffer_length. However, when a zero-length transfer is
requested (param->length == 0), simple_alloc_urb() still returns a valid
URB with transfer_buffer_length set to 0. On the first vary update,
"len %= max" divides by zero and the kernel oopses.

Commit 564e69893c63 ("USB: usbtest: prevent a divide by zero bug") added
the equivalent zero check to alloc_sglist(), which covers the
scatterlist tests (test 7/8), but the single-URB variable-length path in
simple_io() was left unprotected.

Fix this by returning -EINVAL early from simple_io() when vary is
requested but max is zero, so the divide by zero never occurs.
Zero-length transfers without vary remain valid for the other callers of
simple_io().

Cc: stable <stable@kernel.org>
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20261016072750.34256-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbtest.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -466,6 +466,9 @@ static int simple_io(
 	int			retval = 0;
 	unsigned long		expire;
 
+	if (vary && !max)
+		return -EINVAL;
+
 	urb->context = &completion;
 	while (retval == 0 && iterations-- > 0) {
 		init_completion(&completion);


