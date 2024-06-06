Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ABC19AA6A;
	Thu,  6 Jun 2024 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683033; cv=none; b=ZN2k3SZPXk5Wpy279RyzaDcRPhcLPeTQZcNOizVOkfeAmkc/UDOZbxgrv9Bl9VzZ1M4FHaVH60Nygka96/hUjTaZAMir0oAgKo3hDDbPv/Ue0z0YV48wDRF5BRdDOfCpcnvSjgvz0TCuaOHd/6Y6oIR0zfsdn9/tTedQ1WtS/s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683033; c=relaxed/simple;
	bh=sOCHVHTAEsvItuDBau0WTNVA8/w/Dyt2qe2cxo+5P8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRUeuXUoQCnbwjVQ4OQDrleif+6ulbNe6X7XR3M6WqP3TLArOBc/1rwncx9sADEC9mMLv5JoFiORBoRLt3x80u7tL89AHXAThA7HgoG5UIWlXKHmFHT8hsyPUUNEO+ekmKnqC4LCa4dXozJ/FApjlocVX6+mmePUHi3OKVnKUpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcB2VwLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcB2VwLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC18AC4AF0A;
	Thu,  6 Jun 2024 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683032;
	bh=sOCHVHTAEsvItuDBau0WTNVA8/w/Dyt2qe2cxo+5P8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcB2VwLCEE1wwEQQ1GwC5dXbUZXN4MA28xOGUighvl2hha5u3ubi1kqudJjpb5vOd
	 mTNTRdgwc1kyDwWKvsePepacbI9TtTyogNZIe9MhrnVjy3kfEty3EA/ITlw5X4A1RZ
	 qmh56VLSmsIpLYdGCfXSgmUz+rf9ZyKbNlyrM8hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.lee@linux.alibaba.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 257/374] rv: Update rv_en(dis)able_monitor doc to match kernel-doc
Date: Thu,  6 Jun 2024 16:03:56 +0200
Message-ID: <20240606131700.467569238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



