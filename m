Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591580;
	b=ZDNVfVLzTRxGWZbw4kQ+SDHqvojYB/76v/7OVK4l3L1HfykWB9v9eSeF4sI+yZxBoMXN
	 oTRPtMhYp9lMwAXHv4rxj5xl+6PTIYZx5zsg6cjHAvfkBKWw3J4yZ3hIJ5xlZiSk62fJk
	 8yiP1zcEIMeGCgPDJ2xGA9XsBmXoK+6CPT5yWkE9l37J++RVSkHBdEY1fqkmrm00hvSq9
	 bUO3sL7lJ2r7CnmoYHSaP545fgRLiM95FAY5tH8TRnYK3zR5YscogC/E69ihhttEtRyMh
	 qnlx3g0tKzMBd5RO3nenHZAw4tk4Dmrc+gvZ9lnIe0Fd2RO17ZsMEUnLxA9MQUy3igQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YrsjRn+mW3qsS8V7ETjRQxOXMo/v5hXx1uwwgwf50hw=;
	b=dEeYcwB2mYcJLXTvwAq135qb8vnjSZyem3XpurIjV8oO4b336Yx9HSQNDlvvH9tTbQCp
	 9KWAAeXPJqmsHMVTSDw1uqdkF+n6rjnjgHxJXD0f9ndgBkCr717pe7shKD+Rrp1yrSRer
	 24fPbGHChUNO9+1m1ihjxGyh+dNtpaDyM1sgDc0VYVzQUTSLA9kDXq7ZKLCaVfUQPwP1Q
	 PYShZu+q7Wwu+i0OsCII8oHb6WcRWGle88ZKwrR4WkQJK1RAqMh0bw0js73n1QYYo2QC8
	 8ExbttAaOWWqpcmiByBupbzY34+N7+1WuXeVyjTsOSL1I94OKVOjbivqk5lzd0UbXAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pe8gHGjV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE09D606E64F;
	Fri, 13 Nov 2026 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pe8gHGjV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8796C1F000C6;
	Fri, 13 Nov 2026 17:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591579;
	bh=YrsjRn+mW3qsS8V7ETjRQxOXMo/v5hXx1uwwgwf50hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pe8gHGjVu/TX0ygXRUtZxm/f7zUnTFeC26rXxcEfj1AluD5ExFe1zI7/uRHavpPhc
	 IkaD7WvqJPHb7yuUK5yEdEtEuGV3yJ/vixvY2KRU/JaN1Kd/Ap5FO37tH4KX96g0Eh
	 koU5L9lOfqIhJmm4JqCEo41ATLh16bf1Y0dulfCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Baoquan He <bhe@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Young <dyoung@redhat.com>,
	Doug Anderson <dianders@chromium.org>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Helge Deller <deller@gmx.de>,
	Ingo Molnar <mingo@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	Joel Granados <joel.granados@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Kees Cook <kees@kernel.org>,
	Li Huafei <lihuafei1@huawei.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Nam Cao <namcao@linutronix.de>,
	oushixiong <oushixiong@kylinos.cn>,
	Petr Mladek <pmladek@suse.com>,
	Qianqiang Liu <qianqiang.liu@163.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Thomas Zimemrmann <tzimmermann@suse.de>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 627/670] panic: use panic_try_start() in nmi_panic()
Date: Fri, 13 Nov 2026 10:53:11 -0500
Message-ID: <20261113153833.039991545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinchao Wang <wangjinchao600@gmail.com>

[ Upstream commit 6b69c7ef96f1afc7b426195087f7488f1510c2a4 ]

nmi_panic() duplicated the logic to claim panic_cpu with
atomic_try_cmpxchg.  This is already wrapped in panic_try_start().

Replace the open-coded logic with panic_try_start(), and use
panic_on_other_cpu() for the fallback path.

This removes duplication and keeps panic handling code consistent.

Link: https://lkml.kernel.org/r/20250825022947.1596226-5-wangjinchao600@gmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Luo Gengkun <luogengkun@huaweicloud.com>
Cc: Max Kellermann <max.kellermann@ionos.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: oushixiong <oushixiong@kylinos.cn>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Qianqiang Liu <qianqiang.liu@163.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 75eb687ff2bc ("panic: flatten nmi_panic control flow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 97c472164393b..b4db7f62b8ed5 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -248,15 +248,9 @@ EXPORT_SYMBOL(panic_on_other_cpu);
  */
 void nmi_panic(struct pt_regs *regs, const char *msg)
 {
-	int old_cpu, this_cpu;
-
-	old_cpu = PANIC_CPU_INVALID;
-	this_cpu = raw_smp_processor_id();
-
-	/* atomic_try_cmpxchg updates old_cpu on failure */
-	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu))
+	if (panic_try_start())
 		panic("%s", msg);
-	else if (old_cpu != this_cpu)
+	else if (panic_on_other_cpu())
 		nmi_panic_self_stop(regs);
 }
 EXPORT_SYMBOL(nmi_panic);
-- 
2.53.0



