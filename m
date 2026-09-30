Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D523D25B2;
	Wed, 30 Sep 2026 19:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795851; cv=none; b=JkTmLY1nQHJn7G48W5+gUwSFXG/4Y/Zb1c4nWXoI+Wm4/lJX3mRdmyk7EK87/pV4UNWOOm+6AvrNXdvgFTPeeKs6i/Frq+SQ0MLQ4mlXd/3cBfY1m205IubqGblvdodA8mGyktPw/5cW6lZUQU3KuslvbaKuV/NXxPrAw73MxIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795851; c=relaxed/simple;
	bh=cDc8AWyUDt9y4FXdqVPSoeDDcxPTGAQKOl9RfUEv0B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGMAAFq/HkrGRQqLyckzDl3XlKPo97dTDnDkF41bthacdOI3hBD1agIhfsHeqmla+b4D7wdn4EYEPs1DLVl6SktNV0R7LHlHaA79tgnXDeg5cE4GWObDDN22xLxgRPrgGkjm0MMiaUKL4M9PrNsLSCHXsxwvvK7HyNO0s88yNu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1St8nAYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1St8nAYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDE51F000FF;
	Wed, 30 Sep 2026 19:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795850;
	bh=Vd6w4yqvi6NRdPyi7FBtU+2pQOkhGKcpKXlA57JIpp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1St8nAYxC7Ez0EVVhU0AiqMPGHkQFhhwzFVUDs71ZqM2mCNPR1MjNMvjT1MZf24+6
	 Foog4qh9DhefwFM4GOs+Oq3hUmo83ZEX/jNG6VxEFPHwYdYtaoQRMVUrWGfwOig0AZ
	 6izCJFlP4xFFgNdJ8HSjszqaUYUJi/NykHmVvR9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mallesh Koujalagi <mallesh.koujalagi@intel.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 0704/1193] workqueue: Update documentation as per system_percpu_wq naming
Date: Wed, 30 Sep 2026 17:23:08 +0200
Message-ID: <20260930152449.892443535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -610,14 +610,14 @@ static inline bool schedule_work_on(int
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
@@ -668,12 +668,12 @@ extern void __warn_flushing_systemwide_w
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
@@ -683,11 +683,11 @@ static inline bool schedule_delayed_work
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


