Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8563368276;
	Fri,  7 Aug 2026 14:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114474; cv=none; b=rjs+z6bQxzReFyhDrIZ0JuxMg3qgQDygnXyqrEKHoENk4wjEkeRaQk8422Ps+jRZ9X15YFlj2twuHEVTePgps9mTeEugBjRwKDUn3A9/xbpHdqwizUO0yBLMIovVk9YXwdW6sFEHsLGCwz6ojv50hF/Mcn6nlGIf06HnmZqbTnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114474; c=relaxed/simple;
	bh=Y6TV5gWzH7OnUt6SJdTXkpm+fCKO/ma3hdy/uWCt/38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQFOchMYXIKzPgWNPjukCaFcP4QuiqIhcnxEkc0iDXA4HkIbDn98y2YCr+Qv7JHAmxbo1zxLk4ZSexnmtetb7fA+U0puzcnCBq5CsE8TH9gGBRWj9FPli/TAF4H/v5ALrQDuh63GnYXGNnHRXWgoCvLU12hu8xdFiAjzr1zTRPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlPRNa3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlPRNa3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BDA1F000E9;
	Fri,  7 Aug 2026 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114470;
	bh=feqJGnqFtCLPh/zAqr6cnr6hkPlFJrrp2ynRuSt0to4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlPRNa3tt4Ml9lfBY/amDLt/QPwZJwJwJP8T9xiPn12TxvesOwWFtsh8EFzLhy8dW
	 Py5QpVOhy4HfrHY0QTSJpB+VrpuLlmxPFrdgGoifG5Hp6ofoircrZD2Tr4XQ2WFMVd
	 wKty3almczaRDMsilDEt8m9z3MMhITkaRXPSazmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/337] drm/xe/rtp: Add RING_FORCE_TO_NONPRIV_DENY to OA whitelists
Date: Fri,  7 Aug 2026 16:37:59 +0200
Message-ID: <20260807143424.520711489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit e70086a3a06d276b4a5d9a2c51c9330c6cf72780 ]

Unconditionally whitelisting OA registers is a security violation. Set
RING_FORCE_TO_NONPRIV_DENY bit in OA nonpriv slots, so that OA registers
don't get whitelisted by default after probe, gt reset, resume and engine
reset.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Suggested-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-2-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index ef1bb1b47af09..d75bc87cb3cb1 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -67,10 +67,12 @@ static const struct xe_rtp_entry_sr register_whitelist[] = {
 	  XE_RTP_ACTIONS(WHITELIST(CSBE_DEBUG_STATUS(RENDER_RING_BASE), 0))
 	},
 
+#define WHITELIST_DENY(r, f) WHITELIST(r, (f) | RING_FORCE_TO_NONPRIV_DENY)
+
 #define WHITELIST_OA_MMIO_TRG(trg, status, head) \
-	WHITELIST(trg, RING_FORCE_TO_NONPRIV_ACCESS_RW), \
-	WHITELIST(status, RING_FORCE_TO_NONPRIV_ACCESS_RD), \
-	WHITELIST(head, RING_FORCE_TO_NONPRIV_ACCESS_RD | RING_FORCE_TO_NONPRIV_RANGE_4)
+	WHITELIST_DENY(trg, RING_FORCE_TO_NONPRIV_ACCESS_RW), \
+	WHITELIST_DENY(status, RING_FORCE_TO_NONPRIV_ACCESS_RD), \
+	WHITELIST_DENY(head, RING_FORCE_TO_NONPRIV_ACCESS_RD | RING_FORCE_TO_NONPRIV_RANGE_4)
 
 #define WHITELIST_OAG_MMIO_TRG \
 	WHITELIST_OA_MMIO_TRG(OAG_MMIOTRIGGER, OAG_OASTATUS, OAG_OAHEADPTR)
-- 
2.53.0



