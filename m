Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14002269811;
	Tue,  8 Apr 2025 12:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115874; cv=none; b=DZZYEWvtWKr0btGMxrFW7BqA3ar26QtcpTT4FBNOyJ44AE8uX0G499ut4Mjji1MKqbYH+Dhsk/V1cyGBDL+9H9slG8g3GAknEkPEVRKM7e1XYqyGyDVcr4sFqJbeQAhe/OEgzJKJ6OoUprVi5975XUuQ8O4JI7Tx4g2ib2LMFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115874; c=relaxed/simple;
	bh=ZlASRtkmLYNsUvx69MvBYSp1/y1ogNMVPEpMAbqZMyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K/hBg6SPhG53nQSVX5j5wjhe2gVGSOBIXtG76kE2w0n8W14NOK22+UONY0Ee4CwzHyWMyzKtQhz+eXBR6vZbFI2jZabXXODTRs1pwAUAsLizPfk2O0LUUOubT0b+euQIOOUJUNAmwjUVzznbRSqy/YvOo9je1n6sgqXY8GnsPik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIHYvSVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIHYvSVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96375C4CEE7;
	Tue,  8 Apr 2025 12:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115873;
	bh=ZlASRtkmLYNsUvx69MvBYSp1/y1ogNMVPEpMAbqZMyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIHYvSVzUrddBDCiSm5J/oqs01OK9yEdcdBvR7uJtI4oPrfuCK0hB2XjM7gwDAW92
	 xCtyd4mAqIwq8Iuvk5bs1Dcq8NxWmKnhpQ6OCMQGMv/MBgxhTwuTmC1h70d1DYKbSb
	 B9wgkCF0mTuInSVskRrwuK5sd+d82WOwFY97Rtps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Panchenko <dmitry@d-systems.ee>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/204] platform/x86: intel-hid: fix volume buttons on Microsoft Surface Go 4 tablet
Date: Tue,  8 Apr 2025 12:51:06 +0200
Message-ID: <20250408104824.288262450@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Panchenko <dmitry@d-systems.ee>

[ Upstream commit 2738d06fb4f01145b24c542fb06de538ffc56430 ]

Volume buttons on Microsoft Surface Go 4 tablet didn't send any events.
Add Surface Go 4 DMI match to button_array_table to fix this.

Signed-off-by: Dmitry Panchenko <dmitry@d-systems.ee>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250220154016.3620917-1-dmitry@d-systems.ee
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index b96ef0eb82aff..c13837401c26a 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -109,6 +109,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 3"),
 		},
 	},
+	{
+		.ident = "Microsoft Surface Go 4",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Surface Go 4"),
+		},
+	},
 	{ }
 };
 
-- 
2.39.5



