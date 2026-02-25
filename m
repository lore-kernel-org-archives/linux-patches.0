Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC4D2BEC23;
	Wed, 25 Feb 2026 01:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983873; cv=none; b=s0fr6UcV4aeoXbGGVjgQM9zS6sqTpDmwmHZPbwPjJo8lt9j2h80Nk86PmeK/EDLGCRBs58ixIa+Tt8CA8klKI0+LLpf8fVRbzcRLPAq0yIMpgImSokk86iE495hh5CrvU3OUcIoCt4R0OH+LyItYGsSWgmr74Dbc9OBjoEH51c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983873; c=relaxed/simple;
	bh=pQfJaW5FySZ6mEuxnYgNccZN0ocpXo77pvixAAOJyug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIx7H5/AaszB+RCkTgJKYAVxPtyv8pMfq3zXZ37hMFCqUDceU/yb0xq6LWkfRH7vyCh7tPkueVsLipt/wOEQiIllydFS7l2D2GLmvOLNarlJMvJI4pGzb/Pl2ewCRJqje0agUv0xlGM4cea+XVtkahj6K8UBAHT6n648Peuvfhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3gpuFZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3gpuFZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD98FC116D0;
	Wed, 25 Feb 2026 01:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983873;
	bh=pQfJaW5FySZ6mEuxnYgNccZN0ocpXo77pvixAAOJyug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3gpuFZXr+YtHMxMY69YQQmoPQFy6wq05aZx3tRYAYxZPAhyliuA48HQ1sgq7UeGy
	 8aD/2rDapULisA/PY69Yaas6xbUUzu1zFqqL4LR3ENWJauqVosa/KrF1wg6P/FWTKr
	 FJYpUU0MakofSykpVvCFWtg2/ppetcJjzMTQPVsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Xie <nick@khadas.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/641] arm64: dts: amlogic: s4: assign mmc b clock to 24MHz
Date: Tue, 24 Feb 2026 17:17:55 -0800
Message-ID: <20260225012352.709307751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 86124a8becb43eed3103f2459399daee8af2c99d ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

This assumption did hold true until but it now, but it is apparently
not the case with s4. The clock has been reported to provide 1GHz
instead. This is most likely due to how the bootloader is using the MMC
clock on this platform.

Regardless of why the MMC clock rate is 1GHz, if the MMC driver expects
24MHz, the clock should be properly assigned, so assign it.

Reported-by: Nick Xie <nick@khadas.com>
Closes: https://lore.kernel.org/linux-amlogic/20260113011931.40424-1-nick@khadas.com/
Fixes: 3ab9d54b5d84 ("arm64: dts: amlogic: enable some device nodes for S4")
Tested-by: Nick Xie <nick@khadas.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-s4-mmc-fixup-v3-1-a4d3e136b3f2@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 9d99ed2994dfa..f314f07062abe 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -838,6 +838,9 @@ sd: mmc@fe08a000 {
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
 			status = "disabled";
+
+			assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_B>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		emmc: mmc@fe08c000 {
-- 
2.51.0



