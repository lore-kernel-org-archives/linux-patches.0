Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996972E3AF6;
	Tue, 15 Jul 2025 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585909; cv=none; b=XQEiU7BmpvFNM7VEV4EM5+Cj+DoHyCiqsoQWgysNHEgy37NodNuZVC4ng9wq5yytV9vFBDyvRNG9t8hTXGTYfcZ41H/C+qNZsosDdgtXTlYcPhIdEk6AEh7jrhHWc4Y/LztyA/56QF0p60M6hS5bNLrSMdoP/CK1Mh96nKn4myE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585909; c=relaxed/simple;
	bh=7uDUYGjKLBaIyv8zo15NUtKQxFlAS+r6YoyFtTEnOVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFv00HzyhtpVKMKXwIG35L78/iJhpO9grULMpkw1KFbRWX9mr93r1shVXEhOFAhWDPylEIwTN1mYVWzytFzTviZIcL8j7LmO9x+YGisgOlTIQ3Jhh3XARBIy+nNz4RrYJl+VBM3UMw6YXSE1SeH0BNpYV+xnow3vWhq60Y40ZBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPWjtXT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPWjtXT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E082C4CEE3;
	Tue, 15 Jul 2025 13:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585909;
	bh=7uDUYGjKLBaIyv8zo15NUtKQxFlAS+r6YoyFtTEnOVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPWjtXT0bgrjoz7ROw+XAWLv7zoC0pu6R4aQASBzvnFHQbJ0oycCTfumXBzBYK4Pv
	 iYrP6dyxMafUohkv+1RJi1KkGirNvveTJtcdnQB9FKD+lw0kgXhBtX+VlkjbtVDSJr
	 u5PvcjDBMGGLC323/P69U40ASK9Y+gBh6auXDA6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 054/109] scripts/gdb: fix interrupts display after MCP on x86
Date: Tue, 15 Jul 2025 15:13:10 +0200
Message-ID: <20250715130801.036181075@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 scripts/gdb/linux/interrupts.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/interrupts.py b/scripts/gdb/linux/interrupts.py
index 616a5f26377a..199d9e8193f4 100644
--- a/scripts/gdb/linux/interrupts.py
+++ b/scripts/gdb/linux/interrupts.py
@@ -142,7 +142,7 @@ def x86_show_interupts(prec):
 
     if constants.LX_CONFIG_X86_MCE:
         text += x86_show_mce(prec, "&mce_exception_count", "MCE", "Machine check exceptions")
-        text == x86_show_mce(prec, "&mce_poll_count", "MCP", "Machine check polls")
+        text += x86_show_mce(prec, "&mce_poll_count", "MCP", "Machine check polls")
 
     text += show_irq_err_count(prec)
 
-- 
2.50.1



