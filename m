Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057734;
	b=jUlE39FJbX+DR7vqpxKHMHuSmkjBjneXFKtSOlQVwKEBbqg5AS7ADvGma+sWOd8sb4oQ
	 YD6Yo88+scPpF2b8/qq06aVgUB0KuP52ErefF44pQVQr37FJDWoIx3t6sFCtL2SuBwKE4
	 NwXP+dGQM62GWTSUoo45bZjcTn16I843RnHe3XO4TD5biTVe23keTwkcXeEOsEUG+oQyd
	 94bIqkbhJexUuSZdZPK4XhcJo+NGZJcDc4OwfxAy2N1HBDxzJGXJ7ZlCX/oF4fRMcFgaj
	 sbkJMimbMn9p3wCq3rblFwtIt6cd/Cv47OdNlc9jwGeehvWflIgAJps7ZA9mBcpzXGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iR0Z0muvwOGHcphHxoXPwwRF+clRJ3I64BzatJQGuXM=;
	b=QNYpR3FE1eCNE2FTw2W7Ew1+QTjCemwAmiyMjijD0jBzG2l8Yqzyk3kK5XJp3+y7hjOh
	 nUxds2S8T4sIa2O4JfxVWIzcE2YfLBA2rVu5fgtjsVRd/ifuFap8f/qOQcUNTd4YVyW6x
	 90MAp/ESjnQ5DwWMi1U62pNWC+WzgrM5ixZDmhPvuWVuh8kPBFMdUR44jYqN1awDuEXwi
	 BEixN/DdF7frVKXF6YvkERPnDq5+Q5W80CuRFxEXUb/ZMUIaKHDTFLSzRjt4cju95dQgF
	 iO+6i/sjzp9OtRHNiL37p5U+tbimfywWDT6X2TIOYxs9BM0cyvbSSWiGAzqMnjbZuPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnkc5uDu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33666606A320;
	Thu, 19 Nov 2026 03:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qnkc5uDu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161C11F000C4;
	Thu, 19 Nov 2026 03:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057733;
	bh=iR0Z0muvwOGHcphHxoXPwwRF+clRJ3I64BzatJQGuXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnkc5uDu76SCeRGpmunRQ8zv7F/Kpz76uJ87bojZ7ZaDvVY8qf1pOa++B5dGcrB+j
	 UznVvIXZLXLvdLLGjyRmqUZBpcvVm49xeIbK9eIhYhqUFCnAxCtdqxM/zXbZ2w+bHw
	 L61jjC8o1GPmWFvqnOrVVKZGncElTEnJz+XWtTnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0236/1848] x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap
Date: Wed, 18 Nov 2026 15:37:54 +0100
Message-ID: <20261118145921.824497615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fd91c301218d5..854aaf390b262 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -405,6 +405,7 @@ void native_tss_update_io_bitmap(void)
 		if (WARN_ON_ONCE(!iobm)) {
 			clear_thread_flag(TIF_IO_BITMAP);
 			native_tss_invalidate_io_bitmap();
+			return;
 		}
 
 		/*
-- 
2.53.0



