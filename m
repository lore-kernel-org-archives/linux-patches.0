Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF3D17E90E;
	Mon, 27 May 2024 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837121; cv=none; b=tUqoApT80VO+dsGGD/vbvp3M/mXAWTlaiWpt9AQE1ty9ZvBKDGRIK3CguE9Q6y3nJuAPtOKW+NW9GEpu5Jw0oJEyE72uaksWif0OF74StPA1lNb9/6b4G6ztUmV3hJPTNXvxwEdMZzSPr/YbHXKUf3cp2G0Y4GTe9yeBQhXHnL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837121; c=relaxed/simple;
	bh=O/gmRJOXr16yRJV9vmOrOVxTDYPdbytwdLk3va7mcMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCgsnIzc/K8frgw2LjCsF+hhPFPko4z2QgIOZy0ds4gRZ5UdJfGmqLyTZdpGMtHgzGURpap2IAJjo6/H91yQOUOlu4FARtCeM7Uhpns4mzPcsukeJ6yzGWgUxPoqGqutVesbQaTOncMF2DT3uyjpu9XuGo+5LyRTjIC/7SORGFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sfFQ9ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sfFQ9ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362D5C2BBFC;
	Mon, 27 May 2024 19:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837121;
	bh=O/gmRJOXr16yRJV9vmOrOVxTDYPdbytwdLk3va7mcMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sfFQ9nsEUtjal8a0tSC2asIihWGyyjzL0jA7eo9IgF0jWgLgvekkXzw6NmafwyYc
	 QAW2Jbu+jBCeqkiPdZTl3kfxDemuzLDDTKzocWtO91/AmsvCg4lo+vHoISWo7IqaDm
	 OmdmSRKNlzbNYbSoNb3Ej6CLx2iWddr0kkOAiOZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david.heidelberg@collabora.com>,
	Vignesh Raman <vignesh.raman@collabora.com>,
	Helen Koike <helen.koike@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 276/427] drm/ci: update device type for volteer devices
Date: Mon, 27 May 2024 20:55:23 +0200
Message-ID: <20240527185628.302313766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 0857773e5c5fd..8bc63912fddb4 100644
--- a/drivers/gpu/drm/ci/test.yml
+++ b/drivers/gpu/drm/ci/test.yml
@@ -252,11 +252,11 @@ i915:cml:
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



