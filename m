Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FEF246770;
	Tue, 13 Oct 2026 12:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894619; cv=none; b=n3s7Re24yrkPkRGe32ar5/J2x2yBjgE/zd6TUgDRKXlTZ/QJ6QEGpa5k2XyhnwB7aGAJBIaJrPgfnON2wYXpHi/W578j7CxpkrReRHRXVE7KlV78CWy8FdXhpNC+9BHeO1kaNSP9CIjoEbEhysfNvZf8jiy5dAqvpZLy8AhOGec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894619; c=relaxed/simple;
	bh=It908S3YQXuPRpNCb7I50fxlJhy4gvacwgw7AV/WQtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCUjHpr7C/O7TmZPfHRZvxM9Y4u+QguvJqD75UjFP+sMvKqvnTgc9nr/IkBkY18KRl5nWiiNNF4Tbb+Ts/SHeyi5YqI/fjxTcZLGiuoZiMP1WVhxNisJPIUAZD/XohdwkUIwb3nZwu57hH1taEtkn+3LwpFuK/k+hlQ3wzbaf5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFUAE6SR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFUAE6SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A879E1F00898;
	Tue, 13 Oct 2026 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894618;
	bh=L4/La90cczssZFHa8tPIBB6O5NLo7JgH2RWswLoVY0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFUAE6SRIewTg/WdjxkuRbiMm4sro2tRIQGFDpF5VRSGzCTsotDSNyDjT+2Bt25Sk
	 xml16uPxOMrKd8L32ENcPyiOylcDvPwZ5yrjEwgwkIxWEpdlM9on4lOJAQJvbGLS1H
	 EzscC3gsNMbfRQ/xUYtvl7aznodKPkO+oWkMIQX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 619/621] workqueue: Annotate alloc_workqueue_va() with __printf(1, 0)
Date: Tue, 13 Oct 2026 13:40:14 +0200
Message-ID: <20261013112935.488194829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 20e81c64c905bd765e69ef07920d2b1130dc79b6 upstream.

alloc_workqueue_va() forwards its va_list to __alloc_workqueue() which
ultimately feeds vsnprintf(). __alloc_workqueue() already carries
__printf(1, 0); the new wrapper needs the same annotation so format
string checking propagates through the forwarding.

Fixes: 0de4cb473aed ("workqueue: fix devm_alloc_workqueue() va_list misuse")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604300347.2LgXyteh-lkp@intel.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5875,6 +5875,7 @@ err_destroy:
 	return NULL;
 }
 
+__printf(1, 0)
 static struct workqueue_struct *alloc_workqueue_va(const char *fmt,
 						   unsigned int flags,
 						   int max_active,


