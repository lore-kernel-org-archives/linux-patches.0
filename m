Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761664369A;
	Wed, 25 Feb 2026 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982964; cv=none; b=Fm/LVb114nfgVF1f5RXbDWoBrzit5t3zy/1T/OskmgemmtcYoPx4W0LktVjup56FbSiKqVBc9ZkAWJxMGuyQRZKRcLIaT6KR4FbdZocPemJ2XVsncS+MZ4kV0wLl5SSPopqA7AsGyMPAnXWFk11ZYqYlmDBwGQ/89eoG6qUj1n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982964; c=relaxed/simple;
	bh=0msj+l0Aa5uWeVmaLIe566gqbQ8Huoepw7ElwDpyGfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk6jNi5LXZjugFfdb/iXc88wGk2ltiLIYsONfaUa/R0x1v734n1/pJasAPYIC+zfXs+4k4hZ8yNxLvSggETmj7K8hL6T4xXfLNMOhtByBIPy4m8+A0ADzvapHt3UEnJCzLxvidc+NjDkkgrXrarGsSD9dQMCWyJXP8egyRmXfrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1CvB9No; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1CvB9No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C10C19423;
	Wed, 25 Feb 2026 01:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982964;
	bh=0msj+l0Aa5uWeVmaLIe566gqbQ8Huoepw7ElwDpyGfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1CvB9No7IqvB869oEyLcbRBhNnQdNYNss3AEjZscbiA2Td8vAvBIm5fr2zmxK196
	 wcbip+9GdgGF939c27ZQhbhoTc341vJMtSbK5+GWXEriukxHkA3FTeTfFtwQZER301
	 CKiTKFtk/aveQPg9tpDyXRl6LRoZo3I4yc9aYyZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 140/781] arm64: dts: ti: k3-am69-aquila-clover: Fix USB-C Sink PDO
Date: Tue, 24 Feb 2026 17:14:09 -0800
Message-ID: <20260225012403.102199766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit b548f3949937b55ee19ab418343f05700fdf7009 ]

Change USB-C Sink PDO and the amount of power that the device can sink
to zero to maximize compatibility with other USB peers (the Aquila
Clover Board is not sinking any current, it is self powered).

Fixes: 9f748a6177e1 ("arm64: dts: ti: am69-aquila: Add Clover")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20251204134220.129304-3-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am69-aquila-clover.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am69-aquila-clover.dts b/arch/arm64/boot/dts/ti/k3-am69-aquila-clover.dts
index 55fd214a82e44..c816ba3bfbdf7 100644
--- a/arch/arm64/boot/dts/ti/k3-am69-aquila-clover.dts
+++ b/arch/arm64/boot/dts/ti/k3-am69-aquila-clover.dts
@@ -280,8 +280,8 @@ connector {
 			try-power-role = "sink";
 			self-powered;
 			source-pdos = <PDO_FIXED(5000, 3000, PDO_FIXED_USB_COMM)>;
-			sink-pdos = <PDO_FIXED(5000, 3000, PDO_FIXED_USB_COMM)>;
-			op-sink-microwatt = <1000000>;
+			sink-pdos = <PDO_FIXED(5000, 0, PDO_FIXED_USB_COMM)>;
+			op-sink-microwatt = <0>;
 
 			ports {
 				#address-cells = <1>;
-- 
2.51.0



