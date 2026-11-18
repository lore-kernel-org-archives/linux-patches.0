Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044322;
	b=BdllshxbjcXUiRy+/+8OIk8mSYl2uVqx5zZuJg4+O3xTGxHRvUn4PujEfeJkB9QxEzjk
	 EgRdDQzdaxh+9Wrqe5p3sQC401THtWmmli3b3unPPAXuTf/1TZ5vmuc3WdI5Cy4epE3Q9
	 TQMWdXOFiBVXxFSP+K9S/nQXbT/lae6M8/QjoyQWCKhDfKbNvO8pfSISEyxyDX26ChFCC
	 n3jkDRLuVMUmU1XQN9emVYoiFmdt1okwRA4WHEBiIJsMvBV+moTdLHX/KTtpPRQJYKWGI
	 +0OGZqyWSjraSkz9g/ZwZUXo59kLY/R3iBg0nagiZeBZerN7gmTneybxZGQgdaJCWSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SwADFK9wD5/WyzNmTMriFA0mJnSWSRfZo8K/ALvVf5A=;
	b=wEu09UT9mN4Gi88lPE1CU1Jr39+oHpqN2OnvizllKlj7++HyWWEMgZJgPhkYIY1926x8
	 zt7zRRrQDyDO+oh1S9UDP2nkuAxBWfGskNjbTlayAXbOjxBSAZuAH/Yvk6J0N/eRWg/1s
	 nVpJdesEeo96D/nwwoh+y0riEgGf4RzkP6AizKpKpfyJlPonaX31xCHeK9t/hWew4xNUI
	 0qB4x/ObfmUVZJzWbCog6vczmnndsq3f1owxTufywD8IKPUiY857Y9fd9ZAUc02EI6xWU
	 EKi0tWHeS61XrdkmulBbpDu3GBEQFi8IWBGws3u5w32shlDYIIPJ8+DGUG3PQ+quOeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWuA2nTA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8D6606A31C;
	Wed, 18 Nov 2026 23:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GWuA2nTA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3550C1F000C4;
	Wed, 18 Nov 2026 23:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044322;
	bh=SwADFK9wD5/WyzNmTMriFA0mJnSWSRfZo8K/ALvVf5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWuA2nTAciC7s6Gd+IIOYIz7K4csuUH14syhenxXL2EX14jDRfaawvingHymfDEFL
	 FFQ/oqgWXdF8cuDyPzYV8yL1gM1xbnBNpj5Ian0n9VI39ykxUd9ww4QYkw9lARgXg8
	 5Hb1tNQaFr48TplIxvQg4XQ1hS6Ozkd0JwOvjL/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0527/2857] x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap
Date: Wed, 18 Nov 2026 15:26:01 +0100
Message-ID: <20261118150220.443825142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 1138b999cb14b..414fa24713971 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -432,6 +432,7 @@ void native_tss_update_io_bitmap(void)
 		if (WARN_ON_ONCE(!iobm)) {
 			clear_thread_flag(TIF_IO_BITMAP);
 			native_tss_invalidate_io_bitmap();
+			return;
 		}
 
 		/*
-- 
2.53.0



