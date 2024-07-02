Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE8163D;
	Tue,  2 Jul 2024 17:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941587; cv=none; b=eVAnm711cqeIKx2rqoVeTV9YUP5kAFM++RzazaV2HvsfXPait306K4q3qr1vVvi2UFDSiWExqKQbR8WOACRNbROQeZa2WDqr5RV5B4rfM45KLumzpPnEisdUSj7JIpjhQH+GkYdP0ELhJqc0l80Rv6s5Z+VdJtJutcIg7wWk1x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941587; c=relaxed/simple;
	bh=gzeyXoiVGFP/0uwVbP/TK3ucSsVVHnQKrJqLDQ+M6EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+ABCZhfMHZxdiWiSCe0M59s60+63TN8hId11XRTtxD1Xye6qgantnbHuPLaksrCKUUUiaeCnW48r+kS7OynTwi+hUapdItlTN477yTlddbjhUe7H+oBAddaqsnxvU+xlXxvw3TELwpleBONtXuJ6SRqp2Uak2r4HKc3Fr1PQHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWGpwE/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWGpwE/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2950C116B1;
	Tue,  2 Jul 2024 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941587;
	bh=gzeyXoiVGFP/0uwVbP/TK3ucSsVVHnQKrJqLDQ+M6EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWGpwE/XVJTx6xVo/cjK/Ba7fk5mG9uWvs7LjtWXQoM7mFRbnZYph5A+Eo8Pti27h
	 XJcWjkbgGTHIcW8fzQcz/SBvEnPUo2CLBPdnVycM1WcVGY78+2Vhi/LNYeuKWO4jrw
	 2RbakcXIX+Rh+cA04Xk6NbFdsCp3FkqaJjXBlS7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 109/128] drm/amdgpu/atomfirmware: fix parsing of vram_info
Date: Tue,  2 Jul 2024 19:05:10 +0200
Message-ID: <20240702170230.345649154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit f6f49dda49db72e7a0b4ca32c77391d5ff5ce232 upstream.

v3.x changed the how vram width was encoded.  The previous
implementation actually worked correctly for most boards.
Fix the implementation to work correctly everywhere.

This fixes the vram width reported in the kernel log on
some boards.

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -387,7 +387,7 @@ amdgpu_atomfirmware_get_vram_info(struct
 					mem_channel_number = vram_info->v30.channel_num;
 					mem_channel_width = vram_info->v30.channel_width;
 					if (vram_width)
-						*vram_width = mem_channel_number * (1 << mem_channel_width);
+						*vram_width = mem_channel_number * 16;
 					break;
 				default:
 					return -EINVAL;


