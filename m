Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373DB346FA2;
	Tue, 11 Nov 2025 01:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824252; cv=none; b=lM2kKXOy0q4BkzCvuZwIRcuo1rQ5JRI27OA7FJ2tqvAIzZOzO85DzhcSgA3oWBb+ltmt8fmxf8Zg/ZoXqB4+3pNqcrLKMOFnQf17NbQ6wJRko2vcGZdRqrsuquFE99fjq6FBcaUAZJRCv7ssWxPg/8asW8l5wYy4kWGDxLOSrvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824252; c=relaxed/simple;
	bh=pX180A4+ADs8DFMZALPf2YoWW/k9gpMUjnp9JCqUKIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVn4eWhb8dv6d/G4BtYgCN3NI5PM27dTlND3vFCjFsbU4xl1aEwRVvevSeDaEtyYHANk6uFjxzIk0B16I1C5Dfjn/ejPKoWv1V6Hvwz5fh8+5Ob+XkgAVTmgaTAVEM6qMf6GCqNPMQqIuIp/C5lb3dT/a4Exkq1SwSVSzEJIHd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2Qt0Yze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2Qt0Yze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEA8C19421;
	Tue, 11 Nov 2025 01:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824252;
	bh=pX180A4+ADs8DFMZALPf2YoWW/k9gpMUjnp9JCqUKIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2Qt0YzeFammEMWBobAef63dipziq+6l342ERrAGvyszeQHunSXC0x0ql3eTo96nI
	 oMB284tsXhhi0KHxC8GlfvD/7iMBxJLbgKbZCj9OMm6T763BwVcymSmP0xDbrrMQR+
	 gIEtoliNsZa9Y1KDp5e0VLR6z99FotgIrl+Ziy84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 453/849] drm/amdgpu: Correct info field of bad page threshold exceed CPER
Date: Tue, 11 Nov 2025 09:40:23 +0900
Message-ID: <20251111004547.380081674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit f320ed01cf5f2259e2035a56900952cb3cc77e7a ]

Correct valid_bits and ms_chk_bits of section info field for bad page
threshold exceed CPER to match OOB's behavior.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index ee937d617c826..54de38dbaf2d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -68,7 +68,6 @@ void amdgpu_cper_entry_fill_hdr(struct amdgpu_device *adev,
 	hdr->error_severity		= sev;
 
 	hdr->valid_bits.platform_id	= 1;
-	hdr->valid_bits.partition_id	= 1;
 	hdr->valid_bits.timestamp	= 1;
 
 	amdgpu_cper_get_timestamp(&hdr->timestamp);
@@ -220,7 +219,10 @@ int amdgpu_cper_entry_fill_bad_page_threshold_section(struct amdgpu_device *adev
 	section->hdr.valid_bits.err_context_cnt = 1;
 
 	section->info.error_type = RUNTIME;
+	section->info.valid_bits.ms_chk = 1;
 	section->info.ms_chk_bits.err_type_valid = 1;
+	section->info.ms_chk_bits.err_type = 1;
+	section->info.ms_chk_bits.pcc = 1;
 	section->ctx.reg_ctx_type = CPER_CTX_TYPE_CRASH;
 	section->ctx.reg_arr_size = sizeof(section->ctx.reg_dump);
 
-- 
2.51.0



