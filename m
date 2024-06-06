Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E631B0122;
	Thu,  6 Jun 2024 14:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683359; cv=none; b=JRemk8WWsl77aG5LoIaBEDrXSekqsFbdWvp9HVomnhXSeft5csbgWnVRKurZZ5C9u3HXysIMIR5zoeleeB/nPdZHR6LIxxmJPBHAamM4QnKjMWsac2L2PPbbrIgIBgUKigID03ZPGy8bnb2rYx8NeCtPaknQcbCI/dKwEQaggW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683359; c=relaxed/simple;
	bh=wGPmc/qJ9IcvTIBshV1oZ7aaPc+oje1lXrIUtBK5Av8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da3oh/3M1iVY7+03qqXlQ099vxArZMtdoD+OsUxPO9Ctg0Y3Zkp3rpTChQ7DNdlWQnE1jfgpzVT/YuNQuY/j3ZurHAe/3iov9wf6BhoEIYxMwygtu5dOJp717LIMfrkXOS5lfZdtB6SddrxJoMgTPhI57kFAhIUDXSoz5JuMKGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ojd4Uw2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ojd4Uw2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8224C2BD10;
	Thu,  6 Jun 2024 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683359;
	bh=wGPmc/qJ9IcvTIBshV1oZ7aaPc+oje1lXrIUtBK5Av8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ojd4Uw2hb3sB1lw9Ntc1yxurvFSlJZobgWFDvWcDCz4UH4JEn+sd1kcbk7QxTWffE
	 z6UWFKyubWayplhBW5nLncXkVlnCCq+rlQowwyz+sUUSUIie2KqFhhHRw2INC2S5L7
	 NtDaDPqdYQU5Fol1kUm1+ixd2PJseHqHF4BgS/GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david.heidelberg@collabora.com>,
	Vignesh Raman <vignesh.raman@collabora.com>,
	Helen Koike <helen.koike@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/744] drm/ci: update device type for volteer devices
Date: Thu,  6 Jun 2024 15:59:02 +0200
Message-ID: <20240606131741.035754048@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 7b5c5fe121d9d..6f81dc10865b5 100644
--- a/drivers/gpu/drm/ci/test.yml
+++ b/drivers/gpu/drm/ci/test.yml
@@ -235,11 +235,11 @@ i915:cml:
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



