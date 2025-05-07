Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E6428C024;
	Wed,  7 May 2025 19:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644411; cv=none; b=D175zjLWxtUygaR2hbiHXYwSLIfIIypG0F+CSxprc+JwvKqoEswl0NiIO9OuAC+riOX3xpkssbVkGz4ny0/dtcZOS7bHwk0dZFxx3AkYg2r4/6Od9dtRq+4EJ4Dc1I/ndO0C9HayHJCyzHQg/B87ALy7+QunpsBqb8ob8D2Jd0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644411; c=relaxed/simple;
	bh=XdZBWymM8zTLllOxbbWw9XhouC9uEvcnGx/HKLEAFbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+ZrJX/5ZIAbCWv4wQfVDGUL3G9L1m25RZIuJefBrmOZESeLrE/dR1Qsg/GigJQaypiMGUpd1fPMZoa8aRUi9Av2lZ9HtMg0A6giBQ+2YGczjVKb0oWNu9fxRxE4h6JlSvbRR0ugvnFiJmhANz2BCzG9Yf2f4wja043viK5JAMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gs1Fh+yQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gs1Fh+yQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3A2C4CEE2;
	Wed,  7 May 2025 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644411;
	bh=XdZBWymM8zTLllOxbbWw9XhouC9uEvcnGx/HKLEAFbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gs1Fh+yQpXM82WyPUV1xWSZVUSbWlwpDw1MrKDLzIWJ85RHTt7lF0zPWeZzDU1p9Y
	 tfI+rwUvqankL19T0mdr0jywnwUrzM6gFP466VVAPkmZ4ObbAfXmmKm9J+lIle+vza
	 zQB7DhiB0DkkUQvfkGqZxsIngJf8qB5OqUWPeras=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 035/164] drm/amdgpu: Fix offset for HDP remap in nbio v7.11
Date: Wed,  7 May 2025 20:38:40 +0200
Message-ID: <20250507183822.296544211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

commit 79af0604eb80ca1f86a1f265a0b1f9d4fccbc18f upstream.

APUs in passthrough mode use HDP flush. 0x7F000 offset used for
remapping HDP flush is mapped to VPE space which could get power gated.
Use another unused offset in BIF space.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d8116a32cdbe456c7f511183eb9ab187e3d590fb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_11.c
@@ -361,7 +361,7 @@ static void nbio_v7_11_get_clockgating_s
 		*flags |= AMD_CG_SUPPORT_BIF_LS;
 }
 
-#define MMIO_REG_HOLE_OFFSET (0x80000 - PAGE_SIZE)
+#define MMIO_REG_HOLE_OFFSET 0x44000
 
 static void nbio_v7_11_set_reg_remap(struct amdgpu_device *adev)
 {


