Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E31C13AD05;
	Mon, 27 May 2024 19:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838346; cv=none; b=himQolHz619X5eMC0S6+f7MQyE8LQRUCOC0AtG2Gs5V6RGltSitDYRWEYIUWhKbZYH++Rv4g3NsRg4hijfvAdTORpQRbCpCxbFZhX1DZ5oaythAOMUl2yz5EmYafbdkI57CrIQVGvEAxDp1QZ1CIkCwnh9YoaUrBwvJGpDAxG9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838346; c=relaxed/simple;
	bh=jXV/5EcHCG8kzNos3ZwVTyQzZD3U8PcGtceWR6yb43M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nE87JxctfIP6d8JdfJXMjm7vmFr+kvwu3eV5CwEbNLGXFHd2mtlJVHFeDDOVd/6/Ku3ysF4tIA3x53NJpAgel5ddFb5b/0z5BvzFvIdIlTRICj1+IDCAZXXdPNXFEOJq97bSmjVe3IFwJcPtZnMHNBLyIBRhn8NILYPmffUST3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWPEzhXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWPEzhXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6175C2BBFC;
	Mon, 27 May 2024 19:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838346;
	bh=jXV/5EcHCG8kzNos3ZwVTyQzZD3U8PcGtceWR6yb43M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWPEzhXVl3E0/m/oNKL28JVFdLkHyh9j5muBSD41yrk4Uz4I8NVuIw0il66Wm7WSG
	 b3TS1Vz78XteyrNX+pIKOP/IDrSIJJKtaizzBSCVJv0osG4sD236bUsQ0Erbd8yW/I
	 G8LUrXm6NW++kM84M33aeQ8NT70eXQGXlMcYwcH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david.heidelberg@collabora.com>,
	Vignesh Raman <vignesh.raman@collabora.com>,
	Helen Koike <helen.koike@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 351/493] drm/ci: update device type for volteer devices
Date: Mon, 27 May 2024 20:55:53 +0200
Message-ID: <20240527185641.771101001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Vignesh Raman <vignesh.raman@collabora.com>

[ Upstream commit a2c71b711e7efc6478976233768bdbc3386e6dce ]

Volteer devices in the collabora lab are categorized under the
asus-cx9400-volteer device type. The majority of these units
has an Intel Core i5-1130G7 CPU, while some of them have a
Intel Core i7-1160G7 CPU instead. So due to this difference,
new device type template is added for the Intel Core i5-1130G7
and i7-1160G7 variants of the Acer Chromebook Spin 514 (CP514-2H)
volteer Chromebooks. So update the same in drm-ci.

https://gitlab.collabora.com/lava/lava/-/merge_requests/149

Fixes: 0119c894ab0d ("drm: Add initial ci/ subdirectory")
Reviewed-by: David Heidelberg <david.heidelberg@collabora.com>
Signed-off-by: Vignesh Raman <vignesh.raman@collabora.com>
Acked-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240307021841.100561-1-vignesh.raman@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ci/test.yml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ci/test.yml b/drivers/gpu/drm/ci/test.yml
index 9faf76e55a56a..da381257e7e54 100644
--- a/drivers/gpu/drm/ci/test.yml
+++ b/drivers/gpu/drm/ci/test.yml
@@ -237,11 +237,11 @@ i915:cml:
 i915:tgl:
   extends:
     - .i915
-  parallel: 8
+  parallel: 5
   variables:
-    DEVICE_TYPE: asus-cx9400-volteer
+    DEVICE_TYPE: acer-cp514-2h-1130g7-volteer
     GPU_VERSION: tgl
-    RUNNER_TAG: mesa-ci-x86-64-lava-asus-cx9400-volteer
+    RUNNER_TAG: mesa-ci-x86-64-lava-acer-cp514-2h-1130g7-volteer
 
 .amdgpu:
   extends:
-- 
2.43.0



