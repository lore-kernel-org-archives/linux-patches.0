Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064849;
	b=e7x8vjiZFvUgEj04pYBgkc2ClokGE+0t1UznoZvMqipcMcJ8QKz7d+sH4EyqRXgx0Den
	 4bOKV7IC3UFVZCVWQo8pUkHBEOQGaAaEh8HFHzEqt/Aafnd6pw6BF0kUNMGm15iqSN1sC
	 oP/uhqxCBd8BXoiTSobx+8HdylLbZHvuJz7J4HGBf/mzVAf50N1AZA+FAGGftXEDBr8/H
	 QpKFdQPMWiLGuS/4lbk/8fy5e1LJ4JaT0XwXyBS2XW2Qoxs5Mn0+ez9cemt2QjV5fWsSE
	 RVU6nnZDFX60jdDeaSKXs2sRsxnOtAD2fejLsmf6qVQFEhWmq2Stu7AxSpluIG8DkXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GraTGZecqusl9HbTmmmcnlcvR8cAFg4qn1L4Ch4Ow74=;
	b=10/rsLird/8Ng4Yy/ktyn1hfNDsnE5eiNL+LqAUefkzrOmlQkgBPVDUeAYtFhAAzKfCE
	 OjpDYfRA+oMkwqPHx4adKYp3wuDQ3ZRecozQfma2DTBQPLTMz00+jUaBHovWY3wO8ZQEV
	 UOYVcxmCMYPsfZbZBc64qk6o3440pzj/bjU+ZFpgU01yG8NtKPHKZcj93EEpCaiv1kTkn
	 ZzIOgOz4Z1e0CwhYkgiRLfoYR5C1vd2e3FxTcXHqN/ZBSMqyr1+E/ESUjh0zg/ZovDQqX
	 9YsJNZCDcylqNk28JjttK3vzJWEn9Yo3KyLFYPhSf7q0ZYTs8lI7oXh7OyzBWmZEoJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gieUjghu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97433606B8AD;
	Sat,  7 Nov 2026 15:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gieUjghu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAFA1F0089F;
	Sat,  7 Nov 2026 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064849;
	bh=GraTGZecqusl9HbTmmmcnlcvR8cAFg4qn1L4Ch4Ow74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gieUjghua12dIpQUwillUDhK4Lg9tdshvB77pNTQ3Ejrk5xBocdyZMqCxKn4yzjKp
	 YhaGAOQxgZbChaBN0wnzGlR7XL+s4+Rd+bB4V0uGMUiIB4eM6C/43Lw+y3B0I6RPxI
	 D8oWOjhNMZ1FQzbDtpfyHf6uvSvzOP3KnnnehGbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0773/1257] Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file
Date: Sat,  7 Nov 2026 08:51:09 -0500
Message-ID: <20261107135000.647711452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Bui Viet Dung <dungvn2345@gmail.com>

[ Upstream commit 8368f0c2cde48c09ed70644059f24172b0c59f52 ]

An open debugfs file retains lowpan_control_fops in the debugfs proxy
state. However, lowpan_control_fops has no .owner set to THIS_MODULE.
As a result, full_proxy_open_regular() calls fops_get() which succeeds
without taking a reference to the bluetooth_6lowpan module.

With CONFIG_BT_6LOWPAN=m, a userspace process can keep the debugfs file
descriptor for 6lowpan_control open across module unload
(delete_module / rmmod bluetooth_6lowpan). When the process subsequently
closes the file descriptor, full_proxy_release() accesses the already
freed and unmapped lowpan_control_fops table, causing a kernel page fault
or oops.

The issue was discovered via manual code audit of
net/bluetooth/6lowpan.c.

Set .owner = THIS_MODULE on lowpan_control_fops so that debugfs pins
the module until all open file descriptors have finished.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 30f4afa18bc8f..20fb20eea8e79 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1209,6 +1209,7 @@ static int lowpan_control_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lowpan_control_fops = {
+	.owner		= THIS_MODULE,
 	.open		= lowpan_control_open,
 	.read		= seq_read,
 	.write		= lowpan_control_write,
-- 
2.53.0



