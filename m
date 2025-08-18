Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9939322DA3;
	Mon, 18 Aug 2025 13:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523779; cv=none; b=hFPK90xLDgeKvCoGY2t4izkgZg2HDm6qgsaWY3IZ40+JzSTrLnobMgIxJfoKmQ6blGASdW/3aUSZiKzLNHBprqPDw1zTteomV3FJ0M1vI5KWu7www5M9UVpcb50mEjTVE2X3W9/9QWl7qowrmEe/+GsYG9kyiYpfYvVizLwdhDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523779; c=relaxed/simple;
	bh=NoJEhU7JfyyQZeZRmRUxblGxyszg1Veaa94yRy682PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPdcTgrVwU5C2fbw2TTPdIPUZVZbv27i081qIllv9XFgDOlLMAXta2721fOP623vTA3UIg2X9D5dO4rDiBQgPlRptMqDiSNvkzxujclpE/iaW+HrsMTP+tI4sKMsOAnVNvSa6HhIQL4WSGN93NQ2gfFYr0Ug1vJ1HnTtwmenPqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlPOPem7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlPOPem7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67190C4CEF1;
	Mon, 18 Aug 2025 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523778;
	bh=NoJEhU7JfyyQZeZRmRUxblGxyszg1Veaa94yRy682PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlPOPem7mD1qWOCSb61gllXOoUmTfuU5c+dzVJ47WY3wASAt/hB1D3JMciGpYc2fq
	 P2s+iKOF1kShF9Bi1eWsNidrdyNezIwRXq5Nn+IbjsxrF4/qx+Xv64VB8WZxGvBOrv
	 NxIxAhidce+aUObYjW1fXAQ7G3yEcLRHy0uG9RT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 271/515] drm/amdgpu: Use correct severity for BP threshold exceed event
Date: Mon, 18 Aug 2025 14:44:17 +0200
Message-ID: <20250818124508.852443212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 4a33ca3f6ee9a013a423a867426704e9c9d785bd ]

The severity of CPER for BP threshold exceed event should be set as
CPER_SEV_FATAL to match the OOB implementation.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 360e07a5c7c1..1a1f30654b14 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -212,7 +212,7 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 		   NONSTD_SEC_OFFSET(hdr->sec_cnt, idx));
 
 	amdgpu_cper_entry_fill_section_desc(adev, section_desc, true, false,
-					    CPER_SEV_NUM, RUNTIME, NONSTD_SEC_LEN,
+					    CPER_SEV_FATAL, RUNTIME, NONSTD_SEC_LEN,
 					    NONSTD_SEC_OFFSET(hdr->sec_cnt, idx));
 
 	section->hdr.valid_bits.err_info_cnt = 1;
@@ -326,7 +326,9 @@ int amdgpu_cper_generate_bp_threshold_record(struct amdgpu_device *adev)
 		return -ENOMEM;
 	}
 
-	amdgpu_cper_entry_fill_hdr(adev, bp_threshold, AMDGPU_CPER_TYPE_BP_THRESHOLD, CPER_SEV_NUM);
+	amdgpu_cper_entry_fill_hdr(adev, bp_threshold,
+				   AMDGPU_CPER_TYPE_BP_THRESHOLD,
+				   CPER_SEV_FATAL);
 	ret = amdgpu_cper_entry_fill_bad_page_threshold_section(adev, bp_threshold, 0);
 	if (ret)
 		return ret;
-- 
2.39.5



