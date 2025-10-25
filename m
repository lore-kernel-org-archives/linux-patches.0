Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76EC3074B3;
	Sat, 25 Oct 2025 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409433; cv=none; b=bTI1Tgyek7ayGvukW95bXqFvLGPt+vmBvz2ivriZEzr9crs6tNXcXJQtL47UL6YAsjsSujNX3ilz/QYMIjkCq3OPnlY0DqoDvk8YfZcWWetWfeBuhaFOGPK3M/+M3UOBtC5nm5zK0zuXBMiZCEEXU2dCD7kG3gbwqPDM56uSDUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409433; c=relaxed/simple;
	bh=aov/dq1d83sTeOaZQW4Wp0joM9vHeST6WISmlYsu5g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HAh0m7wN4M2u5minnn0Iu518e81MqrEX3zvotA29xI1u322W5E98EWf//MbBZA4ZEEPU48/4rqJMhIYwOlLWqGxMawkk39MNk18kVAMgQslkJdmA5H8isnd7/BIX6E/cvHnvEMNuv4vIoieqfkfrgZgbt0iTRN6H+vpXHl3hiBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nijk1Ybc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nijk1Ybc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBC2C4CEFB;
	Sat, 25 Oct 2025 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409433;
	bh=aov/dq1d83sTeOaZQW4Wp0joM9vHeST6WISmlYsu5g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nijk1YbcNeQFuirg/PhVEjqfH19wHPXKVaoPmBipoE1NKtVGbzMFmnVfAu20ip7ln
	 s3eDlneYUJY5NkP8kY1v3Mpw4+87Mw6BbUzLyxb9tNolP6XeVmKKU3z7U7Ci7tt1/z
	 L0XFFIuc+v82cJe4trc77SEb5HiGncgzFikwkVRItCAVN4Kcw7utX2jdZaBMoRf433
	 qIp+jD2W/hhlXoK8MIwRX8LDrv3cD7dK+E7CKqlvF6qq2jm8GBIExNouGtJBAcbwnM
	 /BqkudxiI1ug5LtmKf8OekKRJeCMQ/8BGZVIFQ7sSY7A38oHn2eENtOxZTXa3mDdP7
	 bJCux7yr6VLeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	christian.koenig@amd.com,
	Hawking.Zhang@amd.com,
	mario.limonciello@amd.com,
	alexandre.f.demers@gmail.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] drm/amdgpu: add support for cyan skillfish gpu_info
Date: Sat, 25 Oct 2025 11:59:15 -0400
Message-ID: <20251025160905.3857885-324-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit fa819e3a7c1ee994ce014cc5a991c7fd91bc00f1 ]

Some SOCs which are part of the cyan skillfish family
rely on an explicit firmware for IP discovery.  Add support
for the gpu_info firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it does
  - Adds a firmware alias for cyan-skillfish GPU info so user space can
    bundle the blob:
    `MODULE_FIRMWARE("amdgpu/cyan_skillfish_gpu_info.bin");`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:98).
  - Extends `amdgpu_device_parse_gpu_info_fw()` to recognize the cyan-
    skillfish ASIC and request its gpu_info firmware by name: `case
    CHIP_CYAN_SKILLFISH: chip_name = "cyan_skillfish"; break;`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2633).
  - Uses the existing firmware loading path with `AMDGPU_UCODE_OPTIONAL`
    via `amdgpu_ucode_request(adev, &adev->firmware.gpu_info_fw,
    AMDGPU_UCODE_OPTIONAL, "amdgpu/%s_gpu_info.bin", chip_name);`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2638), then parses the
    header and fills config when present
    (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2648-2713).

- Why it matters (bug it fixes)
  - Commit message states some cyan-skillfish SoCs rely on an explicit
    firmware for IP discovery. Prior to this change,
    `amdgpu_device_parse_gpu_info_fw()` did not handle
    `CHIP_CYAN_SKILLFISH`, so the driver skipped loading the gpu_info
    firmware for these ASICs (default case returned 0). That can leave
    required configuration (e.g., GC/DAL parameters and SoC bounding box
    when provided) unavailable, causing functional issues or incomplete
    bring-up on affected SoCs. This change enables the driver to obtain
    and use the cyan-skillfish gpu_info firmware, aligning it with how
    other ASICs are already handled.

- Scope and risk assessment
  - Small and contained: only touches `amdgpu_device.c` with two
    straightforward additions (firmware alias and a switch case branch).
  - No architectural changes: it reuses the existing, well-exercised
    gpu_info firmware parsing path used by Vega/Raven/Arcturus/Navi12
    (see the nearby cases for those chips in the same switch in
    drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2606-2632).
  - Limited impact: code runs only for `CHIP_CYAN_SKILLFISH`. Other
    ASICs are untouched.
  - Consistent error handling: if the firmware isn’t found,
    `amdgpu_ucode_request()` returns `-ENODEV`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:1489-1505), which
    propagates out of `amdgpu_device_parse_gpu_info_fw()`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:2713). The alias
    addition (drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:98) ensures the
    firmware name is properly declared so distributions can include it,
    mirroring all the other gpu_info blobs already declared for prior
    ASICs. This matches the existing pattern and minimizes regression
    risk.
  - No user-visible feature addition: it corrects missing support for a
    known hardware family, enabling required firmware consumption rather
    than introducing new functionality.

- Stable backport criteria
  - Fixes an important functional gap for users with cyan-skillfish SoCs
    by enabling necessary firmware-based discovery/config data.
  - Minimal, isolated change with low regression risk for non-affected
    platforms.
  - No ABI or architectural changes; follows established amdgpu
    firmware-loading patterns.
  - Touches the DRM amdgpu subsystem only and mirrors how other ASICs
    are supported.

Given the small, targeted nature of the change and its purpose of
enabling existing hardware to function correctly by loading a required
gpu_info firmware, this is a good candidate for stable backporting.

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 097ceee79ece6..274bb4d857d36 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -95,6 +95,7 @@ MODULE_FIRMWARE("amdgpu/picasso_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/raven2_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/arcturus_gpu_info.bin");
 MODULE_FIRMWARE("amdgpu/navi12_gpu_info.bin");
+MODULE_FIRMWARE("amdgpu/cyan_skillfish_gpu_info.bin");
 
 #define AMDGPU_RESUME_MS		2000
 #define AMDGPU_MAX_RETRY_LIMIT		2
@@ -2595,6 +2596,9 @@ static int amdgpu_device_parse_gpu_info_fw(struct amdgpu_device *adev)
 			return 0;
 		chip_name = "navi12";
 		break;
+	case CHIP_CYAN_SKILLFISH:
+		chip_name = "cyan_skillfish";
+		break;
 	}
 
 	err = amdgpu_ucode_request(adev, &adev->firmware.gpu_info_fw,
-- 
2.51.0

