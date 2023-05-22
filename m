Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ADC171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5E8C433EF;
	Mon, 22 May 2023 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784614;
	bh=EV+MBgoDQwKredYzLzARpMVhSWTqnVwgZVtGo8w2VVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcCVLb0eRYPcP630pBoapsceWZRjyZ+B4P7u76udyXfVASpiVt+isfAZavsXDF8Ji
	 aZGNE5HR9QZIMV2vc13A1dpZOVfFX85NMDBKDDq2TspU6jaTeaGp3yzRs3JVNouHfG
	 V4G01a6g8Lp/lrml6r2joEQHxD6DNW2xuAmUPKXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chethan T N <chethan.tumkur.narayan@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 140/364] Bluetooth: btintel: Add LE States quirk support
Date: Mon, 22 May 2023 20:07:25 +0100
Message-Id: <20230522190416.276195552@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chethan T N <chethan.tumkur.narayan@intel.com>

[ Upstream commit 77f542b10c535c9a93bf8afdd2665524935807c2 ]

Basically all Intel controllers support both Central/Peripheral
LE states.

This patch enables the LE States quirk by default on all
Solar and Magnertor Intel controllers.

Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index af774688f1c0d..7a6dc05553f13 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2684,9 +2684,8 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		 */
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
-		/* Valid LE States quirk for GfP */
-		if (INTEL_HW_VARIANT(ver_tlv.cnvi_bt) == 0x18)
-			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+		/* Apply LE States quirk from solar onwards */
+		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
 
 		/* Setup MSFT Extension support */
 		btintel_set_msft_opcode(hdev,
-- 
2.39.2



