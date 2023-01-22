Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161182590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F52AC433D2;
	Sun, 22 Jan 2023 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401287;
	bh=xqecZebR0JzimaC9VSjJNBVm6ncSPCNhvpVR8W6W6go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pd9qjSndwtg1mnuizC53nCTfVgr4ngReLRTMDAgTU3Yhhv7oTx39sBKUmy2ILyxTu
	 4VPZymDCdAyKDOhAfyyrw1sLuohYHV+MgLCH1vhxD79iXuN1ePw4qNxV6wiBqLr6YS
	 mxL2bUxRsoXlvHzcRy62QBrZEiPOOWUjHnBM0rlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 181/193] drm/amdgpu: add tmz support for GC IP v11.0.4
Date: Sun, 22 Jan 2023 16:05:10 +0100
Message-Id: <20230122150254.702090400@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit 2aecbe492a3c0bf4c21f78c099a6f6c205fab0c7 upstream.

Add tmz support for GC 11.0.4.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -549,6 +549,7 @@ void amdgpu_gmc_tmz_set(struct amdgpu_de
 	/* YELLOW_CARP*/
 	case IP_VERSION(10, 3, 3):
 	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
 		/* Don't enable it by default yet.
 		 */
 		if (amdgpu_tmz < 1) {


