Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57F33EBF35;
	Wed, 20 May 2026 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298560; cv=none; b=dyCsU16BAieokwWm1otQNIil2GWp/+zateSHMuVVk65hb4FmNbaOZreTPH33XREITlTJlIXMOMwfB8ZfOtqyWlC7CBCMJGJlaN55oCkvVtiZR6U6esmZ/QqtARofz4C/FKJiDVaWgkTKD96z4lcCZ/ZUa+nFRsKkPEKX4NSTKUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298560; c=relaxed/simple;
	bh=Xc4x2KaitfWWEqt6ZceJCtzXCQeIoLu5FsgH2du64cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yj3YDKgGleEDEk5hODX79wZbOnE1mxwPyRy8epMvDHgEEBRzzfboj4QEuLCgCFsv5/EH5Iz0nmg7IMdTCTO6boV2JIozKy5Z1bgpuv347TRx95XC5mkyoSEeaUEVTV/ezkMXaj5t0B1k6twk1jp2BBQHacrzu4eUn5pbKsP78Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltj/YfSO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltj/YfSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC7B1F00894;
	Wed, 20 May 2026 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298556;
	bh=YPHqGuw5SdGCfzAIimFViIPhg3H1BsfFvG2CVKFwAlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltj/YfSOrRNwKF85Wl74OukWFqaJwiOmVhaegk2u+2Rs8gEDBEzAUxodNPfDA54UJ
	 YbB1zPdmhIxaFIgGKpMHRzc1xj7PhDN9/sErHzTZfVrUI63q0EE8Wu8y0Nj/r7uGQq
	 FuF2PYhz1rFbTbvH5WChfRvK+ce9G3lenGb/aIMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 457/957] stop_machine: Fix the documentation for a NULL cpus argument
Date: Wed, 20 May 2026 18:15:40 +0200
Message-ID: <20260520162144.433558162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



