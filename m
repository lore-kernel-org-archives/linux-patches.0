Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213255;
	b=Od+qIlEcQ6PghduiCCISBH5BseQXuBKaRGobMmzuAJp0VX6DAS7LszHHrAmOb3FuwXdk
	 DtKvkBQtwe0jQX342iMgC+Gvtb1FzSZpAbOi1jhOZR6hiYtbrE6niKLPp9kPbDk5i31JQ
	 CeA5zU7SbKR0bC/72XgfVzBuC3b8bftKi2JO63QvdslKSc3Mv0mxqf7i75zQ6731dMaXS
	 lkfMlMl53r3GruUPYl722Df2LbNjh3dV2cpWK3OBS1NH7v5k7lIpUJY8Kdp72+r1OfJKx
	 8pgVZb22d29+3F4GzYeucoRsnK/jt5+VSwI+Fv5MokmS9YNBJ3Zt0wKaP3xupwHg4Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=enpu/ZRkUMSx4pAfR4+vZepczs0RCkQJ6YWhIh36tko=;
	b=MqdIidyDbB1w8gOeWGYRAVp4L5HPIqAftHl+rbzCrFZoLraHx9ruCkUz4jTq8h0+X2Ah
	 shJuG8m+MPnNvMI7VF2+Q+feCWXtBLTzIPtc6g8Y9RCagW6M6ut5drhqi/yAciZ62iSEQ
	 CaSDUtpXT3YK8zt8XbdNHzJmS55ZCwqW6XLawNI7DCT3VDPPu4If0zUkMuqFCwjYuE9kJ
	 JFg71a/h5JbRPskOq7XbojDssiMZKMZl7q6Pv7UkJbf5XtIIgXM+b79ebDS126zL7o5Oi
	 x350Ywrmfv0rjqZhdzimMGXI4UseVQ55GwpVa4XM7rWjvfcUgYPjvRF4juiyf5P185g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnQlLIp2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA226606A31C;
	Wed, 28 Oct 2026 18:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnQlLIp2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DFC1F01828;
	Wed, 28 Oct 2026 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213254;
	bh=enpu/ZRkUMSx4pAfR4+vZepczs0RCkQJ6YWhIh36tko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnQlLIp2DHzIe37UMlke+Ykxc2anBbUexKh8MUmmSa37SRHCSbIOBMDi5v2x3n8BF
	 doNqVm83nQkc2kr0fzgPWWfFnWZTVPlpuSZl8j+rQLfHfyufbxueQ2cVNui10ViVGj
	 BxfoeaqlZr9SDKz3K+ybwE2O3LgxtgSFlOw1Ts98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0397/1887] USB: serial: report unsupported break signalling
Date: Wed, 28 Oct 2026 17:41:33 +0100
Message-ID: <20261028170508.268560628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c9d934053d9e850bc901b6425eacb5fe3d4b1738 ]

Instead of returning success when a driver does not support break
signalling, return an error to let user space know and to avoid waiting
when break is not supported.

Tested-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Stable-dep-of: ae0e61d95677 ("USB: serial: fix ioctl hangup race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/usb-serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index d0f9db08125e0..9ecc108c2d275 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -540,7 +540,7 @@ static int serial_break(struct tty_struct *tty, int break_state)
 	if (port->serial->type->break_ctl)
 		return port->serial->type->break_ctl(tty, break_state);
 
-	return 0;
+	return -ENOTTY;
 }
 
 static int serial_proc_show(struct seq_file *m, void *v)
-- 
2.53.0



