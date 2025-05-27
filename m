Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AEF27F728;
	Tue, 27 May 2025 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366616; cv=none; b=JnIKwEYm26Iz9yqmAlVo0ESJ++jBpu9Zl9VOFfPGe8ovbyg3sT55XWJySq0TnLfjn+puF7/uYruL+Z/XI8cEJXxuyeX7hUCALLqADy1/5bUghACPLwggREVoUIt4NlweAX8DlGmEaEzsAHkfxrAcZff3xRU7E+p5TqqN2zWFLQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366616; c=relaxed/simple;
	bh=JskjHpO9JdUS/3pPq5IOPL6WgNbVEzMgXLHBeNBIFqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcDwAWDM1wQ0epZLtrxLa6NLnOyfRiBmKr7LvPggCsddMK28aMOT61Ly5SdzPqac7jytpRuFPhHUgSDVgTG9y4kTfVLk+ANKXyj72NWKrw1L3GRwlxaRiX4xsYmaEzoiVbVoPJ+wSqOHNLa+Nnu13RVE+A1GuYwo1RIkGm41tqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvCf8+kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvCf8+kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FF1C4CEE9;
	Tue, 27 May 2025 17:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366615;
	bh=JskjHpO9JdUS/3pPq5IOPL6WgNbVEzMgXLHBeNBIFqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvCf8+kPuq79kAeX5cMKXS6fcArhlb2CAjXVfo/4Qb3oJqc79HNkddwQUUtgd+ano
	 gRxs1La2ney1OdURh2VX0LTx4AgF0DxMxHCe3IrxwvPjIjN9dC6eNroHrX2yBEDCXi
	 w/k6BCIbyimEYxK1woHyFhXwllXimDZUHRShpn68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Brian Gerst <brgerst@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 126/783] x86/stackprotector/64: Only export __ref_stack_chk_guard on CONFIG_SMP
Date: Tue, 27 May 2025 18:18:43 +0200
Message-ID: <20250527162518.279797621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit 91d5451d97ce35cbd510277fa3b7abf9caa4e34d ]

The __ref_stack_chk_guard symbol doesn't exist on UP:

  <stdin>:4:15: error: ‘__ref_stack_chk_guard’ undeclared here (not in a function)

Fix the #ifdef around the entry.S export.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Uros Bizjak <ubizjak@gmail.com>
Link: https://lore.kernel.org/r/20250123190747.745588-8-brgerst@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/entry/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 58e3124ee2b42..5b96249734ada 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -63,7 +63,7 @@ THUNK warn_thunk_thunk, __warn_thunk
  * entirely in the C code, and use an alias emitted by the linker script
  * instead.
  */
-#ifdef CONFIG_STACKPROTECTOR
+#if defined(CONFIG_STACKPROTECTOR) && defined(CONFIG_SMP)
 EXPORT_SYMBOL(__ref_stack_chk_guard);
 #endif
 #endif
-- 
2.39.5



