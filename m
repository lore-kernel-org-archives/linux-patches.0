Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B5970838;
	Mon, 23 Jun 2025 21:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712834; cv=none; b=qiQ54qAGTH/hEUqrTL0cWwD7C+DqV+yf78/3VZ4sCdVT7uvhfbQ7ZaGW2zmPyNVg9y1OgSDi9AacTK5ND2oxX39TYuttfCZx6G+o81vqjFZUvb8IHA3C5mi14V9W/mrQ2QjP0YEGcI0K5uBtPKB84lEi3PnnX5DDwhC6K/Oane0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712834; c=relaxed/simple;
	bh=61XPAPFhdQUYQLV9OdNyJtMS48aiJXw7w7jdhiAIC/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWD/ElIqVne//7Tv19x9NfAaxwD5TfDg5KLILFkD7dMX3F5qTFlY/eV/8Gdr9VmSlVn09sV2gXxgjyMQC8eXSPwvFVtGMBol5Yn5jNa9zl943IFg7FP1pXeYJEWOSZ3h9uvKjSnRp48JhMJswysQ/5Ah4Dbfhy2o4a8DqrJFA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahTl/PTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahTl/PTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2FCC4CEEA;
	Mon, 23 Jun 2025 21:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712834;
	bh=61XPAPFhdQUYQLV9OdNyJtMS48aiJXw7w7jdhiAIC/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahTl/PTGyd8O4wixYagOr8XMM9QNCG9VpbjKieSI0DIahyczY14PvFjOf5E3JqCMB
	 +7B+WNnsLDRUvuuCtgt+K/wGeHVpUEjswi64XNXOBUxpEtg+d8WsKom7qgCJPJuJXJ
	 0BwbQk+bmRmW216VEXLgLEt3T6k5APnxGh4ifbm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	TungYu Lu <tungyu.lu@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 296/592] drm/amd/display: Correct prefetch calculation
Date: Mon, 23 Jun 2025 15:04:14 +0200
Message-ID: <20250623130707.422599012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: TungYu Lu <tungyu.lu@amd.com>

[ Upstream commit 33bc89949b4366dff2dca30bc61ba1c0cbcd2ab2 ]

[Why]
The minimum value of the dst_y_prefetch_equ was not correct
in prefetch calculation whice causes OPTC underflow.

[How]
Add the min operation of dst_y_prefetch_equ in prefetch calculation
for legacy DML.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: TungYu Lu <tungyu.lu@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c   | 1 +
 drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c   | 1 +
 drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index f1fe49401bc0a..8d24763938ea6 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -1002,6 +1002,7 @@ static bool CalculatePrefetchSchedule(
 
 	dst_y_prefetch_equ = VStartup - (Tsetup + dml_max(TWait + TCalc, *Tdmdl)) / LineTime
 			- (*DSTYAfterScaler + *DSTXAfterScaler / myPipe->HTotal);
+	dst_y_prefetch_equ = dml_min(dst_y_prefetch_equ, 63.75); // limit to the reg limit of U6.2 for DST_Y_PREFETCH
 
 	Lsw_oto = dml_max(PrefetchSourceLinesY, PrefetchSourceLinesC);
 	Tsw_oto = Lsw_oto * LineTime;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
index f567a9023682d..ed59c77bc6f60 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
@@ -1105,6 +1105,7 @@ static bool CalculatePrefetchSchedule(
 	Tr0_oto_lines = dml_ceil(4.0 * Tr0_oto / LineTime, 1) / 4.0;
 	dst_y_prefetch_oto = Tvm_oto_lines + 2 * Tr0_oto_lines + Lsw_oto;
 	dst_y_prefetch_equ =  VStartup - (*TSetup + dml_max(TWait + TCalc, *Tdmdl)) / LineTime - (*DSTYAfterScaler + *DSTXAfterScaler / myPipe->HTotal);
+	dst_y_prefetch_equ = dml_min(dst_y_prefetch_equ, 63.75); // limit to the reg limit of U6.2 for DST_Y_PREFETCH
 	dst_y_prefetch_equ = dml_floor(4.0 * (dst_y_prefetch_equ + 0.125), 1) / 4.0;
 	Tpre_rounded = dst_y_prefetch_equ * LineTime;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
index 5865e8fa2d8e8..9f3938a50240f 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
@@ -1123,6 +1123,7 @@ static bool CalculatePrefetchSchedule(
 	Tr0_oto_lines = dml_ceil(4.0 * Tr0_oto / LineTime, 1) / 4.0;
 	dst_y_prefetch_oto = Tvm_oto_lines + 2 * Tr0_oto_lines + Lsw_oto;
 	dst_y_prefetch_equ =  VStartup - (*TSetup + dml_max(TWait + TCalc, *Tdmdl)) / LineTime - (*DSTYAfterScaler + *DSTXAfterScaler / myPipe->HTotal);
+	dst_y_prefetch_equ = dml_min(dst_y_prefetch_equ, 63.75); // limit to the reg limit of U6.2 for DST_Y_PREFETCH
 	dst_y_prefetch_equ = dml_floor(4.0 * (dst_y_prefetch_equ + 0.125), 1) / 4.0;
 	Tpre_rounded = dst_y_prefetch_equ * LineTime;
 
-- 
2.39.5



