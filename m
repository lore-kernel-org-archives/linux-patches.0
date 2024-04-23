Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADD81420BE;
	Tue, 23 Apr 2024 21:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908701; cv=none; b=qpYAQ9MyvjTMPS6kXV8MsELvz88fnHe2RqqhicAwTNDCTZR0YCfZVpoAVZs9MfXsEuq0ZUNxeKAfugE9IrJVjXSGWAM1a3il8u3WEUKSXfQn/qm1g+iFMzna/hjoJJzJAATLde+RJtqndz/uY9p6yFKCCPsEM1oKXH8qub+HpVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908701; c=relaxed/simple;
	bh=E/R1dS2whryx+4FPwD4MYQHUoHerC/6YcGENFwFHJrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0cUgvfGZM/ZwzcWhwGfI1/+xc3w0xiKXYzBo0kVcwiUKu7lhImWm4/5eVg2MGxkTVNW08BuVtbvItH4OKw89u4cI+W3/ln7cIIFuVBJuLOCPJXkbLYu3hQcuRTjK9uZMSz3WRGOh8Go4CfYO1XIzzie6AiK9eBK/LCyqeX/xSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymZ9CGqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymZ9CGqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E95C116B1;
	Tue, 23 Apr 2024 21:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908701;
	bh=E/R1dS2whryx+4FPwD4MYQHUoHerC/6YcGENFwFHJrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymZ9CGqOHhvL6zD0iDBI2amgZD7W2+bvx9h9M5B7aA/l5J9KMs0MXltgy4sDbCmuK
	 MEMqCceoEfrd4+VXeVUGNnlf9xlfbLyFm3XGgSesQVpqFZ2FKxahYfFAkYu9Y6rCua
	 GtH7dVLjvnzRM3o+6klvW2Rfh8yjG7SHwuxQu3Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 029/141] x86/head/64: Add missing __head annotation to startup_64_load_idt()
Date: Tue, 23 Apr 2024 14:38:17 -0700
Message-ID: <20240423213854.257272518@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Commit 7f6874eddd81cb2ed784642a7a4321671e158ffe upstream ]

This function is currently only used in the head code and is only called
from startup_64_setup_env(). Although it would be inlined by the
compiler, it would be better to mark it as __head too in case it doesn't.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/efcc5b5e18af880e415d884e072bf651c1fa7c34.1689130310.git.houwenlong.hwl@antgroup.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/head64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -588,7 +588,7 @@ static void set_bringup_idt_handler(gate
 }
 
 /* This runs while still in the direct mapping */
-static void startup_64_load_idt(unsigned long physbase)
+static void __head startup_64_load_idt(unsigned long physbase)
 {
 	struct desc_ptr *desc = fixup_pointer(&bringup_idt_descr, physbase);
 	gate_desc *idt = fixup_pointer(bringup_idt_table, physbase);


