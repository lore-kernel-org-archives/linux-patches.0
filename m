Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064899;
	b=dL13tXrxdIh76YwfJAmQl/17Aa5ELkIxsVes/sQsqIxxPEqEJ/hPiHw0LFysUJcBMWad
	 xzPXPyUZDBEqrhWQ0lhTZMltoYFmXd4LDbUyK5fzr/XBsbYq56bqDlI18/lCr7LsGQbtL
	 ClOhZfv1JY/H/1OIPDDmhoCpI9aG0TTl0UHckrZL7N+VNLfyAL+9IlKkR3/dM+CC8Y1r4
	 yLTZbe7Qgw0sZy1hf8LoX/2XXmZudbOqotTm2lNfD6o+zte7z/PeaU+/8plT2Ll3Go1oM
	 0XgsPA3JGqRsOugEoKRVy99w5UIa8okC0tBsjctAt27+QeACz185cqe/DrIGWpZas+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VlNaDXLY48m8PrALolV0lp0jIOIaRd0s/zNkYq7dMU4=;
	b=5KnV58nyyBd81T7t/mQC68+rf903hVqnAC6xqGoUXzN9rb8S9+Z+v9FWtAATwt/pogEG
	 XEqRrmar5DHnNnpMRHbNVgCHdz8xxb3KgCmq949KVQC/tVXNpUioa8nxclDflBTGc/aQb
	 wJadrf0SVLs8uZehZOYBycxh2eHFVYCJ9dobRZBHwVUw287mFyUok6V8f+rxjzXtCfGjy
	 35GDTuGrP06cj3emzsZpmTps4Ph33FLE6RHOHUXzjfecHmr79q/wa4ziBAaAEuJ1IJ0AG
	 RRfQ7dQ9eQzNODYcQPZ5JpMuTFdynwcLIbtiAHJpb/JnJRkfzwPay8jtFSuctYVIHcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EQYMhtWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B51E606A9D4;
	Sat,  7 Nov 2026 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EQYMhtWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75511F0089F;
	Sat,  7 Nov 2026 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064899;
	bh=VlNaDXLY48m8PrALolV0lp0jIOIaRd0s/zNkYq7dMU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQYMhtWulKeKEPXKVTa78faIdCKc0YQgIQ+1vPfXxW7c8P6coIJtoP4+GcDTmAc1Q
	 BH7QQ9pr4tQHHSCIEnbD0VGPJJ/ni2yfAZ+64niK59e2KWDZyu5QbUvj/Vs4jUtzkR
	 sQu42Exn0o+IPKtE7EV9mmfVz9gUdXq8DRpR3bjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0804/1257] cxl/events: Test CME counter expiry with equality, not bitwise AND
Date: Sat,  7 Nov 2026 08:51:40 -0500
Message-ID: <20261107135001.540976818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit b94ba9a1f2d5c57f2eec67d502bb8fdd1e53c87a ]

The Memory Event Type field in the General Media and DRAM event records
is an enumeration, not a bitmask. The validity checks for the advanced
programmable CME counter expiration event (05h) test the field with a
bitwise AND, so types 01h, 03h, 04h and 06h match it as well.

A device reporting one of those types trips WARN_ON_ONCE once the
general media or DRAM tracepoint is enabled, which is the case anywhere
rasdaemon collects CXL events. Under panic_on_warn=1 that kills the
machine.

Compare the type field for equality instead. Type 05h records that do
violate the spec conditions still warn.

Fixes: cd3b36cfc659 ("cxl/events: Add extra validity checks for corrected memory error count in General Media Event Record")
Fixes: d8145bb8af5c ("cxl/events: Add extra validity checks for CVME count in DRAM Event Record")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922082214.3526355-1-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 55828a836c01a..01341f524a937 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -942,11 +942,11 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 
 			if (evt->gen_media.media_hdr.descriptor &
 			    CXL_GMER_EVT_DESC_THRESHOLD_EVENT)
-				WARN_ON_ONCE((evt->gen_media.media_hdr.type &
+				WARN_ON_ONCE((evt->gen_media.media_hdr.type ==
 					      CXL_GMER_MEM_EVT_TYPE_AP_CME_COUNTER_EXPIRE) &&
 					     !get_unaligned_le24(evt->gen_media.cme_count));
 			else
-				WARN_ON_ONCE(evt->gen_media.media_hdr.type &
+				WARN_ON_ONCE(evt->gen_media.media_hdr.type ==
 					     CXL_GMER_MEM_EVT_TYPE_AP_CME_COUNTER_EXPIRE);
 
 			trace_cxl_general_media(cxlmd, type, cxlr, hpa,
@@ -957,11 +957,11 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 
 			if (evt->dram.media_hdr.descriptor &
 			    CXL_GMER_EVT_DESC_THRESHOLD_EVENT)
-				WARN_ON_ONCE((evt->dram.media_hdr.type &
+				WARN_ON_ONCE((evt->dram.media_hdr.type ==
 					      CXL_DER_MEM_EVT_TYPE_AP_CME_COUNTER_EXPIRE) &&
 					     !get_unaligned_le24(evt->dram.cvme_count));
 			else
-				WARN_ON_ONCE(evt->dram.media_hdr.type &
+				WARN_ON_ONCE(evt->dram.media_hdr.type ==
 					     CXL_DER_MEM_EVT_TYPE_AP_CME_COUNTER_EXPIRE);
 
 			trace_cxl_dram(cxlmd, type, cxlr, hpa, hpa_alias,
-- 
2.53.0



