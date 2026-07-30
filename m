Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA095431488;
	Thu, 30 Jul 2026 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422327; cv=none; b=qbe+PyjVNdtm3lR0BpKBwjBJdPGrS1xaCyA8cW9a6MoBF/YDIhKQMgt5w4EVcZ2zHbp6UgCXMmT/eIZvqlNIuViMvLIbHA+afSKq3Tb5piyVaizy8KyPzVq89QYJs5fFO5Zm/Ar2PwjXivzW0IjbU+XbhE5hkU4BOTD84Dfk2EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422327; c=relaxed/simple;
	bh=mQjBvitvnPl24qyrczl5Em8rX8T932O0ZluVGVccEfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUYEHiHVQuLE6/BcH12ftDTp92kX5rDJkX/+P1Ph8K4Kb9TDhrUPqm+Lmjsqx47CqrOj6DM91koTxZBYYPHL0Gx96RBtHNaE6Dp3iS4yAkd71wGwPxDDXd4ZIQu0kH1djdQmpjmB4HFdjyx7TGSXuafo43+417UK/Xl3pwJuQz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhzNhqDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhzNhqDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4DA1F00A3E;
	Thu, 30 Jul 2026 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422326;
	bh=jCycmxTv2JjmXXky+XZVm2eWg+2eh5EFsFbBlTAJfOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhzNhqDBfZq8xlowYCQj/6VmA2yBMHdvc7Io8mbyxh3MmkkvP2eSAYfVneGpCrJc5
	 lLPBkplKome1Vveg4sxDjAB382jvBO+xh718hbNf+DosR8Im6kgLFB9RLZA7vc8m+U
	 FDerPWixws07DyDeYJ/5ERrKQf2BPN9XwgTV+rog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.1 399/744] drm/xe/oa: Fix offset alignment for MERT WHITELIST_OA_MERT_MMIO_TRG
Date: Thu, 30 Jul 2026 16:11:12 +0200
Message-ID: <20260730141452.771622195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit 959b5016e4646b55fd2fd0438932e4c4e9ce171f upstream.

'head' argument for WHITELIST_OA_MERT_MMIO_TRG was previously wrong (not
multiple of 16). Fix this.

Fixes: ec02e49f21bc ("drm/xe/rtp: Whitelist OAMERT MMIO trigger registers")
Cc: stable@vger.kernel.org
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/20260629172634.1100983-1-ashutosh.dixit@intel.com
(cherry picked from commit f6c23e4589bdc69a5d2f79aed5c5bddd5d406cbe)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -110,7 +110,7 @@ static const struct xe_rtp_entry_sr regi
 			      OAM_HEAD_POINTER(XE_OAM_SCMI_1_BASE_ADJ))
 
 #define WHITELIST_OA_MERT_MMIO_TRG \
-	WHITELIST_OA_MMIO_TRG(OAMERT_MMIO_TRG, OAMERT_STATUS, OAMERT_HEAD_POINTER)
+	WHITELIST_OA_MMIO_TRG(OAMERT_MMIO_TRG, OAMERT_STATUS, OAMERT_TAIL_POINTER)
 
 	{ XE_RTP_NAME("oag_mmio_trg_rcs"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1200, XE_RTP_END_VERSION_UNDEFINED),


