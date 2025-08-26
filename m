Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411BA1F4CA9;
	Tue, 26 Aug 2025 13:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214959; cv=none; b=JIEe9YJz8a/7B4smfFvv9vHnqNREzg01JndeZfSobi+UebVTh7BmoQ5rAFQalxQv825zra58QB8FWfz65NwlIVCv5mIPQlZT6CXxLRgk4FBGyvu1MyXf2R5oLhWtEqwzigZTTGX2mWbo7PIRSK4mb1h4m447VhgjDPaxkwVZn0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214959; c=relaxed/simple;
	bh=Mi6MqbmuSPDUx2vkGGAFyZZXdadNbTnlLndlnv+pOlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUambBydtMryc1eRhrz3S0taeFryuMAhWbaeekUG6troh1O6/iXC9CIIrLYGqrlFRoYWoLi81HSw33E1nEp9ZTnOuMuwXsR/hfnuD94FweJASl3YUsCGipnvtSXDAoorknuWsD8ldXxnqh66Dam+Mey7+qI9vkRNcQGn03DSXxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY6yT5WY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY6yT5WY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C872AC4CEF1;
	Tue, 26 Aug 2025 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214959;
	bh=Mi6MqbmuSPDUx2vkGGAFyZZXdadNbTnlLndlnv+pOlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AY6yT5WYfxw71g/DCpWsNuOcOiNxVEJ86XmVtM+LnIQtHQyUn7oQCvNmch+NUpsT/
	 EYlXNQnCJDYaLtpqHrgR4FWsl/uQvkSLlOq9ieOGVIPJikyaMCORgOL6jijyQL8bi9
	 Sy82HR/bjXg4wVgoaikBijMOkFn0+oQ2qYmZith0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 335/482] drm/amdgpu: update mmhub 3.0.1 client id mappings
Date: Tue, 26 Aug 2025 13:09:48 +0200
Message-ID: <20250826110939.102756830@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0bae62cc989fa99ac9cb564eb573aad916d1eb61 upstream.

Update the client id mapping so the correct clients
get printed when there is a mmhub page fault.

Reviewed-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2a2681eda73b99a2c1ee8cdb006099ea5d0c2505)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c |   57 ++++++++++++++++--------------
 1 file changed, 32 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
@@ -36,40 +36,47 @@
 
 static const char *mmhub_client_ids_v3_0_1[][2] = {
 	[0][0] = "VMC",
+	[1][0] = "ISPXT",
+	[2][0] = "ISPIXT",
 	[4][0] = "DCEDMC",
 	[5][0] = "DCEVGA",
 	[6][0] = "MP0",
 	[7][0] = "MP1",
-	[8][0] = "MPIO",
-	[16][0] = "HDP",
-	[17][0] = "LSDMA",
-	[18][0] = "JPEG",
-	[19][0] = "VCNU0",
-	[21][0] = "VSCH",
-	[22][0] = "VCNU1",
-	[23][0] = "VCN1",
-	[32+20][0] = "VCN0",
-	[2][1] = "DBGUNBIO",
+	[8][0] = "MPM",
+	[12][0] = "ISPTNR",
+	[14][0] = "ISPCRD0",
+	[15][0] = "ISPCRD1",
+	[16][0] = "ISPCRD2",
+	[22][0] = "HDP",
+	[23][0] = "LSDMA",
+	[24][0] = "JPEG",
+	[27][0] = "VSCH",
+	[28][0] = "VCNU",
+	[29][0] = "VCN",
+	[1][1] = "ISPXT",
+	[2][1] = "ISPIXT",
 	[3][1] = "DCEDWB",
 	[4][1] = "DCEDMC",
 	[5][1] = "DCEVGA",
 	[6][1] = "MP0",
 	[7][1] = "MP1",
-	[8][1] = "MPIO",
-	[10][1] = "DBGU0",
-	[11][1] = "DBGU1",
-	[12][1] = "DBGU2",
-	[13][1] = "DBGU3",
-	[14][1] = "XDP",
-	[15][1] = "OSSSYS",
-	[16][1] = "HDP",
-	[17][1] = "LSDMA",
-	[18][1] = "JPEG",
-	[19][1] = "VCNU0",
-	[20][1] = "VCN0",
-	[21][1] = "VSCH",
-	[22][1] = "VCNU1",
-	[23][1] = "VCN1",
+	[8][1] = "MPM",
+	[10][1] = "ISPMWR0",
+	[11][1] = "ISPMWR1",
+	[12][1] = "ISPTNR",
+	[13][1] = "ISPSWR",
+	[14][1] = "ISPCWR0",
+	[15][1] = "ISPCWR1",
+	[16][1] = "ISPCWR2",
+	[17][1] = "ISPCWR3",
+	[18][1] = "XDP",
+	[21][1] = "OSSSYS",
+	[22][1] = "HDP",
+	[23][1] = "LSDMA",
+	[24][1] = "JPEG",
+	[27][1] = "VSCH",
+	[28][1] = "VCNU",
+	[29][1] = "VCN",
 };
 
 static uint32_t mmhub_v3_0_1_get_invalidate_req(unsigned int vmid,


