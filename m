Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD840503BF7;
	Wed, 30 Sep 2026 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791059; cv=none; b=SSo9xslHIa64kfT2vN/wW948D7WJADZDSJhPbZ5QZMsSTKWGTTbEuk42JwZpboIAn4KkiwQr5/IhvlP9ItrK2hmUyRxK3q8tV7/8gfEgfofrD9TDXyP6S6se3BFh1UOQrlcemQrFeeBhzNFtqX2nsoc4kYCYYD8xKLQTDQj/nKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791059; c=relaxed/simple;
	bh=QNywt2kGdfpshXECd3Y+IGX1Z9jgZCPcy3BYLwGvTyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEKKcFQk77RGO0EvJe3cLjqhr6lEMLS2OI9LReQfYKGPXpg2cGNHjjpc5TXck2l2mxs+VCDWsHZwP/Rua4/m3ipIhRBKGvPi+hsdowZ1B78dVYOoH0J6VBbZHGmVkDixGf3EXmCi/mio9cFg1crsE0s0Hi3Gqfvs25oXID2zTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WWrS0Pp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WWrS0Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CF41F000FF;
	Wed, 30 Sep 2026 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791057;
	bh=MxFvTvVEEMZjplS9goMeXF11yJmeH5czYeYlJPGCpwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WWrS0PpmdsH7gkyzLTv0gSZX9KfVQpfs/4P1D3EbFcCMfDbz605JigJSUEJsXGYl
	 BtNIlFiW38RzKLXEFAatuYoDOeOsLTbkiPTlY31hXEu2B/gmgMAGIZXYsnbX8DqAvj
	 rVBRxC7I9xTpfonKcok14zBIGMp+aVq1Z90gyZGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Sonichev <sonichev555@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/752] platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table
Date: Wed, 30 Sep 2026 17:20:02 +0200
Message-ID: <20260930152401.036281637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Sonichev <sonichev555@gmail.com>

[ Upstream commit bfe91a80b13f8068f6fa07aa8c468d284150d4ad ]

The Inspiron N5110 needs the touchpad LED quirk (Vostro V130 quirk)
to properly control the touchpad LED. Add its DMI identifier
to the existing quirk table, next to the similar Inspiron M5110 entry.

Tested on Dell Inspiron N5110.
The touchpad LED works correctly with this quirk enabled.

Signed-off-by: Gleb Sonichev <sonichev555@gmail.com>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://patch.msgid.link/20260525100047.20046-1-sonichev555@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-laptop.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-laptop.c b/drivers/platform/x86/dell/dell-laptop.c
index 8230e7a68a5eb..01230c95b0408 100644
--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -201,6 +201,15 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_dell_vostro_v130,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Dell Inspiron N5110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron N5110"),
+		},
+		.driver_data = &quirk_dell_vostro_v130,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Dell Vostro 3360",
-- 
2.53.0



