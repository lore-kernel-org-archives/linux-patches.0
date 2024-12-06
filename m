Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D21494D9;
	Fri,  6 Dec 2024 14:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496091; cv=none; b=aaqvttw4jxMKUEbAziCpBCFL58aKI9GIoapY7LT3Rw8rTBd3TkuTiL0MWdTLYhbfXW0sM47ou9LeMZsFVqPJ5AJPubwlyTtEgzlH1yfB3ohJKMUQ+Z6fyQ1lb0FybAhiTDSItQ5LZnYKTzU4cgCTYA9ZNUyFybJw9tsor1iBks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496091; c=relaxed/simple;
	bh=qD4L7caryWHMqc9s3SzC9ANYV3PsMDgFje8E1OtNJbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGPJpDvK9BEIYm67NYgEJQsGlaqRSSjdGJ2IV9BgKmbiEWQpYbwsVu6B9Tq7G/d7I5V/mPoxCQru8sUuOKETIUhHHp0dJLROIInHxaGlGAuugcgdKLETlHe2k0pb+UJrQZm7r0X+MYnAqAhUGJnPAB7ffyLGyxSO4EO4G3VATXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfWto0cO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfWto0cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D00C4CED1;
	Fri,  6 Dec 2024 14:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496091;
	bh=qD4L7caryWHMqc9s3SzC9ANYV3PsMDgFje8E1OtNJbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfWto0cOfaHQzx/+FnJxwrD2D3t2y1yhI821JP2uWyRgkEa1q2b7sLon8sllNRR0n
	 jF+C38rn5bAUvuAuTeKc11eRp4xtrXVZnIcz5BXIGutObikk3ppn0D03PYnO7Ue53j
	 lxrN8oaX54dL/Xc1Psm6DUe6f3y2SJgGGMXRMyAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.12 017/146] arm64: dts: ti: k3-am62-verdin: Fix SD regulator startup delay
Date: Fri,  6 Dec 2024 15:35:48 +0100
Message-ID: <20241206143528.331553703@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 2213ca51998fef61d3df4ca156054cdcc37c42b8 upstream.

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20241024130628.49650-1-francesco@dolcini.it
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -160,7 +160,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reg_sdhc1_vqmmc: regulator-sdhci1-vqmmc {


