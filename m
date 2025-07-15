Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F272B1991D2;
	Tue, 15 Jul 2025 13:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585649; cv=none; b=AhqT8itzyiZkWMSK1an0FQmaSM527vCAEpdAgsURUYZKiOhlwVYKD3X4cjLz1uKc9VjSKMQnEc+yW/Vdtm6VYvwqHht7nVTAdsE50YpDKV5I/NHQgZHLInvP8Tmv9z4kC2SBiOWsqOSTkO2qAnwXqm65+WGkfLo+kKjlb8PJ3Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585649; c=relaxed/simple;
	bh=znh1356U+UZlmJRQ4Nh/UCAHshl4ym2seo+bUtOItAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqMamkP7m7HbxJLQVYuYG6WbkKCAjusJo9pqS3CIOg/5E3E7Sbe9sPq0v03oXQ0hnZ3ROb5IaYgObobWPVtXH1CIM818toomrKSxneen6UHE4g9UQNbATfLJusvZHZ75QeBak+iOPsIaaGn3ujKTJgcn3cg823AhaDR92RaWdU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14QOeY4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14QOeY4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87124C4CEE3;
	Tue, 15 Jul 2025 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585648;
	bh=znh1356U+UZlmJRQ4Nh/UCAHshl4ym2seo+bUtOItAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14QOeY4xRT5NV0GmpZDB7yT+tJR3rCBSovVWdhBhJPbjq+kXVl1ZL4DtnA0fDkbaf
	 O+DSVwcIlwxVJR8doNpQUpjGTuCvEMdQg/Or4OjaPamwfSfvQ9igohhSIzv2m/zb+u
	 UNH264OmAv/SLg9bDFtM/A0XRM79dZbcfFBZhMg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 089/163] scripts/gdb: fix interrupts display after MCP on x86
Date: Tue, 15 Jul 2025 15:12:37 +0200
Message-ID: <20250715130812.445852914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 7627b459aa0737bdd62a8591a1481cda467f20e3 upstream.

The text line would not be appended to as it should have, it should have
been a '+=' but ended up being a '==', fix that.

Link: https://lkml.kernel.org/r/20250623164153.746359-1-florian.fainelli@broadcom.com
Fixes: b0969d7687a7 ("scripts/gdb: print interrupts")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/interrupts.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/interrupts.py
+++ b/scripts/gdb/linux/interrupts.py
@@ -142,7 +142,7 @@ def x86_show_interupts(prec):
 
     if constants.LX_CONFIG_X86_MCE:
         text += x86_show_mce(prec, "&mce_exception_count", "MCE", "Machine check exceptions")
-        text == x86_show_mce(prec, "&mce_poll_count", "MCP", "Machine check polls")
+        text += x86_show_mce(prec, "&mce_poll_count", "MCP", "Machine check polls")
 
     text += show_irq_err_count(prec)
 


