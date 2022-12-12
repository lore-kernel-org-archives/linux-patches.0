Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73EA28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6179C433D2;
	Mon, 12 Dec 2022 13:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852478;
	bh=6XtLrRztLT49PwtPcfJn1HavAPx/qrKBidrAAUeWkaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClQXVPqftRO9kmv4Nx6A1ZnokHlE791U5XTosHg7xorKhM06UnETONiR0u+N6Y4ia
	 D9DOcKr3MJfA6jNQe2Kuajt9Y73IY7v8SNAdYrF6u5YKre4phDVkOO7sAmDkn4Tj6i
	 4MIpRQFkHZr/R8uFq8m7+EYSTJCcel4Q8eBb00L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.0 062/157] Bluetooth: btusb: Add debug message for CSR controllers
Date: Mon, 12 Dec 2022 14:16:50 +0100
Message-Id: <20221212130937.063792083@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

commit 955aebd445e2b49622f2184b7abb82b05c060549 upstream.

The rationale of showing this is that it's potentially critical
information to diagnose and find more CSR compatibility bugs in the
future and it will save a lot of headaches.

Given that clones come from a wide array of vendors (some are actually
Barrot, some are something else) and these numbers are what let us find
differences between actual and fake ones, it will be immensely helpful
to scour the Internet looking for this pattern and building an actual
database to find correlations and improve the checks.

Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2042,6 +2042,11 @@ static int btusb_setup_csr(struct hci_de
 
 	rp = (struct hci_rp_read_local_version *)skb->data;
 
+	bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x; LMP ver=%u subver=%04x; manufacturer=%u",
+		le16_to_cpu(rp->hci_ver), le16_to_cpu(rp->hci_rev),
+		le16_to_cpu(rp->lmp_ver), le16_to_cpu(rp->lmp_subver),
+		le16_to_cpu(rp->manufacturer));
+
 	/* Detect a wide host of Chinese controllers that aren't CSR.
 	 *
 	 * Known fake bcdDevices: 0x0100, 0x0134, 0x1915, 0x2520, 0x7558, 0x8891


