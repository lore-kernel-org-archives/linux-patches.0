Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC713403F5;
	Sat, 12 Sep 2026 08:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200460; cv=none; b=ZDl8n7iYoWdwg3JWpp6oyo+BZLkLGuBRMYzS18MVTQSPrcrLJz656+R/ZMq+I9Rf5Gk4+0YwkDjSwy/VQqXxMm4B1pQHEI2Az8P0nvaKd+jDvakDDF7RSqAsXFoRjhrl/X0j+pzrIEPKoRAxdzJvoi89blyTNiWKWSpfZwY4x/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200460; c=relaxed/simple;
	bh=8pCKbbRSDg/7uYIq1g0qTfTvqHpu8i+FUwK9B3CfAq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoKkA9lz3ibgmwot4K0SDApe+6xvotBWn1hrxfKluPJnUkGDhedXxlvCrppFy1z9vpTgXcvUYJwuqQWJBGlo+j2rYD2oG9rRuh+uoEMIPlORPHOCfml8p6Fpep1yeCYZfumrns6pLWf4iw8GncvaIqe3fJInfr3L/DyDfNPYwBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUWYNBYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUWYNBYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497A71F000FF;
	Sat, 12 Sep 2026 08:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200458;
	bh=1NIZ0NnqdwRtjaeqCbtQcxYKx7xv85oUZzRW37o+upk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUWYNBYYjgKo25psawNax4l5qj771RygiS4/8PLPAvnRDFLxzrNj5OTZ/roOrvPgj
	 8zxF7o3+p0e0jNLamFvv9KB5JhTS83NhhmCL/BE0teEA9WZuTSdH9YBxXD3HTjORPp
	 hYNo0IJXBLSuuf6VC8szCLDjAGjuOjiZ29YyNHjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0794/1815] arm64: dts: qcom: talos: Fix cpu6 1094.4MHz OPP frequency typo
Date: Sat, 12 Sep 2026 08:42:24 +0200
Message-ID: <20260912065707.548968843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit f2eb18c66b98fbfcbab4daef42c04f4becba7d79 ]

opp-1094400000 in cpu6_opp_table has a typo in opp-hz, missing a trailing
zero. Fix it to resolve the following OPP update failures:

cpu cpu6: Voltage update failed freq=1094400
cpu cpu6: failed to update OPP for freq=1094400

Fixes: 44562f591890 ("arm64: dts: qcom: qcs615: Add OSM l3 interconnect provider node and CPU OPP tables to scale DDR/L3")
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-talos-cpu6-opp-fix-v1-1-f4886fdff13f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/talos.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/talos.dtsi b/arch/arm64/boot/dts/qcom/talos.dtsi
index 70df5db19e9ac..f77069c1e10e2 100644
--- a/arch/arm64/boot/dts/qcom/talos.dtsi
+++ b/arch/arm64/boot/dts/qcom/talos.dtsi
@@ -351,7 +351,7 @@ opp-1017600000 {
 		};
 
 		opp-1094400000 {
-			opp-hz = /bits/ 64 <109440000>;
+			opp-hz = /bits/ 64 <1094400000>;
 			opp-peak-kBps = <(1017600 * 4) (940800 * 16)>;
 		};
 
-- 
2.53.0



