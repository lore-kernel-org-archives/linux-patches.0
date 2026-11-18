Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017842;
	b=DCV79mwOJOuGWWD/+v+uIUa0vrdfpgBaeMm5FYlZ3u+Ru0XNKubn3vUZ6aUPhT/2jz3A
	 XQfk4g9GPQhjQe5vs/cjfjZEFR8L2ybswIpEZYSZx5f95MyP5d+GKt4/RVwNo0G6gXvSU
	 LEr4tylPvf3XhuGrC5jryfBASo4sH6v+m+cPcyTblvgNe0x6gQfxb3JzcUP0FFTvD0Cug
	 mLcRXiAMaF8S8aX9XhISG0DKhdu1gFbu0kaHgWvp49dHIdI0lJxETx5pgR9ZrWvTBzFix
	 CU/IrSpzu2JtRfX0if4G7zjcbqqSc7inZb5rvfyfnqk8UrlraA/5Q35EKdbh9z2+c1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DDF6TJrmPub74mAuerYJ1e5E67d1bDLFFG0kkTEZXzY=;
	b=PpKzmUSt/e+X2bZW3c3icylyx9Wg4iEfpo7M8Hmwaz6v7p1rdg01eQkE1CIbfZBorjI2
	 ehPl4yHjeS9Tmkg1yYpfhRT3N66Q7vKHPX090q/CXHGR/iNnAFvP//5LX177uUC8z7o+m
	 kP/lxWFeEiPKo6/uznLhVUJqOsDgnERxCyWB2EaxVrAj2zBrN8sN5lr/V9XiohMt6yTFf
	 ZVmITrTOMwnTEXEKgDNVBL+vku5U8siOvCOfk5kuojXE3LkndYvnZMa9NpjkBr/6rwgBr
	 tiNZqrUcdPBuaVZgHBRmnA+d+m3cPdo+d6IBUHiSu9RJtO6lEftvhv/C685eivlXaeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0Eiy4ss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F34E606A31C;
	Wed, 18 Nov 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0Eiy4ss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854971F000C4;
	Wed, 18 Nov 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017842;
	bh=DDF6TJrmPub74mAuerYJ1e5E67d1bDLFFG0kkTEZXzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0Eiy4ssXVenqGwkaNTiZmuHHFe7WMct5sIkXsa9rRmVPGXdHknHx5oQJu9b5pqbo
	 AkhLFOEuxmjLSULfT4wiTieTwExax7CXlXGLKy9xWRvpLs/Qinth3aVK8K5elhLqhR
	 tuJJq1a0BeLOasElRQ0w7IbAbd99xto05GZIMvLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1027/2651] pwm: Allow 32-bit tasks to use the character device
Date: Wed, 18 Nov 2026 15:37:47 +0100
Message-ID: <20261118150324.934536673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2a050ff4608bf..4c6d716e5fde1 100644
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



