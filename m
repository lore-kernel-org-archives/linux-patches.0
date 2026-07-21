Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5907239A7FD;
	Tue, 21 Jul 2026 18:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658489; cv=none; b=qDmIcJO5PYLrWceo979+n9HIbXSZ8lcKRlnB1q30CeWIci9R+yZ5O5ytv+eOH7WE/si12f2XFgMHbsTTyMYnKYeXPT2wLplZ4Qw4hAkYvDmBFKJ2UqNPQD+DX/S3nKQ4qT3KxUCImRt6veOgRaKBZNYvxS5jJgY65wmi4tqWjN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658489; c=relaxed/simple;
	bh=uyOS70gTiDPFZbUxHca4N8Fg5jiSyGg7UND60Y6v8KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSiFsqIq+b9ThvlqizzLZXrJjnes5zFtQTqd4rr4+vprEiUx0TEI/K8zrSx/vFtRnLecPjzZr0mkZjoXjocLC/2afW+M9+glVKlKjXdDmURNjuZ/1OfJEJFOqtg1okiuv9JhLCLelnaIlLrZvYA3TiOOq/Jl5FUapnSbD8Z8cvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVhcJpbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVhcJpbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880A91F00A3A;
	Tue, 21 Jul 2026 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658487;
	bh=O+8f2iR8FNs4aqOl00HNWXF2+j51wNrQxhz2eENARNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVhcJpbloANnmCq5DGTnezn+Bcbhv+uJITbekfrpa+Np8VpeGsm6djMJLZzzvIPQp
	 GYbdKR8nccbNr2+uocn1yR8NTmuG+6SJHzzW/4IEaOvnJSOE1LeE2++GadzU2OH22B
	 UF+v8iot23XaWCFDc5Stw9XMIhfJTF3CiZgLPxbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jander <david@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH 6.18 1119/1611] ARM: dts: stm32: stm32mp15x-mecio1-io: Fix GPIO names typo
Date: Tue, 21 Jul 2026 17:20:35 +0200
Message-ID: <20260721152540.587966113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Jander <david@protonic.nl>

commit b04ccecb714de913e360f0866c66f38e1606e89b upstream.

The reset pins for the LPOUT lines were incorrectly prefixed with "GPOUT"
instead of "LPOUT" in the gpio-line-names array. Fix these typos so the
pin names consistently match the LPOUT0-4 signals they belong to.

Fixes: 8267753c891c ("ARM: dts: stm32: Add MECIO1 and MECT1S board variants")
Co-developed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20260318105123.819807-5-o.rempel@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15x-mecio1-io.dtsi
@@ -185,14 +185,14 @@
 &gpioe {
 	gpio-line-names = "HPOUT0_RESETN", "HPOUT1", "HPOUT1_ALERTN", "",
 			  "", "", "HPOUT1_RESETN",
-			  "LPOUT0", "LPOUT0_ALERTN", "GPOUT0_RESETN",
-			  "LPOUT1", "LPOUT1_ALERTN", "GPOUT1_RESETN",
-			  "LPOUT2", "LPOUT2_ALERTN", "GPOUT2_RESETN";
+			  "LPOUT0", "LPOUT0_ALERTN", "LPOUT0_RESETN",
+			  "LPOUT1", "LPOUT1_ALERTN", "LPOUT1_RESETN",
+			  "LPOUT2", "LPOUT2_ALERTN", "LPOUT2_RESETN";
 };
 
 &gpiof {
-	gpio-line-names = "LPOUT3", "LPOUT3_ALERTN", "GPOUT3_RESETN",
-			  "LPOUT4", "LPOUT4_ALERTN", "GPOUT4_RESETN",
+	gpio-line-names = "LPOUT3", "LPOUT3_ALERTN", "LPOUT3_RESETN",
+			  "LPOUT4", "LPOUT4_ALERTN", "LPOUT4_RESETN",
 			  "", "",
 			  "", "", "", "",
 			  "", "", "", "";


