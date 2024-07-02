Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00771514DC;
	Tue,  2 Jul 2024 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941235; cv=none; b=JHofdRYkVUk5Mu75Jfx6mwHj9zrrgID7HOekw0HPOE1IA5Kon+pGBUBnfOjRk2PLAJ9zcX6884kSkk+8TD133exVZFZkBD4BFJGLLZOyYWXsUMHLxXOUNsJU6v2PgS28/gR4fqm9nyPgZINlR136Puw8As8goYPyFYAhKO2nQvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941235; c=relaxed/simple;
	bh=Ytw8ylg8k8pk5mrn9Lde8YA8zb16q4XAThw2jANUEWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oorReLfSWMZezom2zVsJbZEjXvzG+2KubyOtoREX8t311a8jrHSD6Cdgvm48cB0ArZSUsvoUNOKHnmuohaO0k3nrRwligrYB73A0yXZEvz765Wb1mnWOrFn5TYBmCfN5s2z7uKtyz2WLxYqupYoOeDm7ikQ+szmkc4jD8UZOp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2CBhXtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2CBhXtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AC2C4AF07;
	Tue,  2 Jul 2024 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941235;
	bh=Ytw8ylg8k8pk5mrn9Lde8YA8zb16q4XAThw2jANUEWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2CBhXtErf74tgPvPZZ4OMWjw56a6rSe0BbC65FKU4ql4TPahJP09Oit7n/B6OIBo
	 UiFriotbGR4lGu3YV3PixLUlVCMbfPZgeWiQm3wQBWH6Fllu98DbH6bU4KdcAfgMpf
	 6JnsVSUQYW2tkVCmxZ8RXYwNbC5EdOsyPvld2SA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 142/163] drm/amdgpu/atomfirmware: fix parsing of vram_info
Date: Tue,  2 Jul 2024 19:04:16 +0200
Message-ID: <20240702170238.428898561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -399,7 +399,7 @@ amdgpu_atomfirmware_get_vram_info(struct
 					mem_channel_number = vram_info->v30.channel_num;
 					mem_channel_width = vram_info->v30.channel_width;
 					if (vram_width)
-						*vram_width = mem_channel_number * (1 << mem_channel_width);
+						*vram_width = mem_channel_number * 16;
 					break;
 				default:
 					return -EINVAL;


