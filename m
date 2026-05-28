Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B333F5BE;
	Thu, 28 May 2026 20:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999286; cv=none; b=I5eLRUAYgk3+P7i/bqjAubOQEdIDD5ewgGk/IuEq6RIJEVlPej5y+/jnunfW2h3Uy1l9r80LnxaYUE4ntDbnShSrLUgc5/z/DFs3nvm/SsLA3NQqYH6AxFQcnio2kbbsB7/DcgoahzUcWD7CKW/k/+jN6/QfSQq7QaK2hnlm4to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999286; c=relaxed/simple;
	bh=E+UtKe57HycudF7DbdL9tuRzN9ZnOXUG6wpiXNNa2lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8mDdRiMlpEm8uznabajrsi38H326ZLUfBcCRGDeyN/ACR5XxJrb4EwEfQ4vh09d1jzYBtkZeTa/nKCr5cPoATkNqvS+CO/5NhGVkjrFyHACQHdnY9nam5CYeHxFTrzl9qhoHBCzSSQwHtY3WoPK4uNrFUK6gLGfHe5RIYq1Zv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBvkie9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBvkie9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201181F000E9;
	Thu, 28 May 2026 20:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999285;
	bh=hCxuf0p8LWUsK3xAT99gj19aoj9eUbtxzXAVyDk4pYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBvkie9WWQatJuHXCXI2xbWlaE2ZovEaiuTedbjzQiBkbDRw2e8LMdiDdDcCp2kxC
	 X/KPws0ZtkAOHDZ3nbW66GIugPAZ2IzW7rhjiITXl/iW/FY8uQeoaN7R9C4LqEgaJq
	 arqMZRGhK+b8IHhUS27WcyJFk7TQLZaQ87j4UghY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.18 013/377] arm64: dts: broadcom: bcm2712: Add watchdog DT node
Date: Thu, 28 May 2026 21:44:11 +0200
Message-ID: <20260528194638.772161478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Stanimir Varbanov <svarbanov@suse.de>

commit 37c3a91e9730e274fe2eca9703033ae0f154cb62 upstream.

Add watchdog device-tree node for bcm2712 SoC.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Link: https://lore.kernel.org/r/20251031183309.1163384-5-svarbanov@suse.de
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm2712.dtsi
@@ -250,6 +250,15 @@
 			status = "disabled";
 		};
 
+		pm: watchdog@7d200000 {
+			compatible = "brcm,bcm2712-pm", "brcm,bcm2835-pm-wdt";
+			reg = <0x7d200000 0x604>;
+			reg-names = "pm";
+			#power-domain-cells = <1>;
+			#reset-cells = <1>;
+			system-power-controller;
+		};
+
 		pinctrl: pinctrl@7d504100 {
 			compatible = "brcm,bcm2712c0-pinctrl";
 			reg = <0x7d504100 0x30>;


