Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D11CFEDB;
	Wed,  2 Oct 2024 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876730; cv=none; b=a7gD8b/m1E7FuJzURRDpdzw1vyU9Un2pQmue7eMfLFDd5fQIx6vl8T5F/31zaJJq/nwW47IS6FKc3VFMwZv/lk+2p4obdA/LPBs5k715VYIv1ZXU1inqAhty/Y4++Gsj+bzPz86fesnnVovrNgdS3Qs6p9dhzOrPkJBF6N2O3Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876730; c=relaxed/simple;
	bh=BCa+L99fVymuKg/vwWafQbFNhJcbQAIP6p58KoXBJN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYXk95ZrbNWDCTSsxzPLCjyoVxiN+DeiFHuXhwTsRadYnqTneiu4rggDjnQ977JM8kYL2fwn7LeBz2fZrrMYGyp4GrUX0Snd+yFHZ1/k9QZgh1mNbIbKTMdEYW5T9ueDPoxVwBO6mOCpM65woB7WHIGkQlip7tomRU65aooBoZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSe6Cy9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSe6Cy9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDEDC4CEC2;
	Wed,  2 Oct 2024 13:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876730;
	bh=BCa+L99fVymuKg/vwWafQbFNhJcbQAIP6p58KoXBJN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSe6Cy9OQWkgDTuFBYKwthzC4Q8PT+xHVHvLqkiR1cPYDbMNt2uJk5DQ1MOw4u8d1
	 xNBFeXlqEC1dEKIfXQUcKagNu+SStzcdn5p8JvV8nnNdk5fr2kwMTFgjsXiZwsPQDb
	 i5xq6BFK94yb8CAhY5FfO0do66mK4wgDt6t0nvgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 543/695] drm/amdgpu: update golden regs for gfx12
Date: Wed,  2 Oct 2024 14:59:01 +0200
Message-ID: <20241002125844.175472954@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Frank Min <Frank.Min@amd.com>

commit 7b6df1d73290961ff0a00fd0022f28dd19e37181 upstream.

update golden regs for gfx12

Signed-off-by: Frank Min <Frank.Min@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -202,12 +202,16 @@ static const struct amdgpu_hwip_reg_entr
 	SOC15_REG_ENTRY_STR(GC, 0, regCP_IB1_BUFSZ)
 };
 
-static const struct soc15_reg_golden golden_settings_gc_12_0[] = {
+static const struct soc15_reg_golden golden_settings_gc_12_0_rev0[] = {
 	SOC15_REG_GOLDEN_VALUE(GC, 0, regDB_MEM_CONFIG, 0x0000000f, 0x0000000f),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, regCB_HW_CONTROL_1, 0x03000000, 0x03000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, regGL2C_CTRL5, 0x00000070, 0x00000020)
 };
 
+static const struct soc15_reg_golden golden_settings_gc_12_0[] = {
+	SOC15_REG_GOLDEN_VALUE(GC, 0, regDB_MEM_CONFIG, 0x00008000, 0x00008000),
+};
+
 #define DEFAULT_SH_MEM_CONFIG \
 	((SH_MEM_ADDRESS_MODE_64 << SH_MEM_CONFIG__ADDRESS_MODE__SHIFT) | \
 	 (SH_MEM_ALIGNMENT_MODE_UNALIGNED << SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) | \
@@ -3446,10 +3450,14 @@ static void gfx_v12_0_init_golden_regist
 	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
+		soc15_program_register_sequence(adev,
+						golden_settings_gc_12_0,
+						(const u32)ARRAY_SIZE(golden_settings_gc_12_0));
+
 		if (adev->rev_id == 0)
 			soc15_program_register_sequence(adev,
-					golden_settings_gc_12_0,
-					(const u32)ARRAY_SIZE(golden_settings_gc_12_0));
+					golden_settings_gc_12_0_rev0,
+					(const u32)ARRAY_SIZE(golden_settings_gc_12_0_rev0));
 		break;
 	default:
 		break;


