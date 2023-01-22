Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A694C2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDEBC433D2;
	Sun, 22 Jan 2023 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400867;
	bh=U36B0Gnx9VcWVoAFSaweXf9NMujQ6bmiBQAB5Y/K/ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6IxIRWabXg7px1leTsJTymD61ctocJwb6Ni3ngsBQPycPOSeDkGhiPiRJRItwieg
	 EOiNpXfFqUf51uuC5+ZHkOpsYAgIAOY2/0Pyi72GCF59aeSXgmm1C49I/YtfljOk7y
	 ghs8El6wnHUyewrlAP+Fj9Jw4vQuorMCY5K6mDZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/193] x86/asm: Fix an assembler warning with current binutils
Date: Sun, 22 Jan 2023 16:02:30 +0100
Message-Id: <20230122150247.319977587@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 55d235361fccef573990dfa5724ab453866e7816 ]

Fix a warning: "found `movsd'; assuming `movsl' was meant"

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/iomap_copy_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/iomap_copy_64.S b/arch/x86/lib/iomap_copy_64.S
index a1f9416bf67a..6ff2f56cb0f7 100644
--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -10,6 +10,6 @@
  */
 SYM_FUNC_START(__iowrite32_copy)
 	movl %edx,%ecx
-	rep movsd
+	rep movsl
 	RET
 SYM_FUNC_END(__iowrite32_copy)
-- 
2.35.1



