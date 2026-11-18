Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024969;
	b=i0o6yoBeIXmR7kvG0KldJOZ+IyyjdL9HmOvk/OzddwU5SJUkMWx5XexDqBgRkitGeyxA
	 8Ra3rwHDYogyxQRkVo/gC/13Fb0nXNEYBFklq6lP7rpXCMXhG1xeXKOejr4qTCw/Ne1k7
	 7iak6e4hhx9OkGZdz6pHXTlIR26joHUxYY7fYsyVXBFAb1b0ZbOG6LkwIKNlCS6SYQEVW
	 fl5XL4Nde5/H46YlNeJ3Ei7va/AygGHpIr4JdaqXNMi5wSPZNHK7D4+n2upDrrjYcOZ37
	 VboCHCEm/Ms9DvHA3Io/nKhnT90jT1hwWvGIcpmYmXcxUoGzr0Dt4udMR3SpLwGSIMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PKm1ZogRg6Nqw/u/M2hOAvb7mEzu7ffeYutZZqASpE8=;
	b=r/SGt0NQavPwR2Sl2wnhvLEbPOuxNYb+6RgDv9GowUSHqxVEz0l9e2Uo9+UVoAiZ+NeU
	 it2vQ4ivsQZfM++9vlqHW7k+nSkQS7ppn6N8wYMItdIlaoIVp3xwJJ7JOkGV9/v6BkRsL
	 x6MCaugFjo4h6StJ0pDfN4INXzngbhUxs4/Vo/UCgtjbPv5E/3B7KgIZSlTRexbo9CN/C
	 3HPXYVPbXrq7GzLVMloRXu6Rpgc0hOM6gh1Hdn+YYYmd/CT2qN4HyTW/npgOve3fJwb2J
	 E1g9Y5gvBBh9+YAreu55CYitQdJfAb8eDods8yA43lvQtNkXYUp6JiyhmtCoaTL+QvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZQKsHbE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F4D606A337;
	Wed, 18 Nov 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZQKsHbE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927251F000C4;
	Wed, 18 Nov 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024969;
	bh=PKm1ZogRg6Nqw/u/M2hOAvb7mEzu7ffeYutZZqASpE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZQKsHbEP6yjO8d8eYn/JbqBsEDQJhI0OwM/l87g7v2O7k1/9/sg4HUkK2sJgUQ6K
	 MyYF0x4R9RxdPbLgP+PQDoSifnxL7lmxCV0aU3FpxD11Fn6HdfhCPsG+ca/cxy1bFp
	 oQOEzq6DM1YgZZjVqZX1ywCQyjiUlEnfZnWZOcSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0872/2151] pwm: Allow 32-bit tasks to use the character device
Date: Wed, 18 Nov 2026 15:43:27 +0100
Message-ID: <20261118150153.963712762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 45c3d07e3f18cff2b3ea8b797387451a3df9d421 ]

pwm_cdev_fileops has no .compat_ioctl, so every ioctl on /dev/pwmchipN
fails with -ENOTTY for 32-bit tasks on a 64-bit kernel, e.g. armhf
userspace on arm64.

struct pwmchip_waveform has the same layout for 32-bit and 64-bit tasks,
so compat_ptr_ioctl() is enough. PWM_IOCTL_REQUEST and PWM_IOCTL_FREE
take an integer rather than a pointer, which is fine too: compat_ptr()
only changed the value on s390, which dropped compat support in v6.19.

Fixes: 9c06f26ba5f5 ("pwm: Add support for pwmchip devices for faster and easier userspace access")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260928184422.380520-1-danishkhateeb03@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 462c91a034c8e..04af765e29926 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -2389,6 +2389,7 @@ static const struct file_operations pwm_cdev_fileops = {
 	.release = pwm_cdev_release,
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = pwm_cdev_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 };
 
 static dev_t pwm_devt;
-- 
2.53.0



