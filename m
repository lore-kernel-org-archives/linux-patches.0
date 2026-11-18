Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051666;
	b=dcP1d4GWoklwhSDcDBMGWYLPJ+4fOwHrYOIAErzgosregfg9Crhkjh/EvYLEheoK4Ckm
	 wyU9thfaqGrsH1aqXeaTEkkIwjPQ8Zb0y4I8DOh3EcxcsYB457pJF02I+e3XLOFjalSi2
	 I7mzlunNwUQUEI4pLsNeyknJSna6xVUlQkobnFxLNCooSNoO2J7amOZNtD6ZrOVFcr8Ui
	 3l5vuPhackjW1BP5wnM1x1Au6I9sX7nkZ53X2nfZCsp84Anns0537a0Bt9nmL+lur5BBR
	 MckmPh5xOJeG7ZgqjBoSAULbsBru1BiZKcW1WnE+xTFPB6L5R0N/gWLx9dNRXlJq7Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ri7GIUMFIo7a6y13yspriEx9bg5dr+eKBjGbEcYDdyI=;
	b=2nxtEBYTxd32sSo/a8dSB3rQyul/EVN6HRBTqqm/IbOGFOZnTgfAWRWF3kpFsx0NdbMp
	 67qhxt/APBCNeH/DT7kTqdbfV46iEp3BK3lu3Kw7EouUiPK6raYYqpCZ8cmF+jHU5n8Rh
	 qSOwdroN/oAoVQXZTlwKWCy+dtYCE7DpadBUi0wtPKcsvAF3m7WfsTxCH0c88eT2IHPAz
	 9ffw65MtsUCfinZzkXMtN2hRi5hBAd9YFBDaoBtkIN8T7/IhXRmKrzQuud8xLXgpaa7+z
	 IAMBZif8Vwx0xOHzCcjgcKRRxuruBB2usefcMoG+WzFteZrs4nlGBIkVSLo2fEdRhAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzAiLoHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235CB606A32C;
	Thu, 19 Nov 2026 01:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzAiLoHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E441F000C4;
	Thu, 19 Nov 2026 01:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051666;
	bh=ri7GIUMFIo7a6y13yspriEx9bg5dr+eKBjGbEcYDdyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzAiLoHAJGXX1jleTVaIYNfnvHlJhyarVUasexGLftlfjKwIqfCRYPNt2d2k9bicb
	 /7dfCoIQwn8L3tf0PIaqEcJmbMAkELWZKoTNBcFT8lQHcWPhaJPSsh/6jiKUlQQGzh
	 Z3RhxATK2sYZHCH9RJrqgZ/THlBO3q5b0Tv6FH7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0288/2214] x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap
Date: Wed, 18 Nov 2026 15:32:44 +0100
Message-ID: <20261118150021.569482823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2a4218deddd24..f9ad4b29f7be8 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -417,6 +417,7 @@ void native_tss_update_io_bitmap(void)
 		if (WARN_ON_ONCE(!iobm)) {
 			clear_thread_flag(TIF_IO_BITMAP);
 			native_tss_invalidate_io_bitmap();
+			return;
 		}
 
 		/*
-- 
2.53.0



