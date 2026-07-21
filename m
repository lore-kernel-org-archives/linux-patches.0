Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B0746A612;
	Tue, 21 Jul 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649314; cv=none; b=m6piXOa6c3uI0Qm+95AkM1MTteKczpo8t8+CNoljvvdIAA0y1XNsnA1wczq9W+Y2pK+G+UZcUOjUipr7aWMOm5bUXuBOZelg3UfKNRox4Wn11spiQBEDTVRVMony0/dL+KnsUTbGEHFz22m7BtlKhS63BbcsPjEkxoCltSnLTJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649314; c=relaxed/simple;
	bh=0ytwS39vD+tq35V8j7Qy9JQH3bXVvmJYBRkXOBlnGGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fW5/BtHRTNTZTPIiOJCSJiktupwYVCFJc8Oyhe8cALgujRQgdE1H8Hjo5yTGlJ2SiuLkEmloEPLbE2L4dspAN4JqdWj0UaXIAb89GoVvFgJ7NGoSq4IPnaVS+p+f+alAordQMyhHU7y9VjSpGj+FUpmguQHKyaLGsXw/bo1dL3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW3kBJun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW3kBJun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAF71F000E9;
	Tue, 21 Jul 2026 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649313;
	bh=9DAsfLsqCd/9TYEffxQ7KHusBqYXof+wZ1Q1xfaW4to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nW3kBJunQK2Kt7F5UKbD/uM8gZVwYfw260klz9JSdqEqswMzbRZwC9dW1DKH9PG9F
	 h5ZcIuDm1vgMbBSN1eYmJ05J5H4qkbjfRVQNO6cYYdV5y6dREyG9o5e+L/+/cIwP76
	 yDflO5fLgdqF1W8SosQql+fRZVtEfbpOL7AUQX7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0530/2077] riscv: alternative: Also patch the CFI vDSO
Date: Tue, 21 Jul 2026 17:03:23 +0200
Message-ID: <20260721152605.305601986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit d3e0634787a234b40a740b9c398fd320a68db81c ]

The dedicated vDSO for CFI-enabled userspace can also contain
alternative entries.

Patch those, too.

Fixes: ccad8c1336b6 ("arch/riscv: add dual vdso creation logic and select vdso based on hw")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260504-riscv-cfi-vdso-alternative-v1-4-bcdf3d37f62e@linutronix.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/alternative.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 89c283a5cec7ff..104dc0862c5c2e 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -205,6 +205,9 @@ void __init apply_boot_alternatives(void)
 
 	if (IS_ENABLED(CONFIG_MMU))
 		apply_vdso_alternatives(vdso_start);
+
+	if (IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		apply_vdso_alternatives(vdso_cfi_start);
 }
 
 /*
-- 
2.53.0



