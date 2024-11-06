Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB35198E96;
	Wed,  6 Nov 2024 12:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896460; cv=none; b=VaVQ5LIQ/01kPACYQxe11i/qyrOWvAAmRniC4BSnRpXUmDW3/kEL6nYmALQs74dglk0Vqilz1hxyTFc8olzRZjuH1mMLYJZLxLV0sbXq22fqAGth6d60PwLn44ls81ZqJNlKtOulEXECbb0SAcFeRosZwtAZZ6VuWxCSy7PgKWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896460; c=relaxed/simple;
	bh=vyR6NpioDDJmHtkVsY0HNy+mtrz0WauPFUo4f2FSPUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVEs46svTLiMBQb/8bPvMi0+4bPviFASuWcK4LpeNh+CBUVdirb71efiioFo3Oi6wUiwtPJH3hUvrFeZXgDbRKdf5O7Sryiu/oV57W3oLmB1aNFSlaeRJVgDvRIMnghF+x6RfdbOl14p6LHAW/lYEG/EMVA9GbqbogrsTiMX+mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCLStmQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCLStmQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63294C4CECD;
	Wed,  6 Nov 2024 12:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896459;
	bh=vyR6NpioDDJmHtkVsY0HNy+mtrz0WauPFUo4f2FSPUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCLStmQ8oseMIAUPrafeEZn8vzyxgCo8UFmwGdEnSSs1oWnGpp2JRVj+4m8EZErTF
	 co3Fcqo8NDdGLvY0i6I1/9WWvuzvT6c29VeArQJ8gfUJEkLBboGKRTWHnMMgurw+XO
	 GCWKA1YMDkAbSG4AqYxr13yjWvnYlDENjb48ftIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.11 210/245] riscv: dts: starfive: disable unused csi/camss nodes
Date: Wed,  6 Nov 2024 13:04:23 +0100
Message-ID: <20241106120324.423289022@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 2e11e78667db90a9e732fbe42820e734d0658fc7 upstream.

Aurelien reported probe failures due to the csi node being enabled
without having a camera attached to it. A camera was in the initial
submissions, but was removed from the dts, as it had not actually been
present on the board, but was from an addon board used by the
developer of the relevant drivers. The non-camera pipeline nodes were
not disabled when this happened and the probe failures are problematic
for Debian. Disable them.

CC: stable@vger.kernel.org
Fixes: 28ecaaa5af192 ("riscv: dts: starfive: jh7110: Add camera subsystem nodes")
Closes: https://lore.kernel.org/all/Zw1-vcN4CoVkfLjU@aurel32.net/
Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/starfive/jh7110-common.dtsi |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
@@ -128,7 +128,6 @@
 	assigned-clocks = <&ispcrg JH7110_ISPCLK_DOM4_APB_FUNC>,
 			  <&ispcrg JH7110_ISPCLK_MIPI_RX0_PXL>;
 	assigned-clock-rates = <49500000>, <198000000>;
-	status = "okay";
 
 	ports {
 		#address-cells = <1>;
@@ -151,7 +150,6 @@
 &csi2rx {
 	assigned-clocks = <&ispcrg JH7110_ISPCLK_VIN_SYS>;
 	assigned-clock-rates = <297000000>;
-	status = "okay";
 
 	ports {
 		#address-cells = <1>;


