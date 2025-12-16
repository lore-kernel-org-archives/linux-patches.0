Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0253242B4;
	Tue, 16 Dec 2025 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888091; cv=none; b=l46kdPUj8PJLYFjFdNMNX9xALmeIQUoTiDOeyUpj1axYZZOOHuWHUoYDkIyLyqDuoKR25+kYvzieTMzKU7YZg9TwK29fkkemZDSlpjr1QsAwN0XsaS7eRTADFr9Q51hmR/v8V/vLpfadnqdbqCvt4nPkc+CK/ry2NWxqdH1hXso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888091; c=relaxed/simple;
	bh=yYuc6CzmWMIXj2BTccJRA1dLdGGMljKG1ycna85TZ80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKRHI2lLPK6iGg7gj4zKMHWKWPD0FNacSiwMbmBJQeD47eFV3ZK9oqRa3MdUzSbjSJGGSfzwCOSgQ6UKwSW47Gh23fg0EEVY1gOe0tZsEnuNrdKyb1Yrwqe2dd/BcGJeU/IMpcmi79slmXAhcf6SXmwGcveYbRvTvs/p0djCZa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTUSMu8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTUSMu8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1715C4CEF1;
	Tue, 16 Dec 2025 12:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888091;
	bh=yYuc6CzmWMIXj2BTccJRA1dLdGGMljKG1ycna85TZ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTUSMu8K4FEvgRPj6yzMThhkWKnbiM/gH8d0PM3j/9IDrtQ0/M6sY9vsTA0FsP9Nb
	 uK0iMH3H2Jbz0ipMdLppA4nNUzWAL+ErXU6Ekx/1tz7amY4Ce3WjX0brwHo//90ue+
	 J+VewCLbqxwO6Lng4/vos0prkv493MAadAfdmqmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume La Roque <glaroque@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 430/614] arm64: dts: amlogic: meson-g12b: Fix L2 cache reference for S922X CPUs
Date: Tue, 16 Dec 2025 12:13:17 +0100
Message-ID: <20251216111416.954466664@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Guillaume La Roque <glaroque@baylibre.com>

[ Upstream commit a7ab6f946683e065fa22db1cc2f2748d4584178a ]

The original addition of cache information for the Amlogic S922X SoC
used the wrong next-level cache node for CPU cores 100 and 101,
incorrectly referencing `l2_cache_l`. These cores actually belong to
the big cluster and should reference `l2_cache_b`. Update the device
tree accordingly.

Fixes: e7f85e6c155a ("arm64: dts: amlogic: Add cache information to the Amlogic S922X SoC")
Signed-off-by: Guillaume La Roque <glaroque@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20251123-fixkhadas-v1-1-045348f0a4c2@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b.dtsi
index f04efa8282561..23358d94844c9 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b.dtsi
@@ -87,7 +87,7 @@ cpu100: cpu@100 {
 			i-cache-line-size = <32>;
 			i-cache-size = <0x8000>;
 			i-cache-sets = <32>;
-			next-level-cache = <&l2_cache_l>;
+			next-level-cache = <&l2_cache_b>;
 			#cooling-cells = <2>;
 		};
 
@@ -103,7 +103,7 @@ cpu101: cpu@101 {
 			i-cache-line-size = <32>;
 			i-cache-size = <0x8000>;
 			i-cache-sets = <32>;
-			next-level-cache = <&l2_cache_l>;
+			next-level-cache = <&l2_cache_b>;
 			#cooling-cells = <2>;
 		};
 
-- 
2.51.0



