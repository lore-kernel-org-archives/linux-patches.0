Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFF5345741;
	Wed, 21 Jan 2026 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020221; cv=none; b=kwDOKEmF0pihN/icRWdyMQMp0Hv7SDXYPVGc3xBZIr71AF2bZsE99QV88MYRdnqUyqIh301PRbsf7bN5YYYbPNYuMzk6hn/8N4F5FuEK+mJWq/UlbKArfLjdYdxJReNm+ylXZg40Ea3j8MQQIxskEdffBRklzkV0iWeGDRM76Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020221; c=relaxed/simple;
	bh=gnyNya7Po5j4leaEKDhTZMNJSn6T/ihS9yDt2QyJKOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Te1PulrMmGC/+1xJJV08CuIcExeMa7xki1+CFVw8NUxCTfdya37oJ1cUCEqKy4asFAfqWCriwfvW4EhW3hmEspVUPnxZsAWBCkXq4DgJyaliyXt+HWj1YUWENmvQOGV92/7+1s5wgqePkxnFfmDGUtMIyVaggfC1EDLlzuX4G/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEzfcMcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEzfcMcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64006C4CEF1;
	Wed, 21 Jan 2026 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020220;
	bh=gnyNya7Po5j4leaEKDhTZMNJSn6T/ihS9yDt2QyJKOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEzfcMcDoxDUU3hSXLsL1YTv2dmYZPtgxFvTxVjLrh+mO2O7ARBuldPbu4jEu2HIv
	 r66yf+R+ezItZLhWMPF75F4XBWxvayO2KVAKwq8z3H3azktGUsWeoYsudvTHjCbcU3
	 KSaIVv7rIgaiw9Mqasl6CnNNkHmN40velcy34l6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Groves <john@groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/198] drivers/dax: add some missing kerneldoc comment fields for struct dev_dax
Date: Wed, 21 Jan 2026 19:14:55 +0100
Message-ID: <20260121181420.971619622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: John Groves <John@Groves.net>

[ Upstream commit 3e8e590fd65d0572584ab7bba89a35e6d19931f1 ]

Add the missing @align and @memmap_on_memory fields to kerneldoc comment
header for struct dev_dax.

Also, some other fields were followed by '-' and others by ':'. Fix all
to be ':' for actual kerneldoc compliance.

Link: https://lkml.kernel.org/r/20260110191804.5739-1-john@groves.net
Fixes: 33cf94d71766 ("device-dax: make align a per-device property")
Fixes: 4eca0ef49af9 ("dax/kmem: allow kmem to add memory with memmap_on_memory")
Signed-off-by: John Groves <john@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/dax-private.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2e..c6ae27c982f43 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -67,14 +67,16 @@ struct dev_dax_range {
 /**
  * struct dev_dax - instance data for a subdivision of a dax region, and
  * data while the device is activated in the driver.
- * @region - parent region
- * @dax_dev - core dax functionality
+ * @region: parent region
+ * @dax_dev: core dax functionality
+ * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
  * @id: ida allocated id when the dax_region is not static
  * @ida: mapping id allocator
- * @dev - device core
- * @pgmap - pgmap for memmap setup / lifetime (driver owned)
+ * @dev: device core
+ * @pgmap: pgmap for memmap setup / lifetime (driver owned)
+ * @memmap_on_memory: allow kmem to put the memmap in the memory
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
-- 
2.51.0



