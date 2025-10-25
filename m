Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9285238142;
	Sat, 25 Oct 2025 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409587; cv=none; b=J3N4DE1BfJNbM6BnPHanAEMqyqq1+fx38UA4gwlX1loCx3xYox+GT81NvcwDQu4o5UhIy3JqZ0LjEK4FYCzANwazcuBX0Xj6cEfJeDikDNwj2sG+jveXs90Zt9fmJdLziqSeuaEcCjXEZ+p3yQ+Cw36GaqzS4d2/MUjgDhQFJDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409587; c=relaxed/simple;
	bh=uwdtI+bSwjtI9Zdi1ZEFOIrR/U4a4aZQ6nOF2j4XYQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hy1jElxP42z25DSTHDNYiqrRj75Jts5B7dHn902umBQvmZe/M0d6xxYEny4SALNM/OmpTSQGdXO3G+9X5jamYoAnwPs+7B28F7SVKDAAkLTMQIg1R38+cGTR1tJR+YcghvWK1ACazMMyDxj5kUVQYLJpg6n60Ln2qkApZGNrsY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m74Tw6ZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m74Tw6ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33E3C4CEF5;
	Sat, 25 Oct 2025 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409587;
	bh=uwdtI+bSwjtI9Zdi1ZEFOIrR/U4a4aZQ6nOF2j4XYQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m74Tw6ZVRXh/0zxQmjdpiPcD7GmWNbAFYuKulLiAZ16lElkXN2z4NVKQmsTz69FKV
	 DLNio+0IQkRpmtjw2Hf6ZkRgVE/Z6xAKDcEP+2fIkbikpW0p71f3IDDR3xnlCDMXLc
	 RfHHnC0fitkbAkJC+wCp4YInBIlScA82ihgrxCfDIFU5CNRDZ190Pi3HGcjKKNxT9+
	 JfnWSjMtw5l6AnB02MP4Kt6Nf8L4SMbo08RQG1ZebFFTm6lmuoyCCKxDZ73WzOgHAd
	 c4Q5fxVeCl6LeStTAgqp/6by1jyoy2z2F+3deHw1BdNuhMlYdoYQMUDlDEYrMgod+R
	 A5J+FfhCAgv9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	kuba@kernel.org,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-6.1] mips: lantiq: danube: add model to EASY50712 dts
Date: Sat, 25 Oct 2025 12:00:09 -0400
Message-ID: <20251025160905.3857885-378-sashal@kernel.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit cb96fd880ef78500b34d10fa76ddd3fa070287d6 ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: / (lantiq,xway): 'model' is a required property
	from schema $id: http://devicetree.org/schemas/root-node.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real build-time validation issue: The change adds a missing
  required property to satisfy DT schema checks. The root-node schema
  requires a 'model' string; without it, `dtbs_check` warns: "'model' is
  a required property". Adding the property resolves this concrete
  warning.
- Minimal, contained change: One line added to a single board DTS. See
  arch/mips/boot/dts/lantiq/danube_easy50712.dts:7 where `model = "Intel
  EASY50712";` is introduced immediately under the root node.
- No functional or binding changes: The property is descriptive and does
  not alter any hardware description, node layout, or compatible
  strings. Drivers do not consume 'model' for behavior, so risk of
  regression is negligible.
- Improves user visibility without side effects: Kernel code and
  userspace commonly read the model string for identification (e.g.,
  “Machine model” logs and sysfs/proc exposure). While many subsystems
  read ‘model’, the Lantiq MIPS platform’s `get_system_type()` does not
  depend on DT ‘model’ (arch/mips/lantiq/prom.c: get_system_type()),
  further reducing any risk of changing existing behavior. Other generic
  paths that read ‘model’ benefit from correctness (examples of readers
  found via semantic search include drivers/soc/* and others).
- Stable-friendly profile:
  - Bugfix: resolves a schema compliance warning and ensures a complete,
    standards-conformant DT.
  - Trivial and localized: a single-line addition in one DTS file.
  - No architectural changes or critical subsystem churn.
  - Very low regression risk; likely improves diagnostics and tooling.

Given it corrects a required DT property with a minimal, safe change
confined to one board DTS, this is a good candidate for stable backport.

 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index c4d7aa5753b04..ab70028dbefcf 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -4,6 +4,8 @@
 /include/ "danube.dtsi"
 
 / {
+	model = "Intel EASY50712";
+
 	chosen {
 		bootargs = "console=ttyLTQ0,115200 init=/etc/preinit";
 	};
-- 
2.51.0

