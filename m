Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5338D13BAC3;
	Thu, 23 May 2024 13:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470458; cv=none; b=mPCV+3mgJRn+2sjALcDih/DBHfSimSImQBE+8HrJT/RqBNQeGJ4qNxXtR2AdEbxl1O6UKIXidXDTgCPyJFxIhEreN/IDPFgkaNCFoFAToj5faX9ksRTcoKkCooJrhOjG+8yfj/nuou9TeSrxaoD09W9UVRz8p+UqRhG9/7Cbkdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470458; c=relaxed/simple;
	bh=gtiwCJRmBJ2ZUpdUY8q1uaicTaCkBfhZrM5+smbe/Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QfkZAgQUQPkaipmH/Sjf+UuohWEywZf4xxTNo00RIieUWX7L1wHiMqy5TVPV+RsMCfn6pHwwRYhYGgH45NjzhIHbBsDfNlGHw3u+qHZojKXts1fZL0jHEPvZgcYk4fxJiL2KSvicz9zxE/afhgynQjU0q/c2Dz6tQJ0/hI4Wor4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPxaC1Pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPxaC1Pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBAAC2BD10;
	Thu, 23 May 2024 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470458;
	bh=gtiwCJRmBJ2ZUpdUY8q1uaicTaCkBfhZrM5+smbe/Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPxaC1PgTJtBUInVbwzXArRpNaUoRNo0jM1I2qWmuVGCk+H+SHpfxDfDHg15vCmVq
	 m/JMXm9YnwpUCYBLl60I4dDZeHWzdOSm9r/h5Azfytbi8YerE7vHVyXZjdkSK29CoO
	 5jFmh5avYoI1Gd5ETmgPIg3M5zbvOO+Tw4PAfQFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Chris Hyser <chris.hyser@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.1 44/45] admin-guide/hw-vuln/core-scheduling: fix return type of PR_SCHED_CORE_GET
Date: Thu, 23 May 2024 15:13:35 +0200
Message-ID: <20240523130334.146012989@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 8af2d1ab78f2342f8c4c3740ca02d86f0ebfac5a upstream.

sched_core_share_pid() copies the cookie to userspace with
put_user(id, (u64 __user *)uaddr), expecting 64 bits of space.
The "unsigned long" datatype that is documented in core-scheduling.rst
however is only 32 bits large on 32 bit architectures.

Document "unsigned long long" as the correct data type that is always
64bits large.

This matches what the selftest cs_prctl_test.c has been doing all along.

Fixes: 0159bb020ca9 ("Documentation: Add usecases, design and interface for core scheduling")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/util-linux/df7a25a0-7923-4f8b-a527-5e6f0064074d@t-8ch.de/
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Chris Hyser <chris.hyser@oracle.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20240423-core-scheduling-cookie-v1-1-5753a35f8dfc@weissschuh.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/core-scheduling.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/core-scheduling.rst
+++ b/Documentation/admin-guide/hw-vuln/core-scheduling.rst
@@ -67,8 +67,8 @@ arg4:
     will be performed for all tasks in the task group of ``pid``.
 
 arg5:
-    userspace pointer to an unsigned long for storing the cookie returned by
-    ``PR_SCHED_CORE_GET`` command. Should be 0 for all other commands.
+    userspace pointer to an unsigned long long for storing the cookie returned
+    by ``PR_SCHED_CORE_GET`` command. Should be 0 for all other commands.
 
 In order for a process to push a cookie to, or pull a cookie from a process, it
 is required to have the ptrace access mode: `PTRACE_MODE_READ_REALCREDS` to the


