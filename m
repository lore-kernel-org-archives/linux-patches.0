Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC42330ACE8;
	Sat, 25 Oct 2025 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409003; cv=none; b=KnIpegO5Vmb5inDA5RruM8yIMm+sIM4vw/ZdB9Xs08d+eIp0B/TAI7a60j3tzdVSCBEr8fN7ZwK4iy+qBqX7KhOqs+CzUCgx8vo504S893ktBC84GGWv6C9YZrzW2/2yHLIcbs8/GdomdP9kiMXz7O6on19Bke1LGSiOlNqHNek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409003; c=relaxed/simple;
	bh=Gesk0ASuyTAfunuOvLuCRzKYyT5uQPadnmuiy0zAXeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spm2fXrt2c1wxB0INjLU0Egazswi1QHR6fG4ASIdstVadzSoWilRFJ3AMuLt4hrNTEh+YFLLaU1cSaP8FGnZ7rlBKJtFUt5PwNfVSWkByrrdeDhWv6bOrNJvbw3C/YlCitO/A0Y5SGLwzfxPQz6dzxjSpJlb9STPd5YySxenb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cYlCPxD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cYlCPxD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A99C4CEFB;
	Sat, 25 Oct 2025 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409003;
	bh=Gesk0ASuyTAfunuOvLuCRzKYyT5uQPadnmuiy0zAXeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYlCPxD3+PmidwiYDUKiPKKtm/sOmZMC+56DQBahavtoaeDsLbsUuItZuISSmdG0L
	 yTKVdq90S5NJoA1L9xi4T52CXYSkBuH5SgqQYPb7vHa2lUzyXR/g0ITs0VY+E9Z3qu
	 YQB06cxsfU04/1TYXmVcLWaDUaS5FkFuYkNws8J1Q8bl17VQTe9CzGjOFs9hzmw51i
	 gQYenZ6jDVlCyFsdsBR+FWbPEF2Sk35F3XEnaRNX6XENUu++XLSREP2gqy+R1p9W/r
	 D/uk4dR4igWQt4bZGO+ChPw4QJERvY5h0r/aQHRItpDybbsAF4mzdnPfHR3SLEJVYe
	 AW79vb0OO8fdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] mips: lantiq: danube: add missing properties to cpu node
Date: Sat, 25 Oct 2025 11:56:42 -0400
Message-ID: <20251025160905.3857885-171-sashal@kernel.org>
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

[ Upstream commit e8dee66c37085dc9858eb8608bc783c2900e50e7 ]

This fixes the following warnings:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#address-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#size-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpu@0 (mips,mips24Kc): 'reg' is a required property
	from schema $id: http://devicetree.org/schemas/mips/cpus.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Adds required properties to the CPU description so the DT validates
    cleanly against schemas, eliminating build-time errors/warnings:
    - Adds `#address-cells = <1>` and `#size-cells = <0>` to the `cpus`
      node (arch/mips/boot/dts/lantiq/danube.dtsi:8–9), matching
      `cpus.yaml` requirements.
    - Adds `reg = <0>` to `cpu@0`
      (arch/mips/boot/dts/lantiq/danube.dtsi:13), matching
      `mips/cpus.yaml` requirements.
  - Directly addresses the warnings listed in the commit message,
    improving DT correctness and preventing build/CI failures in
    environments treating schema violations as errors.

- Scope and risk
  - Device Tree only; no driver or core code changes. The change is
    minimal and contained to a single DTSI file:
    `arch/mips/boot/dts/lantiq/danube.dtsi`.
  - The new properties are long-established, standard DT fields for CPU
    nodes. `reg = <0>` is the canonical single-CPU index and does not
    alter runtime semantics for this platform.
  - No architectural changes and no functional behavior changes are
    introduced; this is metadata correctness for DT schema compliance.

- Impact and side effects
  - Positive: removes DT validation warnings, improves tooling and
    cross-tree consistency, and avoids potential build failures in
    strict pipelines.
  - Neutral at runtime: kernel CPU enumeration for a single-core MIPS
    system remains unchanged; these properties are consumed by standard
    DT parsing code and other MIPS DTS files already follow this
    pattern.

- Stable backport criteria
  - Fixes a real (schema) bug affecting users/projects relying on DT
    validation, with a clear and minimal change.
  - No new features; no API changes; extremely low regression risk;
    confined to the MIPS Lantiq Danube DT.

 arch/mips/boot/dts/lantiq/danube.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
index 7a7ba66aa5349..0a942bc091436 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -5,8 +5,12 @@ / {
 	compatible = "lantiq,xway", "lantiq,danube";
 
 	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
 		cpu@0 {
 			compatible = "mips,mips24Kc";
+			reg = <0>;
 		};
 	};
 
-- 
2.51.0

