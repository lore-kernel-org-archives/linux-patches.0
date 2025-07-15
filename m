Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E242E2EFA;
	Tue, 15 Jul 2025 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585912; cv=none; b=YUwgkMB8gAI8iUFeBcF/0m9UknvJOSRLTwmKYtoWa7zTjpWGLo5Z3j4RoS2OKd9SOPAyVk2EGB69tgX1VW78uvZuVwvlXuMWiNkgr721eJPWFuKy5FWmlytlFS+ftFUJ4DwOkqyYTxeGsFGUPDlyZsJFVRRmZ9jmRxAwTTu6dIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585912; c=relaxed/simple;
	bh=moYWN3sF0n0fsMN8AIbjLlPtX1YGl+Cqxpl8qgmsrz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcHXPPt+2ljhmYccd3AdgRx0BVqSBl3FP8OLcyvtyGSCQEOQR0slz7OtJhzp+uXyv7DtWWHvAJ5pUqpX+YDeRo4j/Rq0e7Gfpk3MVdiy4PuxxXWUMOoObC26ssjB4zM8W7IN3gkiUPYCCcJMyvyj5MZuQSXYl2/AqfRPZkuqdKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXxgGv54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXxgGv54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC927C4CEE3;
	Tue, 15 Jul 2025 13:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585912;
	bh=moYWN3sF0n0fsMN8AIbjLlPtX1YGl+Cqxpl8qgmsrz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXxgGv54n5SQBqyxbPYHbRlz5pto+6xd8o8FOL2CkDG0DFHnfUYtzFuK52wrOH8Fe
	 ckUoMi/iyCCj7pM5MkzvOLRK30xsxXGRvJv0Y07rSfUf+sGpsaqwAyL1KRhTfA3ZPI
	 L5qYgcUS+u4mWE6rmBOesgvqzR2Xhu7OpKvGC8Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 055/109] scripts/gdb: de-reference per-CPU MCE interrupts
Date: Tue, 15 Jul 2025 15:13:11 +0200
Message-ID: <20250715130801.078119209@linuxfoundation.org>
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

commit 50f4d2ba26d5c3a4687ae0569be3bbf1c8f0cbed upstream.

The per-CPU MCE interrupts are looked up by reference and need to be
de-referenced before printing, otherwise we print the addresses of the
variables instead of their contents:

MCE: 18379471554386948492   Machine check exceptions
MCP: 18379471554386948488   Machine check polls

The corrected output looks like this instead now:

MCE:          0   Machine check exceptions
MCP:          1   Machine check polls

Link: https://lkml.kernel.org/r/20250625021109.1057046-1-florian.fainelli@broadcom.com
Link: https://lkml.kernel.org/r/20250624030020.882472-1-florian.fainelli@broadcom.com
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
@@ -110,7 +110,7 @@ def x86_show_mce(prec, var, pfx, desc):
     pvar = gdb.parse_and_eval(var)
     text = "%*s: " % (prec, pfx)
     for cpu in cpus.each_online_cpu():
-        text += "%10u " % (cpus.per_cpu(pvar, cpu))
+        text += "%10u " % (cpus.per_cpu(pvar, cpu).dereference())
     text += "  %s\n" % (desc)
     return text
 


