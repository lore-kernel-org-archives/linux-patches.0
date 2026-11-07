Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060971;
	b=uOJnag7bLFYw4L2TYgLsM1HcyxiZ02FKby69rIj6uay/AJ+zcoXbaf9uXcPcqDx5plEw
	 rsQ0nPfE83pJvSBzAyvfBnNL/MNv/KUrhwp8xNfbr1bPQuEIM7xFqgDTjyyw3YdZBD1XT
	 yLEVuesm6kcLWyuojCNEl3KNC/62MKM4VbgLFQpXoZhxnLNSmjk4xA/maKo6UY6jaOoFl
	 hNE13VP5v5OvsY1ObDkeywWdCRKFqc18JXVtOVkbSbimXNmsrdHpbp19SZMObi00u7xUD
	 qhGQcPF661TNZckZ/MLFRXHSHaKlhyWun2vhX/6tzY5vNPVUpP7rdtuHbpax04MDWyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TUF/seseX4xQSabZd5+dmipzNmXNUrmOCfy7+N704pM=;
	b=1JssELfWKMFl98Fz4uQ3RUSkJB4Rw/n8d6jMF8Qpmkbv45UQM96WpfGneJxfJFifXw1u
	 921qp78KCsbFh4ELScyPLg4qWUACfMKC1yxEDPkYPV0M86VOmdNzu9VfO1BEcZ2IDdiTe
	 LEejvFwxJGQ3g8e5qk20wk/AnOHJLj4w6Pe5DHUyzlvDfc6s4uOJAlENkUp698o028Y0w
	 VoPg2OSjhBvT/93H5wgkzYFVLcKnVF4hpKu5RJhIPrvwiRkqr6QVCGDKURl9NNF7Y9hcE
	 h5p+zcC3bLYfYggzbpDesyVhkKCpNNo6wW1WP2XRTkLjpLS9IPvWMs/DMgMb7GSKSAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpuLF8wL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A48606EEAC;
	Sat,  7 Nov 2026 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpuLF8wL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814E51F0089F;
	Sat,  7 Nov 2026 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060970;
	bh=TUF/seseX4xQSabZd5+dmipzNmXNUrmOCfy7+N704pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpuLF8wLfpQIW4/WON0tlwZ1+OPaV0ncb/8izKNAnvHot86u4BPWF9xiaFsxJlr9y
	 8gKdWvM9HbPw61k8MQ84eqQFS5y3Ijo6qNX7FG+NuCbKzoluHNg/7tWd/Zhk9G5oDw
	 2zWNiGPDHPPaVul1UYX9wpVJ0AtFNBxVY+HEYohA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0324/1536] soundwire: dmi-quirks: Disable ghost Realtek on Asus ROG Zephyrus Duo
Date: Sat,  7 Nov 2026 08:39:00 -0500
Message-ID: <20261107135006.818693654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5b08a3afd2995e5312c4c47ffea9d21b651e8e13 ]

The Asus ROG Zephyrus Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Suggested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260807121425.1952003-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index f738e547a1f30..768255dd12db6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -193,6 +193,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "GX651AR"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0



