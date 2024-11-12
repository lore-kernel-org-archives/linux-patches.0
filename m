Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76A221441B;
	Tue, 12 Nov 2024 10:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408239; cv=none; b=uKGJ0nQBms0GNoSTtVQJMDDgZ1JD2UjMGIuINipLZSFutkmoBhzqyRdT9FDGtOGYfruhxbWlS1jvaI5h0esEIBvgoWiVbDNuRn5oGdmV+B8Pmv6F/V0GCksQ2g3Mt86D9J116zTrqLfGemp29246ad8p97XAEfYKj22FovySXiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408239; c=relaxed/simple;
	bh=1ZwTyRQ+QBLe8Q5kIBh57pnq8ZDJSfz7XAY2utMFv6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp/DUArUkaDL+ClG/oNixYEb+v+H4vmQmKj4eriPDBKR+Er6qntGpHStVb2KZc4MPF88xtMW+RhWUbO1GbDFwFr78HxxvUtdfT0NndnSHCGHWLRwh4FkbFXDPRvRjmwe//VE0P7BDuCXX4QHbMQGRrRPPto7/dFG6hcsDyxeA30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KU8IxZd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KU8IxZd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E9AC4CECD;
	Tue, 12 Nov 2024 10:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408239;
	bh=1ZwTyRQ+QBLe8Q5kIBh57pnq8ZDJSfz7XAY2utMFv6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KU8IxZd28IRFhzB8M+gLs+xgTgK9mG9L1haJYmnq3sqKEvMJ24UpmMWR92JqYgybp
	 3ndzplFrCXGN9Xs8i/sHFl1IDB+zmwd0z1JPHJ11ykP1YoFu0ifH0nTzJyvwy08OLZ
	 1bwALPth+OaCWGGYuLpWUMYr18G9i2u7vOp92D8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 095/184] drm/xe: Set mask bits for CCS_MODE register
Date: Tue, 12 Nov 2024 11:20:53 +0100
Message-ID: <20241112101904.505016779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

commit 7fd3fa006fa56c0ec299c61ecf5c572c723adad5 upstream.

CCS_MODE register requires setting mask bits from Xe2+ platforms. Set
the mask bits unconditionally, as those bits are unused for older
platforms.

Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Cc: stable@vger.kernel.org # v6.11+
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008073628.377433-2-balasubramani.vivekanandan@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 23ea2c7572d4735ef66beb1e4feb8ae510b78247)
[ Fix conflict with mmio refactors ]
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    2 +-
 drivers/gpu/drm/xe/xe_gt_ccs_mode.c  |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -509,7 +509,7 @@
  *   [4-6]     RSVD
  *   [7]       Disabled
  */
-#define CCS_MODE				XE_REG(0x14804)
+#define CCS_MODE				XE_REG(0x14804, XE_REG_OPTION_MASKED)
 #define   CCS_MODE_CSLICE_0_3_MASK		REG_GENMASK(11, 0) /* 3 bits per cslice */
 #define   CCS_MODE_CSLICE_MASK			0x7 /* CCS0-3 + rsvd */
 #define   CCS_MODE_CSLICE_WIDTH			ilog2(CCS_MODE_CSLICE_MASK + 1)
--- a/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
+++ b/drivers/gpu/drm/xe/xe_gt_ccs_mode.c
@@ -68,6 +68,12 @@ static void __xe_gt_apply_ccs_mode(struc
 		}
 	}
 
+	/*
+	 * Mask bits need to be set for the register. Though only Xe2+
+	 * platforms require setting of mask bits, it won't harm for older
+	 * platforms as these bits are unused there.
+	 */
+	mode |= CCS_MODE_CSLICE_0_3_MASK << 16;
 	xe_mmio_write32(gt, CCS_MODE, mode);
 
 	xe_gt_dbg(gt, "CCS_MODE=%x config:%08x, num_engines:%d, num_slices:%d\n",


