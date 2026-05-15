Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFEF30569C;
	Fri, 15 May 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862752; cv=none; b=aIzYrwkUmtAnIVj23/Lz+C9kfNySly1s4fc6E7HlvtNAfPeQFQFkti1zBN4pwGOLTLQwlg35q6j2F9J6Nh4ib49bzaGLxaWyGVxd3C6C7sYn3/9WWeuqfQ82P1OBm/r+lcqaxy7aN6CscFq6JhHA9ZhwEHIwXV/JeIYdXd6mydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862752; c=relaxed/simple;
	bh=/3VDThsd8JWFy7cr8aZIYEGowMk4sgRpp6uLEQOj6aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXo4ZZAHrr7pquS6etCTjtZqwZ4OM3pOxkZXJpPl0TwAK+WwdfCDOFP3YjeEs+K0D+8bF9+hC1hInu5utHiFIdIKo3S34ICdUfocj4hI3K6DnEgvfk9o2BA18xhgwJ1gT3Cu00sFpIHLyeL6u51wBxl2yxFf3Ti8Y0lPGYTkjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNIK0RMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNIK0RMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85E3C2BCC7;
	Fri, 15 May 2026 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862752;
	bh=/3VDThsd8JWFy7cr8aZIYEGowMk4sgRpp6uLEQOj6aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNIK0RMC3tlZbZ9UzZPgghh8DgmJdjsI5+dQg1AKNATFoPWKJnc1GcKfKwIg6H54u
	 PZstRbkFTfJbbxYhJpmyQzbFhgccEKlF3VHPJVKcKvaUi2MeYiKjZ8YWy2hdbZNv6C
	 BjMzJGBva8ZpuFCSVvE+bmR2ku0lO4XVZGRHkCGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 132/201] drm/amd: Add missing firmware declaration for PSP v15.0.0
Date: Fri, 15 May 2026 17:49:10 +0200
Message-ID: <20260515154701.425976574@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 2744103f58e8e03ce675c670bbfe3f46034e5f24 upstream.

PSP v15.0.0 needs both TOC and TA firmware. Without the declaration
it won't get included in initramfs and leads to following failure:

```
Direct firmware load for amdgpu/psp_15_0_0_ta.bin failed with error -2
early_init of IP block <psp> failed -19
Fatal error during GPU init
```

Fixes: 9b24f63d825e7 ("drm/amdgpu: Enable support for PSP 15_0_0")
Reviewed-by: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v15_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/psp_v15_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v15_0.c
@@ -32,6 +32,7 @@
 #include "mp/mp_15_0_0_sh_mask.h"
 
 MODULE_FIRMWARE("amdgpu/psp_15_0_0_toc.bin");
+MODULE_FIRMWARE("amdgpu/psp_15_0_0_ta.bin");
 
 static int psp_v15_0_0_init_microcode(struct psp_context *psp)
 {


