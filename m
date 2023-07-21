Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E372F20F98
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659B0C433C8;
	Fri, 21 Jul 2023 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966846;
	bh=94t/qQ7UT9yXpD/OkKqaGHZP2nKFey1wTUy2/hs81y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQowccS5r91mqeLRm18DMwJGuV0ZuIZE198UMWjZ74q7b1LMh5LLuveTt/mKYMMX0
	 YSUR3V9NuOs10WlZsNQH8G1FF9JsEwk8VHI5JfANlW4gQ68tJWIZjlCkV9M2L0+l7u
	 BkyFM4dJcyEi4uGY4XMKxs61cp6H27vmj3VwD28A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Zary <linux@zary.sk>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 471/532] PCI/PM: Avoid putting EloPOS E2/S2/H2 PCIe Ports in D3cold
Date: Fri, 21 Jul 2023 18:06:15 +0200
Message-ID: <20230721160640.071641472@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ondrej Zary <linux@zary.sk>

commit 9e30fd26f43b89cb6b4e850a86caa2e50dedb454 upstream.

The quirk for Elo i2 introduced in commit 92597f97a40b ("PCI/PM: Avoid
putting Elo i2 PCIe Ports in D3cold") is also needed by EloPOS E2/S2/H2
which uses the same Continental Z2 board.

Change the quirk to match the board instead of system.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215715
Link: https://lore.kernel.org/r/20230614074253.22318-1-linux@zary.sk
Signed-off-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2886,13 +2886,13 @@ static const struct dmi_system_id bridge
 	{
 		/*
 		 * Downstream device is not accessible after putting a root port
-		 * into D3cold and back into D0 on Elo i2.
+		 * into D3cold and back into D0 on Elo Continental Z2 board
 		 */
-		.ident = "Elo i2",
+		.ident = "Elo Continental Z2",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Elo Touch Solutions"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Elo i2"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "RevB"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Elo Touch Solutions"),
+			DMI_MATCH(DMI_BOARD_NAME, "Geminilake"),
+			DMI_MATCH(DMI_BOARD_VERSION, "Continental Z2"),
 		},
 	},
 #endif


