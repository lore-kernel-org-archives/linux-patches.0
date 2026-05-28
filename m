Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EA5402B8F;
	Thu, 28 May 2026 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999167; cv=none; b=HRFzZb8t8pShmezJt5oPaGEQzkWKSWKl8CaotEUzI3jDo3VfU6LadXbR632LGvCF3ce6vw+hiSXaXWHBDBDCbH9RAlcz83+02quNBSc+vm9pc1geob8HnQ4xVLkytA1EURmDMEwU2q/LDhSMZxM5N6gX5iZgTdhmX2OMHe/tg44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999167; c=relaxed/simple;
	bh=2lRXF/Rgr4PuX+NsNnH9zJktH2bWVaauuzTEBv0ux3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTvCMgOYrXQP0/Cm5bUnG8UmxbkiOmL2dG2FaPBx3NQJxwftwT6pru5uLBQB0UL2WvV0+WmkTwf/Wgy8Wtf/7vhy+N/zYiRBtD6rnoCEkd8WjuckgbygtTNdJl05kaidIroyHxG9p+50ldGJOL75b57coeLi8Zrf/DXXa0TbjDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KI8WQI6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KI8WQI6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E4D1F000E9;
	Thu, 28 May 2026 20:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999166;
	bh=8AXHzSDIRT0ga5i0k8zgUC6RucoIUKt8hD33up1dLmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KI8WQI6XWEyBDVTOgwkW2TXBBOZddq1RmoYeB/AznJvpHZYmR5as41gf8PV3NF73W
	 sGnuBqoQNrEphzYpznYBVV3XvLQ9xKrXFEDRoMYiauQw9X+9v6Ebrfbf597tzRNIWO
	 HtQUyOc+92/hubgAX3y0BqjPPKWU8/j3JMGH/Ml8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 395/461] platform/x86: uniwill-laptop: Fix behavior of "force" module param
Date: Thu, 28 May 2026 21:48:44 +0200
Message-ID: <20260528194658.902127143@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit fb4b67c44557cb4cbb15900083d4e1af22320339 ]

Users might want to force-enable all possible features even on
machines with a valid device descriptor. Until now the "force"
module param was ignored on such machines. Fix this to make
it easier to test for support of new features.

Fixes: d050479693bb ("platform/x86: Add Uniwill laptop driver")
Reviewed-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260512232145.329260-4-W_Armin@gmx.de
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/uniwill/uniwill-acpi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/uniwill/uniwill-acpi.c b/drivers/platform/x86/uniwill/uniwill-acpi.c
index 07951e01b43db..540604c297715 100644
--- a/drivers/platform/x86/uniwill/uniwill-acpi.c
+++ b/drivers/platform/x86/uniwill/uniwill-acpi.c
@@ -2189,8 +2189,6 @@ static int __init uniwill_init(void)
 		if (!force)
 			return -ENODEV;
 
-		/* Assume that the device supports all features */
-		device_descriptor.features = UINT_MAX;
 		pr_warn("Loading on a potentially unsupported device\n");
 	} else {
 		/*
@@ -2208,6 +2206,12 @@ static int __init uniwill_init(void)
 		device_descriptor = *descriptor;
 	}
 
+	if (force) {
+		/* Assume that the device supports all features */
+		device_descriptor.features = UINT_MAX;
+		pr_warn("Enabling potentially unsupported features\n");
+	}
+
 	ret = platform_driver_register(&uniwill_driver);
 	if (ret < 0)
 		return ret;
-- 
2.53.0



