Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E476F079;
	Mon, 29 Jan 2024 17:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548463; cv=none; b=fnuQTL0IgcqCOJ1QweT/0/FaHM549tddBYJ5CjWhZX1lGkpuLxsGQqR/1d0FPwJfjQqLzEodjOzn1MHYnZ3jPGGAzK1POj73B0dlC26pQ1FAue8gfOyGChiA0/dOVlxibM8sHHswcWaaEUymgUvZBoMJMO26ejzdlmCRggJK/5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548463; c=relaxed/simple;
	bh=cd54H4Y343OIHaFoR5bLUdbk6y4bjyRL1dpNYLAP2gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8+thk5bB9KR5FLHACwlBFaIYBGmajh7nCZDDDtV0knHmgbvc25lnG1SLVnSHvQ0PiIzEEgiKM33nmiRv9168VUFqRhhn+zUbimzH5BZu4Ia2q9NxSgRZ28RgHnUkly5Ml8DwKwMCiTa40ji6UaZ3FjUjXWaq9n8y0++5pqoecg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qRo/Ka2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qRo/Ka2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C3DC433F1;
	Mon, 29 Jan 2024 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548463;
	bh=cd54H4Y343OIHaFoR5bLUdbk6y4bjyRL1dpNYLAP2gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qRo/Ka2nhH7fdE0g1zRBYy+JeTxLrFzbtjroTsdkPfEMW5GzvsK/aMmfM6oftQe4
	 3QJoCdu76qGsIFlN7gLJvzVblkDszZxYybZ03J/dXgRXsbe/TQ5D+emrogvQ8dxgMo
	 kQA3lufAxQZ8uvAE4zT/vB3zwDBxT7V7aGCHBOr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cixi Geng <cixi.geng1@unisoc.com>,
	Chunyan Zhang <chunyan.zhang@unisoc.com>
Subject: [PATCH 6.6 077/331] arm64: dts: sprd: fix the cpu node for UMS512
Date: Mon, 29 Jan 2024 09:02:21 -0800
Message-ID: <20240129170017.179913244@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Cixi Geng <cixi.geng1@unisoc.com>

commit 2da4f4a7b003441b80f0f12d8a216590f652a40f upstream.

The UMS512 Socs have 8 cores contains 6 a55 and 2 a75.
modify the cpu nodes to correct information.

Fixes: 2b4881839a39 ("arm64: dts: sprd: Add support for Unisoc's UMS512")
Cc: stable@vger.kernel.org
Signed-off-by: Cixi Geng <cixi.geng1@unisoc.com>
Link: https://lore.kernel.org/r/20230711162346.5978-1-cixi.geng@linux.dev
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/sprd/ums512.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/sprd/ums512.dtsi b/arch/arm64/boot/dts/sprd/ums512.dtsi
index 024be594c47d..97ac550af2f1 100644
--- a/arch/arm64/boot/dts/sprd/ums512.dtsi
+++ b/arch/arm64/boot/dts/sprd/ums512.dtsi
@@ -96,7 +96,7 @@ CPU5: cpu@500 {
 
 		CPU6: cpu@600 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a55";
+			compatible = "arm,cortex-a75";
 			reg = <0x0 0x600>;
 			enable-method = "psci";
 			cpu-idle-states = <&CORE_PD>;
@@ -104,7 +104,7 @@ CPU6: cpu@600 {
 
 		CPU7: cpu@700 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a55";
+			compatible = "arm,cortex-a75";
 			reg = <0x0 0x700>;
 			enable-method = "psci";
 			cpu-idle-states = <&CORE_PD>;
-- 
2.43.0



