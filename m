Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041A5762E0;
	Mon, 15 Apr 2024 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191513; cv=none; b=OlG9b/Q4MUEggde/TrDKhvcItNnxFdwtNx7G44GVmGelZPdUQjUe4fHnt3puEt9K9Aczo3SJ2n9o+KSnvAC+LCxhUk/c2oGjkIL6gQ4+s+O1ip457OhPf30cexu93sIjNXGc507+5FFq4yw8VUSK7JMQSVnOXQJq/J2VAXM+KMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191513; c=relaxed/simple;
	bh=ou1ophFy+LpeSI1Y/jkopvmZCuxyrvIXq0q5JLbcIpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKIYshyAGhw0cM0V5+1WQb7rR2Y1VZtqDAjF69jGqdqcdjZNDAsEV9xbwq6AbujSBExRIGr5aDqtR+1hqbcc+SkfesBD4+vJ12hQEale7icyzFi2HiiE/bUuqhzzH5FPDco6x6YSPL7+pwYehWL+XFYw+cV+Fcr55i6RxzXrRcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ0/4zt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ0/4zt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D93CC113CC;
	Mon, 15 Apr 2024 14:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191512;
	bh=ou1ophFy+LpeSI1Y/jkopvmZCuxyrvIXq0q5JLbcIpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZ0/4zt9o7SWUIXCXaf8a3lb2soFMnDbFVHbpqjBdC68/6+f7d/HoaffLOCkSdJ+1
	 JthmGRRmcTIxjw1HshIcDF9XE6Mv1n7PjUpvVCK9l9lZaM98CujzFMMTqNl8WUes5J
	 bV7b6Xnffvbre1XE8ZEUzM19maCQYaxETwFn1mdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 166/172] drm/amdgpu: differentiate external rev id for gfx 11.5.0
Date: Mon, 15 Apr 2024 16:21:05 +0200
Message-ID: <20240415142005.391667578@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 6dba20d23e85034901ccb765a7ca71199bcca4df upstream.

This patch to differentiate external rev id for gfx 11.5.0.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -712,7 +712,10 @@ static int soc21_common_early_init(void
 			AMD_PG_SUPPORT_VCN |
 			AMD_PG_SUPPORT_JPEG |
 			AMD_PG_SUPPORT_GFX_PG;
-		adev->external_rev_id = adev->rev_id + 0x1;
+		if (adev->rev_id == 0)
+			adev->external_rev_id = 0x1;
+		else
+			adev->external_rev_id = adev->rev_id + 0x10;
 		break;
 	default:
 		/* FIXME: not supported yet */


