Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017524;
	b=mNHcgp4/LBn3dT08YTg0XIbutfM+9+coawh3n7tI5DqVb8V/SACRMwq0nGIbQRcM9ywS
	 2Q8V7wrtyFZShIgSs87mQMyo7E9RFZU6IuM+eBRPJARuiQ5cyjagCHA+rInBasMlpJUZD
	 ChEyZNtbdWSXrknGSlnBb7TDu88CqIpGPH9gBNU5368CuZFrcdXuNKXi8BLbwCSiUTrch
	 Vbp799Xr8lRhiol6vrGYz7/14knrZAODAS0r1E4Kbp0GwdPR4jzG94SFxPvIa5/nM58Rn
	 fsP6bQXOrMDRczeQQLP4V2IzuIn6Y1B9O2ODb0lit9b5x8DDdajhcoYWaIcieI+Eyjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NfzPP/7nxTS7vuG6z9cE7SZrvlbkr9k2UNVkvxrNCb0=;
	b=dPhGjmXJ2DOopE2caSuOjBUllzPMNaVACcAruHycNzcaqvFVl2OYP2LDZo2Mz6v45RGf
	 AHnilPW7ORoVEQaYfp6zSDOdMLxXQjccPPFHYV5Vn0A0RohoAlp+FOHrbZFPgzJJl6iUp
	 4SXDIyx4YcgZqFXQ5wcu7+YPQit8qCDxls4YIZvsempMUidDCtXI69GKuxkbuYpFu+A7O
	 NE/YQDkAq512K8Ug2yzu7OT076eC1QEcsAXVN7DJPvYdv9eCpRRYLJUy2NxbgXpvmVSKh
	 +jEolShPc1k/JUrCJqgZUixEFLU47JcFJ3gH/aR1DnEmpCw9sTLBopm2An80BlYcZpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1BFEklY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8595F606A31C;
	Wed, 18 Nov 2026 15:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1BFEklY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75CB1F000C5;
	Wed, 18 Nov 2026 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017524;
	bh=NfzPP/7nxTS7vuG6z9cE7SZrvlbkr9k2UNVkvxrNCb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1BFEklYGg6ESurLVDYuwWfb7LkuyV8bpY39NkbKHnbt55s/rxh8RGtHFddRusefj
	 Oi/lACn2ViKHcjrzsBkgHyntbYptlPeCKu8gGLRJ8CnPw5jlirxbDF300IKEwnIf3y
	 C43Y6ehzRzI60MtuXArE3PMEUiLehGuDrEGDtQRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0874/2651] x86/fpu: Fix potential underflow in xstate_calculate_size()
Date: Wed, 18 Nov 2026 15:35:14 +0100
Message-ID: <20261118150319.317412439@linuxfoundation.org>
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
index a7b6524a9dea2..fe0a29f599d2e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -589,12 +589,13 @@ static bool __init check_xstate_against_struct(int nr)
 
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



