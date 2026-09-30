Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437C54CCDC1;
	Wed, 30 Sep 2026 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782654; cv=none; b=HR7s0WcTpyxSontbOJgjDYjuWDqB1NdusoWOv2ucYeQHQald+jNWJiCS78+Kog+wyNtkPvb3zyKL3FxttGFfWHF3ZrNM1QYwj73jr99f3V1Go6DpnMYpgNsPjB49+LTUhi9HduT+1qJUNCutvOXskuFk4x12G4nuXb6ZYDLxAfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782654; c=relaxed/simple;
	bh=+93clNiIz//BITgVHy8Eh9/jc7xyX2pJUQ4NthtPOZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uI2ylpa6AzmZlww7bAcjK/cjYI6gevAkIbA31cYLLXm80HW7vBVZqCGZBpGiOg5Q50mQ9J8a9vTeVKAqWMJVuab/iyEdDeJMRub9xS9lg/KkVGKSk1eDLqWtLTCywaF//WU+0IJGEnuGFyEddQ3tkgZASFNhglvVkPflGfvaJZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWWPqpHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWWPqpHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656251F00893;
	Wed, 30 Sep 2026 15:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782643;
	bh=YXlBdzKHjBnQywrriXWbhhUbWLpnrpA1VeZL+u/BhJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWWPqpHjs5SVrIZ8InrvTyjxemX1tImdIw73poHTZLniRFb98rMup4PQLwwXoV/E7
	 EcLPO92mFGfa8InlshQbyFBNrzTWrIck+ZSEjOlTHO5+fS1KFnKTNzZQWD6Fp5KJ2p
	 I6DyYLv6qGczHxZLCYEh8KBtOPYzbvNaWaWC935A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Sonichev <sonichev555@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/595] platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table
Date: Wed, 30 Sep 2026 17:20:05 +0200
Message-ID: <20260930152350.146190666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/dell-laptop.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 70edc5bb3a146..af5001ecf77f2 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -198,6 +198,15 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
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



