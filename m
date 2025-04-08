Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D93F206F18;
	Tue,  8 Apr 2025 12:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115010; cv=none; b=YcHsH7M3nAJ6vBTzFGS0GIVddUqESOdLeRsewYsxO3R4mCZrzRroC/PDUBXxBEZa4VDdIVHSvUl+yuE43wYu7oyataXHrnOrj26CxO8awmVUewRAttCryfAr3J2mZcMbqgl0bWBi35btm9gibl8k7/FNOS8RvqzzPZMh9GSGyhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115010; c=relaxed/simple;
	bh=h5/uLMriOmqM26txTM43XB0S7wA1fDeG+TX4Ea1TCd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tw+SXkX6ITv1BXf8lYRMfgkG96yaiIqMvhpYgZVmw3tNWRvFsu4CdKBmiPBJOlwTM8dokBbjyXf57XQhA1mtwiyGFlRxSkrXxu1/TSIEr9u1M+lkaXRXqmyZo0//hvfywoVZ0yyS1uBiG1HIUo0fn2dO7+5R+T/1K/mE8ULPVuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEx/kDuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEx/kDuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DDEC4CEE5;
	Tue,  8 Apr 2025 12:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115010;
	bh=h5/uLMriOmqM26txTM43XB0S7wA1fDeG+TX4Ea1TCd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEx/kDuws8pBowXyVZq67L3ldxWipD6K8fM3uc7Zm5KfUto2BDujcpcD8zzqJio/K
	 k19rNFkpmwglJeToE3XYz7njzdCkl2t9asxDbSS3RoQ3+7V0O27D1L0XfeB+8jAM35
	 n5DKgPFlnpTR8ZE1Wn39PrxsQKQ9jDa3RatYb6Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Panchenko <dmitry@d-systems.ee>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 316/499] platform/x86: intel-hid: fix volume buttons on Microsoft Surface Go 4 tablet
Date: Tue,  8 Apr 2025 12:48:48 +0200
Message-ID: <20250408104859.099678207@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 927a2993f6160..88a1a9ff2f344 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -139,6 +139,13 @@ static const struct dmi_system_id button_array_table[] = {
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



