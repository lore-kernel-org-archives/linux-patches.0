Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842CF3C9EE5;
	Wed, 30 Sep 2026 19:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796398; cv=none; b=BYrTdV6LyiKgCm1n7T9AZ98ssp27Zwv+XT5LvW9DWlKRg2e7Q1kGVmMM6qK0wiYD58TBMPrNvJpzS1TZK7IQtu9LgPIKrUINPiiIBtYZ/ssSO+6XSh5h/pspR+K8BgZwI+X7ZrxwFn0pKnVtrufam4Zwhx79EfEG+oyKJIJHCHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796398; c=relaxed/simple;
	bh=sRIAsio1W69fX6Znq7BpRD3Y/uuMb/ARtUYM8xdZEjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/405rhEHeEY3ayftkUY1WKziCkLKORHx2dZiVry+U4HMY8bPD55utHtqkhZBWWTZMNCn3SbzLLa+dMNGXtlVyALcaTTp5ZLjx0xU4NIw4d7IQYGo05c/u3TPuhpVgyvqIEG5CZyj58up16kaKJYnsMuJ03AQjrnbWfMdQnGw7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YbUEz6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YbUEz6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09F81F000FF;
	Wed, 30 Sep 2026 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796397;
	bh=ONR/b7JuX2E/4DIwZz4HH+17XzcMUDUA66mZQ9yxEWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YbUEz6rgWzdwkM53YLbkGUamF6GxT4gzE/zQ7gJadqVdKzUDB7wOnPjvma0xdkdx
	 IlYDOf2QmZgFQIFu8h2QcK2+Z1vXBJqYVhXPCmNcSReOmuwvoBHuA797MFqz1hbMTY
	 EtdLfQUT/sdV+fLL8TlQHOs6YgNkPlcIzFYwrS1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Sommers <chris.sommers@icloud.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0897/1193] Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P
Date: Wed, 30 Sep 2026 17:26:21 +0200
Message-ID: <20260930152454.171709887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Sommers <chris.sommers@icloud.com>

commit 25e424eb4ae1a662d9c3573218d06ac32f797fc5 upstream.

On the Acer Aspire Go 15 (AG15-42P), the internal keyboard drops out
~5 seconds after boot on both Linux and Linux-LTS kernels. Keystrokes on
the built-in keyboard stop registering while the trackpad and external
keyboards remain functional.

Testing confirms that booting with the i8042.reset kernel parameter
resolves the issue and keeps the internal keyboard responsive.

Add SERIO_QUIRK_RESET_ALWAYS to i8042_dmi_quirk_table for the Acer
Aspire AG15-42P to automatically apply this quirk on boot.

Signed-off-by: Chris Sommers <chris.sommers@icloud.com>
Link: https://patch.msgid.link/20260907182723.2709981-1-chris.sommers@icloud.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -261,6 +261,13 @@ static const struct dmi_system_id i8042_
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire AG15-42P"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-132"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)


