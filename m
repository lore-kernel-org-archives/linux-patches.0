Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17412239573;
	Tue, 26 Aug 2025 11:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207510; cv=none; b=GK0/z9Uy+fm5vHYms7QxDKJCyGl5cVqsop8w8Z6VSQgRzTUwRk3EI+/9qPVBAX2xpDy++WmrTmW3djSd8jM5uWPqwlvA6eYt4mXruqUUkWTgry1fCT7rtVvqiQg+RQTEBPJl+2nBTjKv+KOK73gzwhrsMd3zJEf35iECMjbWMXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207510; c=relaxed/simple;
	bh=HbViimbbZVn2MbXLEXG6heLHtfqa4is44cmLml+lNjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU+4FJ/Z9rxABDVUhw44SVL12mIIh+dp6DG4MMrDhpnzK/FZxkhmlBwXWY/elzKB2ZDNNHbX03695S3TbLAZcz92skersN3HAyA8n710SG9JgLEl4cYx8wR5Z0LVJQKJ88VHycASFJfs7Mtg9GrixJDdpAK/758qusjg7fX5Sh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wclzAI/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wclzAI/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52E0C4CEF1;
	Tue, 26 Aug 2025 11:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207510;
	bh=HbViimbbZVn2MbXLEXG6heLHtfqa4is44cmLml+lNjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wclzAI/TuMNaCmHcb4j+F8jIxZR9GBkatS80A6OmjAEfgCQMvJMhE5a9mwPLP6F4D
	 /1+lutBTU8gsNmEdqb5H6/9NsVcU0a1TyVGwK38XIf2UnRotZU6320mJaUWD/KqDDW
	 8LJPlyvprfCFDcWR4qL0VHptdEdwoLGYJvzGpCYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 182/457] drm/amdgpu: update mmhub 3.3 client id mappings
Date: Tue, 26 Aug 2025 13:07:46 +0200
Message-ID: <20250826110941.871534831@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9f9bddfa31d87b084700a6e9eca1a8b4f8ddcdf6 upstream.

Update the client id mapping so the correct clients
get printed when there is a mmhub page fault.

v2: fix typos spotted by David Wu.
v3: fix additional typo spotted by David.

Reviewed-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e932f4779a2d329841bb9ca70bb80a4bb2d707b6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c |  105 +++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c
@@ -40,30 +40,129 @@
 
 static const char *mmhub_client_ids_v3_3[][2] = {
 	[0][0] = "VMC",
+	[1][0] = "ISPXT",
+	[2][0] = "ISPIXT",
 	[4][0] = "DCEDMC",
 	[6][0] = "MP0",
 	[7][0] = "MP1",
 	[8][0] = "MPM",
+	[9][0] = "ISPPDPRD",
+	[10][0] = "ISPCSTATRD",
+	[11][0] = "ISPBYRPRD",
+	[12][0] = "ISPRGBPRD",
+	[13][0] = "ISPMCFPRD",
+	[14][0] = "ISPMCFPRD1",
+	[15][0] = "ISPYUVPRD",
+	[16][0] = "ISPMCSCRD",
+	[17][0] = "ISPGDCRD",
+	[18][0] = "ISPLMERD",
+	[22][0] = "ISPXT1",
+	[23][0] = "ISPIXT1",
 	[24][0] = "HDP",
 	[25][0] = "LSDMA",
 	[26][0] = "JPEG",
 	[27][0] = "VPE",
+	[28][0] = "VSCH",
 	[29][0] = "VCNU",
 	[30][0] = "VCN",
+	[1][1] = "ISPXT",
+	[2][1] = "ISPIXT",
 	[3][1] = "DCEDWB",
 	[4][1] = "DCEDMC",
+	[5][1] = "ISPCSISWR",
 	[6][1] = "MP0",
 	[7][1] = "MP1",
 	[8][1] = "MPM",
+	[9][1] = "ISPPDPWR",
+	[10][1] = "ISPCSTATWR",
+	[11][1] = "ISPBYRPWR",
+	[12][1] = "ISPRGBPWR",
+	[13][1] = "ISPMCFPWR",
+	[14][1] = "ISPMWR0",
+	[15][1] = "ISPYUVPWR",
+	[16][1] = "ISPMCSCWR",
+	[17][1] = "ISPGDCWR",
+	[18][1] = "ISPLMEWR",
+	[20][1] = "ISPMWR2",
 	[21][1] = "OSSSYS",
+	[22][1] = "ISPXT1",
+	[23][1] = "ISPIXT1",
 	[24][1] = "HDP",
 	[25][1] = "LSDMA",
 	[26][1] = "JPEG",
 	[27][1] = "VPE",
+	[28][1] = "VSCH",
 	[29][1] = "VCNU",
 	[30][1] = "VCN",
 };
 
