Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E61DF74F;
	Tue,  8 Jul 2025 16:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992793; cv=none; b=ibFBINkI/nfhbHcVfB4CiEwC8t+oIpS0REswPSJ+LCEFCLxjKD5etCG3JJKpXDZHWGWbwtW0hkwvpNkIKbNxi0uE9r7ZE/lW3Pg3M0xvlzUA7aSrlTahUaDc52bQBwb45sAEg8tfa9OxmDBfIZEDyOObKwIBAfLwwomPjFnC4K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992793; c=relaxed/simple;
	bh=e0NBTJMQ0PnwVoAyefk6xHUEF/OSdHxD59faEit9gRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MKx1xs9vnEvsqOHhRSqRd/TKxLZTq/R5lb2Py83lpI8beUXIt9uV3hBxHlm58McgYCXRlPThyqUZgOeynCzImF+UQJQWN93FP08KY3LIlnAM66ntVPQFxM2+IHy9TfpuJ6i5G90fYqCeDMLDIep0aAmJsFQI0z/j8A9E79Qt/v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1V4Z+z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1V4Z+z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276C9C4CEF7;
	Tue,  8 Jul 2025 16:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992793;
	bh=e0NBTJMQ0PnwVoAyefk6xHUEF/OSdHxD59faEit9gRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1V4Z+z/KCXtx22uT/Gtq9BjWJ18Kvo4iOnHAdsguYDriW3tiaeLuPHfBC4DHBlM5
	 7K1TktDnX4/g1NiBnOelIl2qRgiafYvf+/mRiXug4p77p5atEKMjwiU3DrT/+WykyM
	 GgS8JwRt2i0BnFpPR8+gSQNgBblb6vWn3taMsp8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/232] platform/x86: hp-bioscfg: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:21:01 +0200
Message-ID: <20250708162243.164662954@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit 11cba4793b95df3bc192149a6eb044f69aa0b99e ]

Devices under the firmware_attributes_class do not have unique a dev_t.
Therefore, device_unregister() should be used instead of
device_destroy(), since the latter may match any device with a given
dev_t.

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250625-dest-fix-v1-1-3a0f342312bb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index 0b277b7e37dd6..00b04adb4f191 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -1037,7 +1037,7 @@ static int __init hp_init(void)
 	release_attributes_data();
 
 err_destroy_classdev:
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(bioscfg_drv.class_dev);
 
 err_unregister_class:
 	hp_exit_attr_set_interface();
@@ -1048,7 +1048,7 @@ static int __init hp_init(void)
 static void __exit hp_exit(void)
 {
 	release_attributes_data();
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(bioscfg_drv.class_dev);
 
 	hp_exit_attr_set_interface();
 }
-- 
2.39.5



