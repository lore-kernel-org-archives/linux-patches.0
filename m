Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024517;
	b=d+lxAvzH5anEwM4yMawMD9y8LtJIQLVF0FBoBQTcNY7ZaZFA4uXirdA9kfJZKr2GxW9q
	 E/bTQq+8TRFF+LXJSf5KbHExI+dHk92SDXKsLZ8uvnavvK/dTUuWmsr9SrsKJbm1C0Lrl
	 /KmaIxNNcsi8xt08BnLndmALn8EZwWHt31daro4VN7d/KUR2/wFSlV86OQwpYuQTzGOaC
	 TQLfeXGlamaiszEQ/c8Hyfr3OkYUWZLhISppSTUbS2h23bdEkyF4bso65MHlgwrvnGaoK
	 TaZQKpATEvgT21wThJsfYH5CdfqZwhCii4IHzWjdXGgZdUof3sD8EDhBlJLT4Qf0A6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iWU2Mt4mhr1cZ5q61eamAOlaOpdIOj6F4ANiA79YnlU=;
	b=LuZzExfdD+lK5o8tRTz0QcJSIHaonUEHlNbYUgxuDrXSXqjdBtaF8i9rjJdowh7/Kkxo
	 Sc1ELtIBCnOxTHM1HvCykrgGBOSHEb79h+nwhH3B2Sx1sQ4ZjyZoiXP8yIr1CaO/ajPF0
	 uGLqqnxuA5y/vUPq2JtWK8UbyB7nWs3jaHjhvtOryzqV/Pve8ENYg5tBv0P0sOntU03J6
	 FolXRvcQCk1tlrVG43m20SeHLoxpWEctOeQvbm98o7xDgHz58cneZbpPUtwIRwdtym+uM
	 fXB8MFTufkVRBmV9y7sQJjmT8wD56WKTftWPMI/wD/+5v7cliDWDuAUqCbWObgsnDgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1vkx9bQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1371F606A320;
	Wed, 18 Nov 2026 17:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j1vkx9bQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6772B1F000C7;
	Wed, 18 Nov 2026 17:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024516;
	bh=iWU2Mt4mhr1cZ5q61eamAOlaOpdIOj6F4ANiA79YnlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1vkx9bQTuWhqdMDhicgD1Rm7B9SIkPkcDHh0unAL3LY9n1l2E6IkcpChBQU4y63C
	 J2CKDjceRLTv4lYz2wBIFkhUQl256UnNToNhwf5lTftgt1tZb9jfrbnY2JJ1QorJYh
	 +lOxnC4WaLAChpN3OxpUuF9y7+relEvznqcrg8ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0753/2151] x86/fpu: Fix potential underflow in xstate_calculate_size()
Date: Wed, 18 Nov 2026 15:41:28 +0100
Message-ID: <20261118150149.469378326@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Vagin <avagin@google.com>

[ Upstream commit f1751b220bc8a9bd2dc38ecf61f5c29f3826ace0 ]

xstate_calculate_size() calculates the size required for a given set of
xfeatures. It determines the topmost feature by finding the most
significant bit in xfeatures using fls64(xfeatures) - 1.

If xfeatures is 0, fls64(0) returns 0, and topmost becomes -1.
Previously, topmost was unsigned int, so -1 underflowed to UINT_MAX.
This caused the subsequent check `topmost <= XFEATURE_SSE` to fail, and
the code proceeded to access xstate arrays using topmost (UINT_MAX) as
an index, leading to an out-of-bounds access.

  [ bp: Remove text explaining what the patch does. ]

Fixes: d6d6d50f1e80 ("x86/fpu/xstate: Consolidate size calculations")
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>
Link: https://patch.msgid.link/20260925162454.1403405-6-avagin@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 5f54a207ace46..582f226ca97f5 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -588,12 +588,13 @@ static bool __init check_xstate_against_struct(int nr)
 
 static unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
 {
-	unsigned int topmost = fls64(xfeatures) -  1;
-	unsigned int offset, i;
+	unsigned int topmost, offset, i;
 
-	if (topmost <= XFEATURE_SSE)
+	if (!(xfeatures & ~XFEATURE_MASK_FPSSE))
 		return sizeof(struct xregs_state);
 
+	topmost = fls64(xfeatures) -  1;
+
 	if (compacted) {
 		offset = xfeature_get_offset(xfeatures, topmost);
 	} else {
-- 
2.53.0



