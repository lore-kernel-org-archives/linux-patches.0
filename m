Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233A9234984;
	Mon, 18 Aug 2025 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525534; cv=none; b=q4SoLDR8s6Js1g8rnhosDPt0G7TPEbiS2wwtcmnnc0CTEQx6V6ny7HnX3ibQLMm+sYQGSFMZ+1hfc2B7JjW7QyW3clwMzPpcZMZKr3wyAcIzbf7HodltPkzynMRkKIkRH11tjftG95Qw2khSoaS+QwLig9WGZAEijyEJVuIbG1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525534; c=relaxed/simple;
	bh=4Z31ADIbIiDxIbhgmB3MjIKsjh4DUeGSu/b5YGaA5Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmfWta6vLHr4BFSqhUvvSLzGBra7w3Ps/AuVgRRfLtGS9B8f4lMO+/jqJoylT+5cDG50wGaSX5PGrx6osdm/8AtH3ZOshFiOKY0OGmko9eVndviNudmuSlBPzhE6ohJ0I2M2mu6X4mOcRDatiU5xHihUQngN+cD43Vf0Ff4DKO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNQEXhAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNQEXhAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C940C4CEEB;
	Mon, 18 Aug 2025 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525533;
	bh=4Z31ADIbIiDxIbhgmB3MjIKsjh4DUeGSu/b5YGaA5Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNQEXhAJpMhaZyLsw5gSy56GizJcDljUAOdHdrcCAs4zUo/AgzpA2+NqpPrK6aQLm
	 LjxSx4RsXSQjPwIGoMxLNCzsSLVFmYWyhMOZUNDTADHtzqF8WZn325lj0EjjJIST4H
	 MjiEQ9N1SnPHcy5Kv9AyCQBMIINHYp6AYrnpJR6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 291/570] drm/amdgpu: Use correct severity for BP threshold exceed event
Date: Mon, 18 Aug 2025 14:44:38 +0200
Message-ID: <20250818124517.059816293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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
index 5a234eadae8b..15dde1f50328 100644
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



