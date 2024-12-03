Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6395F81ADA;
	Tue,  3 Dec 2024 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242105; cv=none; b=OPVIZAH7y/XJQ2o6i1VsD4qrTUgtuC5eXJtR4GgV+rVU1nBK78fjv796caSBWasyPiPI2ESsB6r9qM4SYYxiWBUX9/7eDd7ErelMQGmj5c6C462W+tKh+g+D/ixEfmuZboT7NS3WmChKhW/Jsq02ji50tGa22oO1VGiaer/jbFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242105; c=relaxed/simple;
	bh=rRxwlFmfHqQtKarodbpO9lG4fIWl7IjeX56MlMJpJL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baLKH4uU7OREXo83cnJMLmnT8ns9vK91YkKhmSja1KccADeyd+ftb8B6d+W/4eX2khouBFjGE2iWfcOp9w7tkDNOGxn0C76FYgOuIrACEdvSMGw11N1iUTw1546covSAxRf1m4yTMaa0KjCPI0EB5ikbdvtq3m0PtmrbkBkzuKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb+uAlmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb+uAlmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A42C4CECF;
	Tue,  3 Dec 2024 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242105;
	bh=rRxwlFmfHqQtKarodbpO9lG4fIWl7IjeX56MlMJpJL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb+uAlmVcGWW4HermO2aq1KgW8uQBMQcE6TA0v7dVVoX9w+bzTWqYVDvaFJpudlEB
	 4RWEov7pMfkDKXo/Y5yCJ1v1S4Vjjdgq7/uneVRvVyeZlrh/y2Eo8TsKXrWYUc31+K
	 uYyDw/cUDL/evnEbT2zx4OTMmCtYzibi0K6/F/zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Carl Vanderlip <quic_carlv@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Mayank Rana <quic_mrana@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 608/826] bus: mhi: host: Switch trace_mhi_gen_tre fields to native endian
Date: Tue,  3 Dec 2024 15:45:35 +0100
Message-ID: <20241203144807.471288670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carl Vanderlip <quic_carlv@quicinc.com>

[ Upstream commit 23388a1b305e8aac714fafd5fdc72a580586bd0c ]

Each of the __field() macros were triggering sparse warnings similar to:
trace.h:87:1: sparse: sparse: cast to restricted __le64
trace.h:87:1: sparse: sparse: restricted __le64 degrades to integer
trace.h:87:1: sparse: sparse: restricted __le64 degrades to integer

Change each little endian type to its similarly sized native integer.
Convert inputs into native endian.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402071859.8qMhgJEQ-lkp@intel.com/
Fixes: ceeb64f41fe6 ("bus: mhi: host: Add tracing support")
Signed-off-by: Carl Vanderlip <quic_carlv@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Mayank Rana <quic_mrana@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241004170321.4047492-1-quic_carlv@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/trace.h | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/bus/mhi/host/trace.h b/drivers/bus/mhi/host/trace.h
index 95613c8ebe069..3e0c41777429e 100644
--- a/drivers/bus/mhi/host/trace.h
+++ b/drivers/bus/mhi/host/trace.h
@@ -9,6 +9,7 @@
 #if !defined(_TRACE_EVENT_MHI_HOST_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_EVENT_MHI_HOST_H
 
+#include <linux/byteorder/generic.h>
 #include <linux/tracepoint.h>
 #include <linux/trace_seq.h>
 #include "../common.h"
@@ -97,18 +98,18 @@ TRACE_EVENT(mhi_gen_tre,
 		__string(name, mhi_cntrl->mhi_dev->name)
 		__field(int, ch_num)
 		__field(void *, wp)
-		__field(__le64, tre_ptr)
-		__field(__le32, dword0)
-		__field(__le32, dword1)
+		__field(uint64_t, tre_ptr)
+		__field(uint32_t, dword0)
+		__field(uint32_t, dword1)
 	),
 
 	TP_fast_assign(
 		__assign_str(name);
 		__entry->ch_num = mhi_chan->chan;
 		__entry->wp = mhi_tre;
-		__entry->tre_ptr = mhi_tre->ptr;
-		__entry->dword0 = mhi_tre->dword[0];
-		__entry->dword1 = mhi_tre->dword[1];
+		__entry->tre_ptr = le64_to_cpu(mhi_tre->ptr);
+		__entry->dword0 = le32_to_cpu(mhi_tre->dword[0]);
+		__entry->dword1 = le32_to_cpu(mhi_tre->dword[1]);
 	),
 
 	TP_printk("%s: Chan: %d TRE: 0x%p TRE buf: 0x%llx DWORD0: 0x%08x DWORD1: 0x%08x\n",
@@ -176,19 +177,19 @@ DECLARE_EVENT_CLASS(mhi_process_event_ring,
 
 	TP_STRUCT__entry(
 		__string(name, mhi_cntrl->mhi_dev->name)
-		__field(__le32, dword0)
-		__field(__le32, dword1)
+		__field(uint32_t, dword0)
+		__field(uint32_t, dword1)
 		__field(int, state)
-		__field(__le64, ptr)
+		__field(uint64_t, ptr)
 		__field(void *, rp)
 	),
 
 	TP_fast_assign(
 		__assign_str(name);
 		__entry->rp = rp;
-		__entry->ptr = rp->ptr;
-		__entry->dword0 = rp->dword[0];
-		__entry->dword1 = rp->dword[1];
+		__entry->ptr = le64_to_cpu(rp->ptr);
+		__entry->dword0 = le32_to_cpu(rp->dword[0]);
+		__entry->dword1 = le32_to_cpu(rp->dword[1]);
 		__entry->state = MHI_TRE_GET_EV_STATE(rp);
 	),
 
-- 
2.43.0



