Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1713B7746;
	Mon, 23 Mar 2026 14:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274531; cv=none; b=e69qfchq5wh7I77LHxQ8QpVs+g8dMo/uROnYqgfWYbPxeR06dtC7W+sjdIIWH6f08rbtZ5JcBP4W/mtWUrlYCEcK1ih/YlwloOV4+sOoHs/jI3UYPTCY33fCVqaFk4QtoHpneabdLk4KTpHDmoET58l1v4I7h84q+huJDLW9lAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274531; c=relaxed/simple;
	bh=HTXieEYFZTpVvq98jgSqFRjasoAXu9IOLxxusSOkLHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7w9H6s1Yol7dwmUv0tszme0jmujaEH/e9o7T1CQMfaS6NkXTRxZJgUeQWZ8tPSXGeklBtdwnmJ/IWseqiPncqN3tSOBNSL81Fj0hM0O8dnVGyHJfO/i8bS2YEkxe0/xVPuq2aBwzwC/WiMC1FEUi3GtWnZOSP0GVNPtp9yZ3Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLPBRetD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLPBRetD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8BAC2BC9E;
	Mon, 23 Mar 2026 14:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274530;
	bh=HTXieEYFZTpVvq98jgSqFRjasoAXu9IOLxxusSOkLHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLPBRetDTrk7GyrqurSidPhbj6Qvur4kknYWSod4ygtjH4c9Huz4rIPcSU+7anAfy
	 t+AyFaYlQoH/cep3HCA2KFO3AOQL1l780T6hxX9BD1ydDgVhTC1ZobbQc11D5dc7Ul
	 PzD+qVjESO4fJN7HT8O77I0TpupNrxchH0fuw1Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.18 026/212] drm/i915/dsc: Add Selective Update register definitions
Date: Mon, 23 Mar 2026 14:44:07 +0100
Message-ID: <20260323134504.580391915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

commit c2c79c6d5b939ae8a42ddb884f576bddae685672 upstream.

Add definitions for DSC_SU_PARAMETER_SET_0_DSC0 and
DSC_SU_PARAMETER_SET_0_DSC1 registers. These are for Selective Update Early
Transport configuration.

Bspec: 71709
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260304113011.626542-3-jouni.hogander@intel.com
(cherry picked from commit 24f96d903daf3dcf8fafe84d3d22b80ef47ba493)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vdsc_regs.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_vdsc_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_vdsc_regs.h
@@ -196,6 +196,18 @@
 #define   DSC_PPS18_NSL_BPG_OFFSET(offset)	REG_FIELD_PREP(DSC_PPS18_NSL_BPG_OFFSET_MASK, offset)
 #define   DSC_PPS18_SL_OFFSET_ADJ(offset)	REG_FIELD_PREP(DSC_PPS18_SL_OFFSET_ADJ_MASK, offset)
 
+#define _LNL_DSC0_SU_PARAMETER_SET_0_PA		0x78064
+#define _LNL_DSC1_SU_PARAMETER_SET_0_PA		0x78164
+#define _LNL_DSC0_SU_PARAMETER_SET_0_PB		0x78264
+#define _LNL_DSC1_SU_PARAMETER_SET_0_PB		0x78364
+#define LNL_DSC0_SU_PARAMETER_SET_0(pipe)	_MMIO_PIPE((pipe), _LNL_DSC0_SU_PARAMETER_SET_0_PA, _LNL_DSC0_SU_PARAMETER_SET_0_PB)
+#define LNL_DSC1_SU_PARAMETER_SET_0(pipe)	_MMIO_PIPE((pipe), _LNL_DSC1_SU_PARAMETER_SET_0_PA, _LNL_DSC1_SU_PARAMETER_SET_0_PB)
+
+#define   DSC_SUPS0_SU_SLICE_ROW_PER_FRAME_MASK		REG_GENMASK(31, 20)
+#define   DSC_SUPS0_SU_SLICE_ROW_PER_FRAME(rows)	REG_FIELD_PREP(DSC_SUPS0_SU_SLICE_ROW_PER_FRAME_MASK, (rows))
+#define   DSC_SUPS0_SU_PIC_HEIGHT_MASK			REG_GENMASK(15, 0)
+#define   DSC_SUPS0_SU_PIC_HEIGHT(h)			REG_FIELD_PREP(DSC_SUPS0_SU_PIC_HEIGHT_MASK, (h))
+
 /* Icelake Rate Control Buffer Threshold Registers */
 #define DSCA_RC_BUF_THRESH_0			_MMIO(0x6B230)
 #define DSCA_RC_BUF_THRESH_0_UDW		_MMIO(0x6B230 + 4)