+static const char *mmhub_client_ids_v3_3_1[][2] = {
+	[0][0] = "VMC",
+	[4][0] = "DCEDMC",
+	[6][0] = "MP0",
+	[7][0] = "MP1",
+	[8][0] = "MPM",
+	[24][0] = "HDP",
+	[25][0] = "LSDMA",
+	[26][0] = "JPEG0",
+	[27][0] = "VPE0",
+	[28][0] = "VSCH",
+	[29][0] = "VCNU0",
+	[30][0] = "VCN0",
+	[32+1][0] = "ISPXT",
+	[32+2][0] = "ISPIXT",
+	[32+9][0] = "ISPPDPRD",
+	[32+10][0] = "ISPCSTATRD",
+	[32+11][0] = "ISPBYRPRD",
+	[32+12][0] = "ISPRGBPRD",
+	[32+13][0] = "ISPMCFPRD",
+	[32+14][0] = "ISPMCFPRD1",
+	[32+15][0] = "ISPYUVPRD",
+	[32+16][0] = "ISPMCSCRD",
+	[32+17][0] = "ISPGDCRD",
+	[32+18][0] = "ISPLMERD",
+	[32+22][0] = "ISPXT1",
+	[32+23][0] = "ISPIXT1",
+	[32+26][0] = "JPEG1",
+	[32+27][0] = "VPE1",
+	[32+29][0] = "VCNU1",
+	[32+30][0] = "VCN1",
+	[3][1] = "DCEDWB",
+	[4][1] = "DCEDMC",
+	[6][1] = "MP0",
+	[7][1] = "MP1",
+	[8][1] = "MPM",
+	[21][1] = "OSSSYS",
+	[24][1] = "HDP",
+	[25][1] = "LSDMA",
+	[26][1] = "JPEG0",
+	[27][1] = "VPE0",
+	[28][1] = "VSCH",
+	[29][1] = "VCNU0",
+	[30][1] = "VCN0",
+	[32+1][1] = "ISPXT",
+	[32+2][1] = "ISPIXT",
+	[32+5][1] = "ISPCSISWR",
+	[32+9][1] = "ISPPDPWR",
+	[32+10][1] = "ISPCSTATWR",
+	[32+11][1] = "ISPBYRPWR",
+	[32+12][1] = "ISPRGBPWR",
+	[32+13][1] = "ISPMCFPWR",
+	[32+14][1] = "ISPMWR0",
+	[32+15][1] = "ISPYUVPWR",
+	[32+16][1] = "ISPMCSCWR",
+	[32+17][1] = "ISPGDCWR",
+	[32+18][1] = "ISPLMEWR",
+	[32+19][1] = "ISPMWR1",
+	[32+20][1] = "ISPMWR2",
+	[32+22][1] = "ISPXT1",
+	[32+23][1] = "ISPIXT1",
+	[32+26][1] = "JPEG1",
+	[32+27][1] = "VPE1",
+	[32+29][1] = "VCNU1",
+	[32+30][1] = "VCN1",
+};
+
 static uint32_t mmhub_v3_3_get_invalidate_req(unsigned int vmid,
 						uint32_t flush_type)
 {
@@ -102,12 +201,16 @@ mmhub_v3_3_print_l2_protection_fault_sta
 
 	switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
 	case IP_VERSION(3, 3, 0):
-	case IP_VERSION(3, 3, 1):
 	case IP_VERSION(3, 3, 2):
 		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_v3_3) ?
 			    mmhub_client_ids_v3_3[cid][rw] :
 			    cid == 0x140 ? "UMSCH" : NULL;
 		break;
+	case IP_VERSION(3, 3, 1):
+		mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_v3_3_1) ?
+			    mmhub_client_ids_v3_3_1[cid][rw] :
+			    cid == 0x140 ? "UMSCH" : NULL;
+		break;
 	default:
 		mmhub_cid = NULL;
 		break;


