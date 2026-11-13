Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590149;
	b=uFOZF1SgppHLt9WZQC6OthRBgSP/4FEXg7HCG1ecfqiRFpZdOubSKx2HgQQHlR37xG4R
	 lsQCHoozBp52Z9KPnIdMSXEFUDdv3W7y4ny8g5EIo2OzR49YERbc9pzhF0C3findhWIHl
	 imc6o6knXbKfmC2y5H+bO05afDRZhcljHcIspJvm0PWgW1UGvYCPawI1h4wvJLQ2UXRay
	 WUkNG94xt3RnMvd7uDBHOLmpg6cd6EPlFUtFNBEPw8C3WNMH/UOEaBQNHtdG2l1NSMKcY
	 BuQ9dywBoNZBqUY6fi+H6ibVD4NhWvgzTmQOfHJSDWMrp1XOU2uWqjoVSvqVVibBl2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I/PQjWftZBo2XHgJcG2oTwm8EkrgTPXK8TRqLs8RhtU=;
	b=OVZFqBT7vi7sq7wreBt1pfsBRchKihjRA/PMAivfE67kHRs6+hi8Q/PDsPNhsatw0Jj7
	 ybgMTbubnLvB9smqZUoYyZbyODDFnGNW9qkuaMdMok8innptvn9XfzLdIjQ/FEWbzOs3f
	 uWrL8guADKgVxdUQ0iqWHhdvNSAUi7sXBmNwCOQJiQGA5xr1vEVkXU6+jVGmPC9MRhSvy
	 QjO2a0DnevFYPxEYTrFnxPkJq0COdXGsb42Ivp7VRYb+oOXdemAae70UFCGeviwta3pb+
	 qN+CqmsXzPUY8TcO0Tj9hlDX5jkQurPuHvdmW7LRGTTAnouHNxONYi/wK7+FpreavjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gS0hLmE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B141606A899;
	Fri, 13 Nov 2026 17:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gS0hLmE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD331F000C4;
	Fri, 13 Nov 2026 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590149;
	bh=I/PQjWftZBo2XHgJcG2oTwm8EkrgTPXK8TRqLs8RhtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gS0hLmE009NuLeW0J9XrffLlTOgqsoJyaaOU9oeyjGBT4Qy1zfcK4LSR1xYViQKQd
	 Hy90wnAkrKCT3r3c3HDNbCzif7PtaF0fn7EaoYQ3qDtvfbL4MMD4uw9Ea4+Qjchd5m
	 sMvWmWLVqgLaqqf7o+GCWIsJ9tvpxUz/2QwMPXCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/686] cxl/events: Test CME counter expiry with equality, not bitwise AND
Date: Fri, 13 Nov 2026 10:44:57 -0500
Message-ID: <20261113153826.350457317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 76731576ebfcc..161a56169f878 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -934,11 +934,11 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 
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
@@ -949,11 +949,11 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 
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



