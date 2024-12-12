Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94BF2054F8;
	Thu, 12 Dec 2024 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017110; cv=none; b=qk4thjQYoGrNHQJT/KgLf8M1bU3WK4liUcisx+YB8Ro1ygq21f2ujJwvVilyRit3AllJfAHepMvNN1w3nKS304zmhWzVdFPy5LHaWRxSW9WkcmgcUdbSlL2b54YZTyXjc/nAXy8XiPPyun8RbzlpCJVjjdBCPqVSOSFG7Pg5DZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017110; c=relaxed/simple;
	bh=afKMctFW6Ypuk8WIGYyL//OtwSO8ptIjeqfUcI6LVVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY7h3Sb1XFqpHoOD2dzreyrhUM//ZJhTcAEAP7fiR2zHXX+jbfWFEHXsXy8mxHUtWozhLWTsEQIu3jtY6PokZRynGSKjXY7KkJw4VM9eY1jETuO+DeAqhEkrpC/JWd6xRd8V9XjW0AgEqO/ze4C7kGELk463WrlqtN2rQTUSHl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOE/BgNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOE/BgNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1849DC4CED4;
	Thu, 12 Dec 2024 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017110;
	bh=afKMctFW6Ypuk8WIGYyL//OtwSO8ptIjeqfUcI6LVVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOE/BgNmLH9Y9rDiQnydq0C7LXStkU9aK+z9olJCESDqXhGYE9ksMWpOXSvxjBWvy
	 qTIcYPTkUHBcdh/ve6JD7ctFFaROSpfzNsOi9ys7mEAb3EH2YhtYjopKwX7shBKSnZ
	 vGD9YfNPJ083gtY8CbJlDu22Q0ypWs6yL0Is5OTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"jkacur@redhat.com" <jkacur@redhat.com>,
	"lgoncalv@redhat.com" <lgoncalv@redhat.com>,
	Furkan Onder <furkanonder@protonmail.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/466] tools/rtla: Enhance argument parsing in timerlat_load.py
Date: Thu, 12 Dec 2024 15:59:14 +0100
Message-ID: <20241212144321.979715306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: furkanonder <furkanonder@protonmail.com>

[ Upstream commit bd26818343dc02936a4f2f7b63368d5e1e1773c8 ]

The enhancements made to timerlat_load.py are aimed at improving the clarity of argument parsing.

Summary of Changes:
- The cpu argument is now specified as an integer type in the argument
  parser to enforce input validation, and the construction of affinity_mask
  has been simplified to directly use the integer value of args.cpu.
- The prio argument is similarly updated to be of integer type for
  consistency and validation, eliminating the need for the conversion of
  args.prio to an integer, as this is now handled by the argument parser.

Cc: "jkacur@redhat.com" <jkacur@redhat.com>
Cc: "lgoncalv@redhat.com" <lgoncalv@redhat.com>
Link: https://lore.kernel.org/QfgO7ayKD9dsLk8_ZDebkAV0OF7wla7UmasbP9CBmui_sChOeizy512t3RqCHTjvQoUBUDP8dwEOVCdHQ5KvVNEiP69CynMY94SFDERWl94=@protonmail.com
Signed-off-by: Furkan Onder <furkanonder@protonmail.com>
Reviewed-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/sample/timerlat_load.py | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/tracing/rtla/sample/timerlat_load.py b/tools/tracing/rtla/sample/timerlat_load.py
index 8cc5eb2d2e69e..52eccb6225f92 100644
--- a/tools/tracing/rtla/sample/timerlat_load.py
+++ b/tools/tracing/rtla/sample/timerlat_load.py
@@ -25,13 +25,12 @@ import sys
 import os
 
 parser = argparse.ArgumentParser(description='user-space timerlat thread in Python')
-parser.add_argument("cpu", help='CPU to run timerlat thread')
-parser.add_argument("-p", "--prio", help='FIFO priority')
-
+parser.add_argument("cpu", type=int, help='CPU to run timerlat thread')
+parser.add_argument("-p", "--prio", type=int, help='FIFO priority')
 args = parser.parse_args()
 
 try:
-    affinity_mask = { int(args.cpu) }
+    affinity_mask = {args.cpu}
 except:
     print("Invalid cpu: " + args.cpu)
     exit(1)
@@ -44,7 +43,7 @@ except:
 
 if (args.prio):
     try:
-        param = os.sched_param(int(args.prio))
+        param = os.sched_param(args.prio)
         os.sched_setscheduler(0, os.SCHED_FIFO, param)
     except:
         print("Error setting priority")
-- 
2.43.0



