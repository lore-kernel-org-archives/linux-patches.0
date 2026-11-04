Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830817;
	b=wtPhaf9y5CCXWtgCXJxrQdWVg4lIDOrS7ZXn7e83u5I0qAhelYnPcLSX413u3RosqlG0
	 jzRxUsgHx6wKl8IcGAv3qrocYs0aOME7gMl3EC9gz7Rk/J/qfEW9PVcBqfXX52uLQzb5h
	 qnnUkX0SO6bpXfC42uLbss6YIEzcJAjBIFkMm0rvj6CqaPvONhaO3wqLngKOE4QzIlspC
	 cUSoaJsaAO4uMY0O2D0bWWN44biMn/FHd0s8VoMn18ZQxPyfZf2MsP3i43x8mP4nUUlW8
	 350JxwE9UqdZ3uGWmoQahvd2Krt2aFoso+/U867QzlIwXHJOM883A1lIvagjf/QDa1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uAJZiIKub7neW5nFT9VSRjlr/A14KYPxSH3yVgm6QOM=;
	b=V7Rgs8Lvz7trT6dfXFPqMK7c5qujXMzV7Dmpx0zJBcgcEXpQUAFjkboIW263DcUOaxaB
	 sXk674uWn/xT5xtLvFvaGSvtk3P4kOPUKAdX2ze8Na0bNX+b59H8dHsqU5xfG+YyeVntS
	 Rqd9gxlW2rPnE2rhM1yi529Ag3Z+qvFdwbZrmma6FdPt7dkESvcf+jGCFzBrGBZzUBwn0
	 njEOf4krgkBkjNVXQeUGUm1+y44nB9oxz2DPhQOHleKCqtJyA+LxUUs0qteJ43TsDNj4D
	 s/nFrLn7Te4+wIPTfXwc4njIgJ1kWmKWbfz9U8hd7iAb551dsdmgJdDwbYJhQsj+agw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvC6vDr1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02253606AC39;
	Wed,  4 Nov 2026 22:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvC6vDr1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917F51F00A1A;
	Wed,  4 Nov 2026 22:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830816;
	bh=uAJZiIKub7neW5nFT9VSRjlr/A14KYPxSH3yVgm6QOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvC6vDr1IoYf8mWsYOnsye8TdRBVLbMbCqkKvwctd2ETFWqIWLuZ+dmTByXtPSxWe
	 +S6ECq0Q+CU52HAle1vK40HfWd3ymMh/W5lgE6RrP7ZKHYVcU7vLpHd0Zm5Lc1VNQh
	 B0vyK83KC3AEZcXOdW3x5Aeq9slnHd64PeXXuu+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0337/1005] HID: rmi: check report length before trimming sentinel bytes
Date: Wed,  4 Nov 2026 16:01:10 -0500
Message-ID: <20261104211053.393328875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28a3e326fad2451bdb66b747dd1f7ccbb900eed6 ]

rmi_check_sanity() trims trailing 0xff sentinel bytes, but its loop
reads data[valid_size - 1] before checking that valid_size is non-zero.

Reverse the condition so the length is proved before the last byte is
inspected.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index d55a0388895fb..ecc19387f6b05 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -386,7 +386,7 @@ static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
 	 * such reports here.
 	 */
 
-	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
+	while (valid_size > 0 && data[valid_size - 1] == 0xff)
 		valid_size--;
 
 	return valid_size;
-- 
2.53.0



