Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591582;
	b=qO9mPywOkmaPpK1+6GwcCt7UOCZqVjLNi3RxXy1BWssfMQVb5PdEeZ2eUWGjUgF/uOzL
	 UFkyqOV/9wjQLJNPVvSJ5V9jqpnpOWoAzOzXt1aDUuPAPCFqeWZL+7ogmG4TPRze5kjMQ
	 uZskqk6l9FXxCsPMNqkbCYcJD7RqVUkcXHhmXfy+dFzL54QtjTmVbPXh3Oq88HJ17NgMC
	 8kVmV7twu/KjecLL2aFNz1g3GxchlAzWws5NQ/2+1QRX4yOp8FB77PyVctcX4yU0xFNB6
	 qt2L+uz3t/0kCuBFwbbkjDofzHu3sWxrZwZUbwygNvEKkuV3PklfxXs1ze9dcZU3lkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Th7MRzIyWnZHMtlKePxLOlEjLb+fcFJKRdM+8Bebdv0=;
	b=mIHJaCt5QVKFhXJ4VEKE3HrbHSWT1Ni/QapzftcqfRzO5VdOGVdve0rfVDIXYQdt84nk
	 Jvwe5CiUEX4t3nkNT8j7gsqEKmxoifxEARcMWTHMrsechiKG9/1sdcrbvzxvZQ7D/xXk4
	 ZyaKDhJ55XciWAKmI2I+ClF4bm8tS4tTZFQR2+OLwPiOWGopDZaKl8kIbK2S1wPPN2lN1
	 wYBQhDhvgCu2KT/Y5inMibFeX87w+K2bY76qQntf5ggsSMd1gtyVCi6zgHTZ30X5Hx5w4
	 LGIOLCPtmyRwRrnVx5jtD4nPbcmeCRUazCX24hrgTRRoIGhO+vs7ljUPEvgO2HBvVBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zk4kIZIY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5932C606E65F;
	Fri, 13 Nov 2026 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zk4kIZIY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8331F000C4;
	Fri, 13 Nov 2026 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591582;
	bh=Th7MRzIyWnZHMtlKePxLOlEjLb+fcFJKRdM+8Bebdv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zk4kIZIYoJgtJ7cOTpXW0xv+irBQB3mrllb8GpJBUQEyI/YU37O9IXZsrjBBD155W
	 2z9Ux3qgfmx/0TCUedS2ruFWioqAPuyB+vxD14c7RjI8DamXXReZO4tOcszGjxn6dL
	 /btrinl9VMtpjswi9+6sJB+dIiK4wI1OFg3ZBGe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sravan Kumar Gundu <sravankumarlpu@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 629/670] kernel/panic.c: format kernel-doc comments
Date: Fri, 13 Nov 2026 10:53:13 -0500
Message-ID: <20261113153833.107297264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Sravan Kumar Gundu <sravankumarlpu@gmail.com>

[ Upstream commit 85915c6cabf74d1f693fd09d95c25d838b82c840 ]

kernel-doc function comment don't follows documentation commenting style
misinterpreting arguments description with function description.

Please see latest docs generated before applying this patch
https://docs.kernel.org/driver-api/basics.html#c.panic

Link: https://lkml.kernel.org/r/20250516174031.2937-1-sravankumarlpu@gmail.com
Signed-off-by: Sravan Kumar Gundu <sravankumarlpu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ed9e4c1ff15d ("panic: restore variable arguments to nmi_panic()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 16c21189c8da9..d5307a8e89283 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -325,12 +325,10 @@ static void panic_other_cpus_shutdown(bool crash_kexec)
 }
 
 /**
- *	panic - halt the system
- *	@fmt: The text string to print
+ * panic - halt the system
+ * @fmt: The text string to print
  *
- *	Display a message, then perform cleanups.
- *
- *	This function never returns.
+ * Display a message, then perform cleanups. This function never returns.
  */
 void panic(const char *fmt, ...)
 {
-- 
2.53.0



