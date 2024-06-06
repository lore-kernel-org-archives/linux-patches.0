Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFA11A2555;
	Thu,  6 Jun 2024 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683742; cv=none; b=fpYHwYHkAoPrH/IO/hNwGEVW1CG14HpAAn+EObIJvX+cTW5T3HFETYd6+J/AiCs2tPDsBfYoRkf3Ma3jqqDcQERpkjiLZuANUW1/77YIct6HOxFoBXznQo9Gr8T8QPKRotuS0xG45ylfCn3rYLYl2jIdxRJEnEXLB8BejpfxIZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683742; c=relaxed/simple;
	bh=WyintSlbMKC4KUz+kkCXfiqrBhaasU5Ll0/AvhRtMgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyD349HGdF368ojs1ByQ9KPAckJJ5iAqALYEZ9ochf55Wiyu7JwcEcx/nT7WGnizTcd5gLx8XPcuyN5/7AhElv69mZnxF0x7xGwOeS5djeg6VBskFvq3k5M1WChp+CZPM2HrsK60AGuHkNiXu6gEdGvk2jUOZVmrjIgd5FWxdN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KJN0C8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KJN0C8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A68C32781;
	Thu,  6 Jun 2024 14:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683742;
	bh=WyintSlbMKC4KUz+kkCXfiqrBhaasU5Ll0/AvhRtMgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KJN0C8MNcl3gytqdKfqisuXQi+p0FzVZfqBKCCfSz2UOnIEjkE3EBagcC/DCktu/
	 6QdzUCeyvw6SycZw2OSwOl5MCA+KIr45nKEpv5aGHOKZrCDcZVjdvWQVrDyU63wk7L
	 T8GdVz9dCzwSwLJF22pLOCvxHYvZRugqMcXAyKrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.lee@linux.alibaba.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 652/744] rv: Update rv_en(dis)able_monitor doc to match kernel-doc
Date: Thu,  6 Jun 2024 16:05:24 +0200
Message-ID: <20240606131753.382180831@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 1e8b7b3dbb3103d577a586ca72bc329f7b67120b ]

The patch updates the function documentation comment for
rv_en(dis)able_monitor to adhere to the kernel-doc specification.

Link: https://lore.kernel.org/linux-trace-kernel/20240520054239.61784-1-yang.lee@linux.alibaba.com

Fixes: 102227b970a15 ("rv: Add Runtime Verification (RV) interface")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/rv/rv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/rv/rv.c b/kernel/trace/rv/rv.c
index 2f68e93fff0bc..df0745a42a3f3 100644
--- a/kernel/trace/rv/rv.c
+++ b/kernel/trace/rv/rv.c
@@ -245,6 +245,7 @@ static int __rv_disable_monitor(struct rv_monitor_def *mdef, bool sync)
 
 /**
  * rv_disable_monitor - disable a given runtime monitor
+ * @mdef: Pointer to the monitor definition structure.
  *
  * Returns 0 on success.
  */
@@ -256,6 +257,7 @@ int rv_disable_monitor(struct rv_monitor_def *mdef)
 
 /**
  * rv_enable_monitor - enable a given runtime monitor
+ * @mdef: Pointer to the monitor definition structure.
  *
  * Returns 0 on success, error otherwise.
  */
-- 
2.43.0



