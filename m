Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EE43382DE;
	Mon, 20 Apr 2026 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700435; cv=none; b=fQdkK9g1zkJXKQOBf/cHgGxCanuZJRyUuczqncYSroBzlsxkUhlgsTG0xQYQdB6AhU0Cwy9tz6IBNM4U2mIAgIFXvRkthVK6IObBeQxT0M/lDXQ2xcdogx0FJ7NeKpv16Sn8OB4SgDZsXm0xreGmK6cxH28ppX9btpQYHXC0Bc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700435; c=relaxed/simple;
	bh=Wi9dAfd14ExG8jHx8ij/IyNBypmv8JAMqqssnYI/4hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTa4Sp9R3ctBlxjga4IZ3urnp6Q2+7aDhGZaIBo3H0sBFqa/b342JbRMFL9I32+lovOD1yTCLQAjttJr/yq94UFvZnuH+YiuAHSNNBAc9XaQdvI53kdbGaEJrmxKIM/k93y0YgEGGwkIa3vDE+yFZWy9nf9v5tHh1PUiWGni4Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjekE2y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjekE2y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2E0C19425;
	Mon, 20 Apr 2026 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700435;
	bh=Wi9dAfd14ExG8jHx8ij/IyNBypmv8JAMqqssnYI/4hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjekE2y8wInz5P93p9QCXNO8vf2PRqqEyYfngcgmEM3vUfslI4FOObl2Nk58xYjo/
	 QXKxLFeBB88/2+GtQiCcBYuK5/Y3e0l3xnM5PTvbKBLNrAT3ylLYF3GgfmBP2l78oe
	 PUrtcCoyFtZiK19ZdYOnopV/JffpWM6vSUXrOepY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 170/220] scripts/gdb/symbols: handle module path parameters
Date: Mon, 20 Apr 2026 17:41:51 +0200
Message-ID: <20260420153940.147714985@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

commit 8e4513303b8726e4434f718ab39749cbb4c142b1 upstream.

commit 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available
to GDB") added support to make BPF debug information available to GDB.
However, the argument handling loop was slightly broken, causing it to
fail if further modules were passed.  Fix it to append these passed
modules to the instance variable after expansion.

Link: https://lkml.kernel.org/r/20260304110642.2020614-2-benjamin@sipsolutions.net
Fixes: 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available to GDB")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/symbols.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/symbols.py b/scripts/gdb/linux/symbols.py
index d4308b726183..943ff1228b48 100644
--- a/scripts/gdb/linux/symbols.py
+++ b/scripts/gdb/linux/symbols.py
@@ -298,7 +298,7 @@ are loaded as well."""
             if p == "-bpf":
                 monitor_bpf = True
             else:
-                p.append(os.path.abspath(os.path.expanduser(p)))
+                self.module_paths.append(os.path.abspath(os.path.expanduser(p)))
         self.module_paths.append(os.getcwd())
 
         if self.breakpoint is not None:
-- 
2.53.0



