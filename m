Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B6B4D1799;
	Thu, 17 Sep 2026 19:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671821; cv=none; b=EUaeY7TZpejfULJjZ97QdcNna4P8IJASQSuwjWdlZ2UpOyirXVWyCg1MURgGlGDbzzy+hzvelp3UjmoQcKtjfl+a/WJmmsns3etBBO5mwltg+kQ93LCjwgnuENK49wQgRxwKTh1DP3GrEAhFjkUCsDJpFtzGvatg3Jy5TsuWT8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671821; c=relaxed/simple;
	bh=NnNRV2wHq+7sRF3mwNbbU+lhdXVhuM903gG0yvSJcHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tF4D3YlFLvqgXjB3x5jPVtJzHaOeYatyKPiHK9H+/W97i2m/SWw7vHzpkW3bVcwTOJNeFT5Y8XVSLc3TDX7/QdAjd8KHS30apgbbRL/+KQzyUNNPYliE/5ct3dwLmn0NJPK/qdE3YARr1cnzoLP2gJdMzbXsvPPw2/iNl5jAsuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3cpUnWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3cpUnWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36361F00893;
	Thu, 17 Sep 2026 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671819;
	bh=OOWTCL5ooodDhE8XHOLK7r1ULENh7R9bRskk4lDLTKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3cpUnWsrjc+v+q5Wf8qXeSqxQ+RantJCgjuOXfysWVgs2DShhazhRND4CSKZf9d7
	 Vy88pZxATfoZ941QtzNcWgRiSrUn250IxVRbiSjfJC8wdiiVljENp79KrV7kW9zrgK
	 CXF79yTimN9lY4z3JLX/u6SJBoNQcffTFLALWjJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mallesh Koujalagi <mallesh.koujalagi@intel.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 1100/1102] workqueue: Update documentation as per system_percpu_wq naming
Date: Thu, 17 Sep 2026 16:17:23 +0100
Message-ID: <20260917151608.490401923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mallesh Koujalagi <mallesh.koujalagi@intel.com>

commit 4a91a33f15c634fb3477d122bdf1eef098d77ee3 upstream.

Update documentation to use "per-CPU workqueue" instead of
"global workqueue" to match the system_wq to system_percpu_wq
rename. The workqueue behavior remains unchanged; this just
aligns terminology with the clearer naming.

Fixes: a2be943b46b4 ("workqueue: replace use of system_wq with system_percpu_wq")
Signed-off-by: Mallesh Koujalagi <mallesh.koujalagi@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/workqueue.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -708,14 +708,14 @@ static inline bool schedule_work_on(int
 }
 
 /**
- * schedule_work - put work task in global workqueue
+ * schedule_work - put work task in per-CPU workqueue
  * @work: job to be done
  *
- * Returns %false if @work was already on the kernel-global workqueue and
+ * Returns %false if @work was already on the system per-CPU workqueue and
  * %true otherwise.
  *
- * This puts a job in the kernel-global workqueue if it was not already
- * queued and leaves it in the same position on the kernel-global
+ * This puts a job in the system per-CPU workqueue if it was not already
+ * queued and leaves it in the same position on the system per-CPU
  * workqueue otherwise.
  *
  * Shares the same memory-ordering properties of queue_work(), cf. the
@@ -792,12 +792,12 @@ extern void __warn_flushing_systemwide_w
 })
 
 /**
- * schedule_delayed_work_on - queue work in global workqueue on CPU after delay
+ * schedule_delayed_work_on - queue work in per-CPU workqueue on CPU after delay
  * @cpu: cpu to use
  * @dwork: job to be done
  * @delay: number of jiffies to wait
  *
- * After waiting for a given time this puts a job in the kernel-global
+ * After waiting for a given time this puts a job in the system per-CPU
  * workqueue on the specified CPU.
  */
 static inline bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
@@ -807,11 +807,11 @@ static inline bool schedule_delayed_work
 }
 
 /**
- * schedule_delayed_work - put work task in global workqueue after delay
+ * schedule_delayed_work - put work task in per-CPU workqueue after delay
  * @dwork: job to be done
  * @delay: number of jiffies to wait or 0 for immediate execution
  *
- * After waiting for a given time this puts a job in the kernel-global
+ * After waiting for a given time this puts a job in the system per-CPU
  * workqueue.
  */
 static inline bool schedule_delayed_work(struct delayed_work *dwork,


