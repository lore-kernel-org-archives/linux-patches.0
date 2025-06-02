Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84622C324F;
	Mon,  2 Jun 2025 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877604; cv=none; b=fHIMcRqYqihGYBMxHDzh4EGGKIVknJGRW2tnBHrfwkmGlRNxFPD7vBkz9jO1X/XYvF72ZG1unzBMGawZLwMS/WNU4iJIDSpJEizFRp4fqD4lMROrOYVP9t8jmaO7OTRGvb1IiWSiJnlA3a9XXhebKP3f48lj5amBk0d1c1pahuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877604; c=relaxed/simple;
	bh=9KQjDIX5qNOhHFy+vyv1gTgyqrydlFOf56ZgcfFW6oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY2wDnBOeZV7NL/330v7AUozgIIKmZbRRXhJGTAgD+JnlbBOhev3JbRMft9AnEWHUF06QMv3OBD0FO6GPEb110r4obbEP+JprALIXX6O9Mxp5jHrEO9rf79DjaDpisQj2shmtCDB/mTwv3V2+mRl5BSlHFK7u5OshSjFR0jsv6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4KdsSzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4KdsSzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167A3C4CEEE;
	Mon,  2 Jun 2025 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877604;
	bh=9KQjDIX5qNOhHFy+vyv1gTgyqrydlFOf56ZgcfFW6oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4KdsSzu0Ix6G2brUh49PEntJ0TiPCU9rAEN7C4aWgGK/GX53f3CVw39OfHf9pYFi
	 8bVsxX5/qR7rtU/695uKXgDbMRmh1Ra0Kp4aJs2mpJI9SVtp7MKsvk1qjfM5zvZErs
	 7GFyA+T1d7t81Pm7BqevDNAjjFruyYpIkDopUNXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 308/325] arm64: dts: qcom: sm8350: Fix typo in pil_camera_mem node
Date: Mon,  2 Jun 2025 15:49:44 +0200
Message-ID: <20250602134332.437240609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 295217420a44403a33c30f99d8337fe7b07eb02b upstream.

There is a typo in sm8350.dts where the node label
mmeory@85200000 should be memory@85200000.
This patch corrects the typo for clarity and consistency.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://lore.kernel.org/r/20250514114656.2307828-1-alok.a.tiwari@oracle.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -421,7 +421,7 @@
 			no-map;
 		};
 
-		pil_camera_mem: mmeory@85200000 {
+		pil_camera_mem: memory@85200000 {
 			reg = <0x0 0x85200000 0x0 0x500000>;
 			no-map;
 		};


