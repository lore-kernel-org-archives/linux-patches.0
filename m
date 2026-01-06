Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD8234F466;
	Tue,  6 Jan 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720490; cv=none; b=pP74QLn3gUhy2lY5xD7QnG1C4bgjoeX1quO+QW9UCjTp2sxElpj4MZNX2ywa/kT3Bvt37C9O3hjfqvwIzNz+eGSyFvhZMlcVhcT3Y4hA7Y0Yn9C2Ooz4htx3fh39N/2jQMPwK3ELid9rARWIngDu/zVLPRnGN5jqweqDqsqt420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720490; c=relaxed/simple;
	bh=W4Ptpyhdv4fFzpz1gEELGccx6oLDbfLpBUbIE49j8II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmPnTQGQcUh96I8WRpv3JlHAUs/iGMmWyGDRZvJ1c2kxQ9sHV/mUi4G3fDufPaTQpxzyXzh0/lgpV8C8Jdy21vdxGU91mzbh3Et3XAtYxl+VVmr5oFS5JL//dAZJf6PuloLE25KrHPCBKTmpC3Nu4UnNSYg9TqVS1Ncah9grg8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKLrKM4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKLrKM4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB230C116C6;
	Tue,  6 Jan 2026 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720490;
	bh=W4Ptpyhdv4fFzpz1gEELGccx6oLDbfLpBUbIE49j8II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKLrKM4V4E+xZ3e/x20FEI9S8EtBY0mnNE459nJeABEs5hC8olxlRr0XMhQmX2Tjq
	 auoOmYfQWJI9a5MQTD5zfQBLlUUGsXwgBQObkLp9vhbhe6WC0YIBE/Kz/fiV69jqX1
	 Mt4+ca61JlE65XLvqkf8yy/QbXeEOEouIFhYxd/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 253/567] drm/amd/display: Fix scratch registers offsets for DCN35
Date: Tue,  6 Jan 2026 18:00:35 +0100
Message-ID: <20260106170500.674567564@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Ray Wu <ray.wu@amd.com>

commit 69741d9ccc7222e6b6f138db67b012ecc0d72542 upstream.

[Why]
Different platforms use differnet NBIO header files,
causing display code to use differnt offset and read
wrong accelerated status.

[How]
- Unified NBIO offset header file across platform.
- Correct scratch registers offsets to proper locations.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4667
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 49a63bc8eda0304ba307f5ba68305f936174f72d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -203,12 +203,12 @@ enum dcn35_clk_src_array_id {
 	NBIO_BASE_INNER(seg)
 
 #define NBIO_SR(reg_name)\
-	REG_STRUCT.reg_name = NBIO_BASE(regBIF_BX2_ ## reg_name ## _BASE_IDX) + \
-				regBIF_BX2_ ## reg_name
+	REG_STRUCT.reg_name = NBIO_BASE(regBIF_BX1_ ## reg_name ## _BASE_IDX) + \
+				regBIF_BX1_ ## reg_name
 
 #define NBIO_SR_ARR(reg_name, id)\
-	REG_STRUCT[id].reg_name = NBIO_BASE(regBIF_BX2_ ## reg_name ## _BASE_IDX) + \
-		regBIF_BX2_ ## reg_name
+	REG_STRUCT[id].reg_name = NBIO_BASE(regBIF_BX1_ ## reg_name ## _BASE_IDX) + \
+		regBIF_BX1_ ## reg_name
 
 #define bios_regs_init() \
 		( \


