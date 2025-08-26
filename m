Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4250393DD1;
	Tue, 26 Aug 2025 11:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208475; cv=none; b=S39JHmxtFIT2OG6yWpF0PkFgujOR/s0+Cpx3GvfOudt96fdVD6umoJ3J/KnH5kUDvmVm7zTW9LYrIYF0XX1PkokAmia35d5AWl+ATwyhN++/4APdOqvnwZuwF1PUIU4keVmYCdvp7mHW5sACsDcwv53jtDH4Bps60FTvwj/qd1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208475; c=relaxed/simple;
	bh=4zi3oAg/r1x81hagi5S5TgFcrDpVDJJHK9Cak/T8AY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crkTKm+lHFgrnduclyBaaUHkr/hxMl+xLgx3BZ7GENo5dAOsV6Iq/RHE8JIsBAy/HzIJWmxyvyEr7r0veVmW7rN9yO7zjIHwMyIGJC0AMcoTLBY2I/C3ahku85FBgsNEWWQnVtfcYtyobyzzL9eVIIBs19F4gdRskTEN7eF0ko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYh2lr9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYh2lr9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719FAC4CEF1;
	Tue, 26 Aug 2025 11:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208474;
	bh=4zi3oAg/r1x81hagi5S5TgFcrDpVDJJHK9Cak/T8AY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYh2lr9EzUO17Zoz2iIlnRfqN35iJ0+fAoyflUwadH1f05CM5vX1bGjxjAHcWig9O
	 tAXvhzTmJzFJLfp4L/M4LJHpt9SdnZZqmIAtfGVsa+j5NUopmzbjNbLTkleWLPO3TO
	 i7QFEfBI98uJPMM6XRKH8sAkzCNjvpCugvsYlXOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 125/322] drm/amdgpu: update mmhub 4.1.0 client id mappings
Date: Tue, 26 Aug 2025 13:09:00 +0200
Message-ID: <20250826110918.886022528@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


