Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF8128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8F4C433EF;
	Mon, 12 Dec 2022 13:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851007;
	bh=iR0JKrsCzyNGIsDWWpfLQ7wJGkKiN8BYYC0zBRTuNa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tn+Yy7WvBDyGGqo5GSZJAWp4jdnRVBywDQ73a+DOTFu7Ajpji+4/S2qX7dVOdJ16F
	 sPBtds4Qpl4I/ty+kHEO2EOHxX1Gwzhr6ZE/HEEC03+aseXinCEafE82m36jfiBg9E
	 HG5XVLbKkSGyHv5J9ZyyeqgGgBke/CwsPcLg2HiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 050/106] Bluetooth: btusb: Add debug message for CSR controllers
Date: Mon, 12 Dec 2022 14:09:53 +0100
Message-Id: <20221212130927.039181890@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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
@@ -1833,6 +1833,11 @@ static int btusb_setup_csr(struct hci_de
 
 	rp = (struct hci_rp_read_local_version *)skb->data;
 
+	bt_dev_info(hdev, "CSR: Setting up dongle with HCI ver=%u rev=%04x; LMP ver=%u subver=%04x; manufacturer=%u",
+		le16_to_cpu(rp->hci_ver), le16_to_cpu(rp->hci_rev),
+		le16_to_cpu(rp->lmp_ver), le16_to_cpu(rp->lmp_subver),
+		le16_to_cpu(rp->manufacturer));
+
 	/* Detect a wide host of Chinese controllers that aren't CSR.
 	 *
 	 * Known fake bcdDevices: 0x0100, 0x0134, 0x1915, 0x2520, 0x7558, 0x8891


