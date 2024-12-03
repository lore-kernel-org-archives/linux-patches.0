Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F0D1F130F;
	Tue,  3 Dec 2024 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239477; cv=none; b=ltxO1PscL6u1RVmXZm1RKeuXbOaEGiWVF6nRu27vbcKEHVh6Ig1rFHBiQsQ3fAzF4M7dxRyCHX3J2xKfoagPy2hK4auIr4zlE9y05FiJ61zyHhU/h3EGXHKqJEoDc+KTeNxhpCtOshFqo1Ai/a6IkUfTmR8733vKmX9ivrGEo7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239477; c=relaxed/simple;
	bh=ZOu2HwgyzZuecw1wcnhTdI9J61BKsMc4m3s/7eumG10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAtpNxcduNCXo1EiKq1REVsr9iRb/HkZdkTRiYnrSD2bZBpUf2A3WDVk3rhoAJHb2KXdfp2Kbtc8k3J427dVA73mfevDIzuopDBG9eKJDr6f6F8bVU0Fkoqhx6upZQ+zejcqiPy9jWftLKPASydrz69rx+HQ1fydpK9/RbCIBWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qkt37su+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qkt37su+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8B1C4CECF;
	Tue,  3 Dec 2024 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239477;
	bh=ZOu2HwgyzZuecw1wcnhTdI9J61BKsMc4m3s/7eumG10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qkt37su+jaQsBtV5TKCGEv76SU3GlmwoxqPFvt3IRReulGv9/3uAOG9ZhskN3d9TW
	 3hpYyLWY+ev58EojjH9ifbGUUVNIUMc1viVKCvu/oAs69GEisJWckQNXCxfi05nJcf
	 gpoSJazrDenmuV+lqKdw7O6be9u+D+8LVnwJ9cgg=
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
Subject: [PATCH 6.11 610/817] bus: mhi: host: Switch trace_mhi_gen_tre fields to native endian
Date: Tue,  3 Dec 2024 15:43:02 +0100
Message-ID: <20241203144019.743391464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



