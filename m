Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016615;
	b=h6U3CeanJFSlQckQO8+HKec7AObZ6RR7MZkBNRdmsYOJkZ/foyAmoDg3XyxhSm8ZzVog
	 4Oaf1fja9O99YTQQhEPxuvqy+qf+/19QkITn6sBzJxGgX2Cu5uFHB8D4Vyq/oKYDBMlZV
	 x+lIiJxaueaZF54udFP9fh67ztybguFDLvE2AvPdou3mflcoP1SZ5NKxwoK5024ORgsWv
	 6emzyecstUyhFBvx9uU5DkxP/xjmivjOzXr+Xhg5HcSM+al8zL2tu1qim+U4STbauFqXl
	 5PEgY7+0lx1fiU5kMgI5VzOcabBuG9aM9AB3lbmooylt2xyIuVwSXJJCKfgO2rfZkUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5EJ0pkTeRjSQ/dzsP2mnVgMYJ/VVaVmYCBXrr2KKnLM=;
	b=bw2CN+A8FH0XITBJV40tzny7MxmJx+r9MnPs/yIGsGYDzrYu7tyb9HuEp/yoY8wjRJ18
	 aH8BJmOzHAexUcqreJAMlanJnIYM0fCFtcW1AN7U4y/+T64jJ0xlTs1Eyr8UfjLUykh7E
	 1QVy2Z2XJ0u/OYAXZnPIL9neZ25jkGAJkuVq7D2q/yWO/b0CB6VyS4QuJIJbtpY1pVNh+
	 PbMBeAiBicLmzvtDMSZYIyqUbS2jwBBgIQX26QzgTlr/1GTGYOyZ7r/ymPOS2vPghaZcf
	 O8cau8DzcE6tKRsA3LncVD4gVrzY+0ahy1I1WGuzUwm5d5kKdmOUrOlB7rfcquGrfXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FsoMbv7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A53606A31C;
	Wed, 18 Nov 2026 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FsoMbv7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD261F000C4;
	Wed, 18 Nov 2026 15:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016614;
	bh=5EJ0pkTeRjSQ/dzsP2mnVgMYJ/VVaVmYCBXrr2KKnLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FsoMbv7dILv9rXsR1OSBkCQoJOzLyD6APM4E+PwftHUD2aTFixsH/p5jFN54hENt
	 IIs4ubiu4XVhx1Z9YpFl0CG7Sd9YgkikdcxNaPje8okPR5X0XukHUi5ZFpMwQNOFyn
	 Mi0cP5o0NIeSGllwx+1kZkZiTyOqntMG4m/60j8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0590/2651] driver core: Add conditional guard support for device_trylock()
Date: Wed, 18 Nov 2026 15:30:30 +0100
Message-ID: <20261118150308.961009675@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 18f26958544783b0f30210c41fc0c0da11b8d9a4 ]

Introduce a conditional guard version of device_trylock() for scenarios
that must not block on the device lock. device_trylock() returns 1 on
success like mutex_trylock(), so the default binary condition applies and
ACQUIRE_ERR() reports -EBUSY on contention.

Suggested-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260916025453.3532614-2-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 391bc7ab9be6 ("cxl/memdev: Fix deadlock between poison debugfs and cxl_mem unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/device.h b/include/linux/device.h
index ae05205742c05..87532f3621539 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1126,6 +1126,7 @@ static inline void device_unlock(struct device *dev)
 
 DEFINE_GUARD(device, struct device *, device_lock(_T), device_unlock(_T))
 DEFINE_GUARD_COND(device, _intr, device_lock_interruptible(_T), _RET == 0)
+DEFINE_GUARD_COND(device, _try, device_trylock(_T))
 
 static inline void device_lock_assert(struct device *dev)
 {
-- 
2.53.0



