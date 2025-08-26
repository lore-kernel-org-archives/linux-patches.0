Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB8C27A917;
	Tue, 26 Aug 2025 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207523; cv=none; b=uHsNrY/L+PCwRhDotKx/GlCdAalqRcLuDYx/lHRcCNxy3q2x0mgZ9jWJVPKNm2OP3JzOIJoeB0DUK7YrccEn2SOkw31jxCRIBcBZKlmEKRkpPucSl8ImXX26Q0EsKubWQvSp4gY0wv85BMWCrn9McNQVcNmtp2XijdydC0T9KTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207523; c=relaxed/simple;
	bh=jT5f7Fj35mChPeSKA+E+ea2PUy2q8bGCE0biwjoDMVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6oLjW6ZWxDSMzjxi6q3ldHq5v/5hF/XqY47goB+gSDu4tvujFTSdbb/SgXYSXk3SW2Nue9W6Iec6hudYNsJFCBhQkrySMr7awKCAIawPlrTiCfFRAW9WL9jfEIA9CqFVdDfbiaSj2fMcoKOjgIJpNHN0S76MuYjw2pvwyazyXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmBzSKf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmBzSKf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D02C4CEF1;
	Tue, 26 Aug 2025 11:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207522;
	bh=jT5f7Fj35mChPeSKA+E+ea2PUy2q8bGCE0biwjoDMVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmBzSKf862V+pnqUPZIAUNrRJV7bvHWb6avTbEdXeudHC4WiEJ3/rDziB2YW2w/Yc
	 +tDXf/R5g4l1zqYWnYHsAWjOeZ88nlsiS2tY8/PaEEJBESolPRMbGktHINCHVXJoxw
	 vXBmpg2qV4OLPMdYd2ajnn9jf4lCFbGWu9GK2Q0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 183/457] drm/amdgpu: update mmhub 4.1.0 client id mappings
Date: Tue, 26 Aug 2025 13:07:47 +0200
Message-ID: <20250826110941.895534794@linuxfoundation.org>
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

commit a0b34e4c8663b13e45c78267b4de3004b1a72490 upstream.

Update the client id mapping so the correct clients
get printed when there is a mmhub page fault.

Tested-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Reviewed-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c |   34 +++++++++++-------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
@@ -37,39 +37,31 @@
 static const char *mmhub_client_ids_v4_1_0[][2] = {
 	[0][0] = "VMC",
 	[4][0] = "DCEDMC",
-	[5][0] = "DCEVGA",
 	[6][0] = "MP0",
 	[7][0] = "MP1",
 	[8][0] = "MPIO",
-	[16][0] = "HDP",
-	[17][0] = "LSDMA",
-	[18][0] = "JPEG",
-	[19][0] = "VCNU0",
-	[21][0] = "VSCH",
-	[22][0] = "VCNU1",
-	[23][0] = "VCN1",
-	[32+20][0] = "VCN0",
-	[2][1] = "DBGUNBIO",
+	[16][0] = "LSDMA",
+	[17][0] = "JPEG",
+	[19][0] = "VCNU",
+	[22][0] = "VSCH",
+	[23][0] = "HDP",
+	[32+23][0] = "VCNRD",
 	[3][1] = "DCEDWB",
 	[4][1] = "DCEDMC",
-	[5][1] = "DCEVGA",
 	[6][1] = "MP0",
 	[7][1] = "MP1",
 	[8][1] = "MPIO",
 	[10][1] = "DBGU0",
 	[11][1] = "DBGU1",
-	[12][1] = "DBGU2",
-	[13][1] = "DBGU3",
+	[12][1] = "DBGUNBIO",
 	[14][1] = "XDP",
 	[15][1] = "OSSSYS",
-	[16][1] = "HDP",
-	[17][1] = "LSDMA",
-	[18][1] = "JPEG",
-	[19][1] = "VCNU0",
-	[20][1] = "VCN0",
-	[21][1] = "VSCH",
-	[22][1] = "VCNU1",
-	[23][1] = "VCN1",
+	[16][1] = "LSDMA",
+	[17][1] = "JPEG",
+	[18][1] = "VCNWR",
+	[19][1] = "VCNU",
+	[22][1] = "VSCH",
+	[23][1] = "HDP",
 };
 
 static uint32_t mmhub_v4_1_0_get_invalidate_req(unsigned int vmid,


