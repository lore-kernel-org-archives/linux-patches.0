Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5899936BCDE;
	Wed, 20 May 2026 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295869; cv=none; b=iyb4c4x/muiuSl/hw6vZqt4ljRczd093UxAnNz1ChdUfBg8FmGxTlCXDGEbpRDU0DNfeF995SpVAgMDCygy9zU8VT+Vy47FcQz9IL8VyFUGqDR6p7Ch2uuZPH9i0PY+G/novdH9El+9xWeZnIXn3DV3OzwWnBVuQH9LrkLTG3UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295869; c=relaxed/simple;
	bh=q+zX6NKC18QpEA1cb4+xIb3zcLqEm9AX5MyE78DjKA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APj6ubvZBVQ1zjFRCX8fBP9j3p4KnN0xG71I7emWsI/rIyVAc1M0kN+dR1Qb69alHIZn9VyFcWhcDJ9Sqd9xr4s5sUDbMl/SIDY+961qv8WfRQ8MknSEdijf1UuAjjX46ns73mNkz8jMQeNiTb00yPp3xA9moTFAkTODqjLDI68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbnX9peH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbnX9peH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1BD1F000E9;
	Wed, 20 May 2026 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295868;
	bh=dZxe1jcg6EWvXbboN2hL4zY+2N4urenef9Jixjvt2iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbnX9peHndw7nO5nf+GEvUxlQVPWSRlbPSUjhYwEIj1aO0dypw7NGdQsLbh7+AdKH
	 UCf7kbhQFt+VENctdYsngbxk/k8oQashQpjN93T66l3GvtvQYL8sTYmiD2XoA8KFFi
	 KvlWEjQMJh4eDh6oD2/bUwtfMnTUPbUc1h0MzRtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0583/1146] stop_machine: Fix the documentation for a NULL cpus argument
Date: Wed, 20 May 2026 18:13:53 +0200
Message-ID: <20260520162201.374467646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 48f7a50c027dd2abb9e7b8a6ecc8e531d87f2c21 ]

A recent refactoring of the kernel-docs for stop machine changed the
description of the cpus parameter from "NULL = any online cpu"
to "NULL = run on each online CPU".

However the callback is only executed on a single CPU, not all of them.
The old wording was a bit ambiguous and could have been read both ways.

Reword the documentation to be correct again and hopefully also clearer.

Fixes: fc6f89dc7078 ("stop_machine: Improve kernel-doc function-header comments")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/stop_machine.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 72820503514cc..01011113d2263 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -99,7 +99,7 @@ static inline void print_stop_info(const char *log_lvl, struct task_struct *task
  * stop_machine: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr to pass to @fn()
- * @cpus: the cpus to run @fn() on (NULL = run on each online CPU)
+ * @cpus: the cpus to run @fn() on (NULL = one unspecified online CPU)
  *
  * Description: This causes a thread to be scheduled on every CPU, which
  * will run with interrupts disabled.  Each CPU specified by @cpus will
@@ -133,7 +133,7 @@ int stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus);
  * stop_machine_cpuslocked: freeze the machine on all CPUs and run this function
  * @fn: the function to run
  * @data: the data ptr to pass to @fn()
- * @cpus: the cpus to run @fn() on (NULL = run on each online CPU)
+ * @cpus: the cpus to run @fn() on (NULL = one unspecified online CPU)
  *
  * Same as above.  Avoids nested calls to cpus_read_lock().
  *
-- 
2.53.0



