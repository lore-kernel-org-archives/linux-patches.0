Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620776;
	b=eeSeUgVYiqTFcZlrOFKjf55gUI6k3EeAlpNOfW/AWeV4p4XothsZsA37AcrCHiY0ykau
	 YH7v3GrGp/bkqGxGMSTE7w8ATrcWQE72HpteNYjzOMuHCiXJrK7O1BnILMliwALzQ8bUG
	 GAft+Dvh09MTg1kiLKshqyS3vminPhUk2jxZTBlHNuGaZczgGi7g6KWcDx/hH6gsbojn6
	 7CRv0Ydp2r9MBuw3qpDVQzBVa3ogQVp7khT0s98hSEwasYu1wGOKnK/lhASTzXDdG5xPY
	 9J/jpQzqc6IvT334Ld/Vxs+n4KK//xZixgA8YIcyj4qHrgkAQ7mb11KSmV+lfVI/tdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wxJNraM0JnWLZzfnjo/OgztwZbTgvujhu4fsRNC68cQ=;
	b=AnaNKiOoH4kzIdFzbuGsIas+0BdPa2MEhJKJafaYVCQd8rFsJvWh5sX/H7oyxn2kZvmG
	 bHnGIKVHAVWvtiP8xpqNIQ7gx0DTHyxcVD3SfCxZ26jQFNOWiga2IUgwpb51xx57iIDcr
	 VMzswsNrcBHjUt3WuF/e1D5XmGHRTDGBe+dpequH1nrd5YBrKwx/xE6D35i/7vTccTQm6
	 aD6F+pwoZyysXg35yKhIZJn6zRUkaySyrDrUswPYINknKuFIek+yb0IjoKR8mdavTrnjd
	 24nu4X8NLdkOmBJcO1X9kk8h5e/VUvqifENY8jY/izVfDB9r2jUSu4sj6JgSTlFZjZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsmtI2dL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269A3606A31E;
	Wed, 25 Nov 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsmtI2dL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED09C1F000D0;
	Wed, 25 Nov 2026 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620775;
	bh=wxJNraM0JnWLZzfnjo/OgztwZbTgvujhu4fsRNC68cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsmtI2dL5NoUIVm7AHeK562zhqtMlM1SNRdLwpNYmTn/eIiBlj3CVdTD08+48wgMp
	 bmtzm45hsEV7MFY/bcx0MUDtk1aFgWxdTAmCDjqNNEgii/SE2s79PheNIPcDvHy0WM
	 1g6EWJryS9yWllt+9vjj7CTIey+qV3tN00wvv1II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Bard Liao <bard.liao@intel.com>,
	Sergey Lebedev <lsa.uz@pm.me>,
	German Pablo Lindo <germanpapulindez@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/990] soundwire: dmi-quirks: drop the ghost RT1320 on the Surface Pro 11 (Intel)
Date: Wed, 25 Nov 2026 15:22:58 +0100
Message-ID: <20261125143822.351251729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Lebedev <lsa.uz@pm.me>

[ Upstream commit d32e04c052342d7d1cc03f6ba4cbd135cd0112bc ]

The Microsoft Surface Pro 11 for Business (Intel, Lunar Lake) carries a
single physical RT1320 amplifier on link 0 and describes it twice:

  SWRA  _ADR 0x000030025D132000   SDCA class 0
  SWRB  _ADR 0x000030025D132001   SDCA class 1

Identical apart from the class id: same link, same manufacturer, part and
version, same unique id 0. The part reports class 1, so only SWRB
enumerates. SWRA never attaches on any boot or firmware version tested,
including the November 2025 bundle.

The ghost is not harmless. It consumes an amplifier index in
find_acpi_adr_device(), so the real part is named "rt1320-2" and the stock
sof-soundwire UCM profile enables switches on a device that is not there.
Its endpoints also reach create_sdw_dailink(), which builds DAI link names
from link id and function type alone; the ghost declares the same SmartMic
function as the real part, so the card fails to register at all:

  sysfs: cannot create duplicate filename
    '.../sof_sdw/SDW0-Capture-SmartMic'
  kobject_add_internal failed for SDW0-Capture-SmartMic with -EEXIST
  sof_sdw sof_sdw: probe with driver sof_sdw failed with error -12

Remap its _ADR to zero so sdw_acpi_find_slaves() never creates the
peripheral, which is how ghost devices are handled already - see
ghost_realtek and global_ghost_adr in this file. Both failures then
disappear, because neither path is reached.

Matched on DMI_PRODUCT_SKU rather than the product name. A later batch of
the same model could carry a different RT1320 version, which would change
the _ADR; keying on the SKU keeps this remap to the hardware it was
verified on, and follows dell_sku_0A3E above.

Link: https://lore.kernel.org/linux-sound/20260830151516.44629-1-lsa.uz@pm.me/
Suggested-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Suggested-by: Bard Liao <bard.liao@intel.com>
Signed-off-by: Sergey Lebedev <lsa.uz@pm.me>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Tested-by: German Pablo Lindo <germanpapulindez@gmail.com>
Link: https://patch.msgid.link/20260913210849.6446-1-lsa.uz@pm.me
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 72e59b50b6853..f9183e0e63bfa 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -111,6 +111,25 @@ static const struct adr_remap ghost_realtek[] = {
 	{}
 };
 
+/*
+ * The Microsoft Surface Pro 11 (Intel) describes its single physical RT1320
+ * amplifier twice on link 0, as two _ADR entries differing only in SDCA class
+ * id and sharing the same unique id. Only the class 1 entry enumerates; the
+ * class 0 entry is a ghost.
+ *
+ * Matched on the product SKU rather than the product name: a later batch of the
+ * same model could carry a different RT1320 version, which would change the
+ * _ADR. Keying on the SKU keeps this remap to the hardware it was verified on.
+ */
+static const struct adr_remap microsoft_sp11_intel[] = {
+	/* ghost rt1320 on link0 */
+	{
+		0x000030025d132000ull,
+		0x0000000000000000ull
+	},
+	{}
+};
+
 static const struct dmi_system_id adr_remap_quirk_table[] = {
 	/* TGL devices */
 	{
@@ -242,6 +261,15 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	/* LNL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU,
+					"Surface_Pro_11th_Edition_With_Intel_For_Business_2103")
+		},
+		.driver_data = (void *)microsoft_sp11_intel,
+	},
 	{}
 };
 
-- 
2.53.0



