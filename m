Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81643FD955;
	Fri, 15 May 2026 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862479; cv=none; b=Y+FhQLEXxLHrsnxB7lwTkLfFrWzv06CxKzw6JFwEChhOl4UFdHQivyCswgtyJywAvQkW4FmdFFH8pNX7jzpvMbn5ZUINiyzhNmWqZyFvRg1uTsw5XPoWCNtx2OlEqKdJn7u5Cbee6XZM5bzOHGgUh6EyAtXPwoGIOUlQeujQB10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862479; c=relaxed/simple;
	bh=BbyqNTbWh971uYCwjJTrKPO3/5OmfOz0va4UHEgaxB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qdalyg9S89OnyHWRLghe6erpuQO01kYN5rISvYh+8aiuv3SBFUxVPgtWwBLgZqa8alw0OjYuzXGEvSoI8X8fOqpoDUYnk6REPl5vIW5b3icWXrETi8jEdiNxa3UqtQU0sJyMNpmyYRhs9o2wwAqE6SIwHJ8cdaQGQ390gE9ZePo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muzYMBQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muzYMBQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CFAC2BCB0;
	Fri, 15 May 2026 16:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862479;
	bh=BbyqNTbWh971uYCwjJTrKPO3/5OmfOz0va4UHEgaxB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muzYMBQabweM09PntjfSm6yTofA3cD9HFDoyeqKGlMCor8dtp9n0rBosrkfjk7FDs
	 sIEaWJvK5yimIR/Abv0kMXspQmsnhoQS6+wCnEXEqY8CzkHz9JD+mmR/j/LcJ4DdPU
	 V6OR1r4v1GmdORYQ8uVuIf5IkBXkL6Q0H5+tCtLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Rasmus Villemoes <ravi@prevas.dk>
Subject: [PATCH 7.0 064/201] arm64: dts: broadcom: bcm2712-d-rpi-5-b: update uart10 interrupt
Date: Fri, 15 May 2026 17:48:02 +0200
Message-ID: <20260515154659.921066785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregor Herburger <gregor.herburger@linutronix.de>

commit 18d4a06e10051681de074a9250e54afc1f3ee312 upstream.

On the -d revision of bcm2712 the uart interrupt is on 120. Update it
accordingly.

Signed-off-by: Gregor Herburger <gregor.herburger@linutronix.de>
Link: https://lore.kernel.org/r/20260226-raspi-dts-updates-v1-6-60832d20ff04@linutronix.de
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Rasmus Villemoes <ravi@prevas.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts
@@ -45,3 +45,7 @@
 	compatible = "brcm,bcm2712d0-aon-pinctrl";
 	reg = <0x7d510700 0x1c>;
 };
+
+&uart10 {
+	interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
+};


