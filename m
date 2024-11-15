Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B282BB1B;
	Fri, 15 Nov 2024 06:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653761; cv=none; b=S+YhXIaB1BgYIO6lXFaiezi6XQbTPWV70mCADQ44OrlIl0hmpDANk66LFez6cAnVTKZkjfYTTW7d0Jfh/5+SOeqFoGWC0n1Tt3qH6/Pz+yWA93jC270YQBrGoWXcwU5xex7AMFnp1Cb4PxdCmrlA5oSEEwdpI+QPlLqtEfi4VkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653761; c=relaxed/simple;
	bh=lQGT3uyp1fRUbtnpDUmbw1ZkmOFCMnGjVaOOjeClDdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMzSD1Mth72QWRxw/DV10p0gmIQpxNlwC9d/z3VWE+5IVAVF+DHY9wC8Vu0G8WRmkWVQwAeaJoJviyiMEZ4B6t5SoR8BCObZR/p2VwOTq2uTu5ywhnuPvDDGiCJqzQBYMSaUhzz837QE7xqUjTtaPE6dUK5Yvv6sJ4/4mdMY17U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIH3IzUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIH3IzUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8813C4CED0;
	Fri, 15 Nov 2024 06:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653761;
	bh=lQGT3uyp1fRUbtnpDUmbw1ZkmOFCMnGjVaOOjeClDdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIH3IzUBH78JqlKazTTXspEd3pfy2950ms/LmhXCzn+qX0bZr9l05y2f0QLwlDCuW
	 9xOKqR7FKFVw4pjoQl2c4eLoIlcnDYxyWtkv1jMQqziDA282GvCMGLcZwNq32W0A3J
	 XzKo1sDPlapTsA+WjCFynQOebXTwuoSgOuXNsaJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/82] ARM: dts: rockchip: fix rk3036 acodec node
Date: Fri, 15 Nov 2024 07:37:44 +0100
Message-ID: <20241115063725.831263756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit c7206853cd7d31c52575fb1dc7616b4398f3bc8f ]

The acodec node is not conformant to the binding.

Set the correct nodename, use the correct compatible, add the needed
#sound-dai-cells and sort the rockchip,grf below clocks properties
as expected.

Fixes: faea098e1808 ("ARM: dts: rockchip: add core rk3036 dtsi")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-12-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036.dtsi | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index 5f47b638f5327..4dabcb9cd4b8c 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -316,12 +316,13 @@
 		};
 	};
 
-	acodec: acodec-ana@20030000 {
-		compatible = "rk3036-codec";
+	acodec: audio-codec@20030000 {
+		compatible = "rockchip,rk3036-codec";
 		reg = <0x20030000 0x4000>;
-		rockchip,grf = <&grf>;
 		clock-names = "acodec_pclk";
 		clocks = <&cru PCLK_ACODEC>;
+		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
-- 
2.43.0



