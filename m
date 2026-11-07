Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061510;
	b=ZKNh6QzJdA4mYQf8Xlfyvl+ROMUKwdphILkUvT1tGU4fKWOAvlBDnsBZOHTTBrj1YiS0
	 Z149pgpk+qvoMbIUB5c4g9dJZwaR4A9KsOt2qBWa6oLa1a2q7ZkuE/xZHDAmluB2eAvzx
	 RS1wCn3FQxIwBoi9uXYsBSZJOXNrwdTop5wMJnKjOpOxhvBGcUtsvNGcNEU83vVX3m0vv
	 mXrSdbSd8Io8cKJ/TDPWIF6E7bV7BsU3RwQB7TszQjcTtmQ4bu0HEdcL+jDi+ejf0pLRd
	 Ny+Jnf8O86A45BE98ATxqbv9V2qClFQZA2c3+L8nQx3YYDgYXmhejpFdKs88YaCRDKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4dIDQFQT0cSqy2Dn80GSZXBkCF+N96zTpgXcME6TXRY=;
	b=xajlo93pfeFwiwsXSFXC+gqSDaep9fK2/YKSy5BLHYo1BSflQBVXzcPwuRZ9/LCtk6Mt
	 rhZgZfnswxgkHT3tk25VGQkidPqkIXeVofex8IiWFpWxacfq/7p0u0m/ST7BBdqt91I/c
	 al2VWSUn124w7UUDcdebBsbbGY8Ui/B/A0NC3IEuHDqGLrX23OgYYFLqIqFfiUzEJO9+N
	 pKnxtS4BDWJOGvbKZIbBqqdVmyLPW2g4LITcOj1o3l0tNw2atocvDxxpNsqpIBc4knrYq
	 P79KiYYPTTt75vpd+Wsc6wAZUw9F4KhXqegY8E6OcJOJKTXToIV/Dnm9SP8e3B4VsVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9nI8r90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0681F606A336;
	Sat,  7 Nov 2026 14:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9nI8r90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB301F0089F;
	Sat,  7 Nov 2026 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061509;
	bh=4dIDQFQT0cSqy2Dn80GSZXBkCF+N96zTpgXcME6TXRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9nI8r90jG3bepfsD2Tp61MG7mV1R0ig1dIoaAl6ShNERg3R144bfRKkLMtusBxym
	 oWB2eKELxRPEGxqSKuWQOglBRwxsj4UG7zmGZfwprrEUDHdXXptvxj2KMXHfxkXQ3p
	 D2jim8PdI77lbvy512pcIoURMXoIFKQZ+v2hRjGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0601/1536] x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap
Date: Sat,  7 Nov 2026 08:43:37 -0500
Message-ID: <20261107135014.423608508@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 2d36d3b451a94899db9c965adde15492ffe6027a ]

Outside the IOPL emulation path, the IO bitmap is always expected
to be allocated when TIF_IO_BITMAP is set. The paranoid WARN_ON_ONCE()
handles the case where the flag and the pointer got out of sync.
In this theoretical scenario, which presumes some other bug in the
code that triggers the WARN_ON_ONCe(), return early, instead of
continuing and dereferencing a NULL pointer.

[ mingo: Clarified the changelog. ]

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Link: https://patch.msgid.link/20260615070115.4720-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4c9c98c5deabd..c8d740fd86e96 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -472,6 +472,7 @@ void native_tss_update_io_bitmap(void)
 		if (WARN_ON_ONCE(!iobm)) {
 			clear_thread_flag(TIF_IO_BITMAP);
 			native_tss_invalidate_io_bitmap();
+			return;
 		}
 
 		/*
-- 
2.53.0



