Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C299915821A;
	Tue, 23 Jul 2024 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759385; cv=none; b=Yj5qEwQy9RxJrhT0D3i0ARqRzZLsW02auaiRDZugxIaBrqzjEzFjmZTKd7AsNtNP6sDXcThD5U5R8G04Cs9uxxAOVWorBXCmImac4JV5HEigxoNl3r1ingXAp26YYbqZ0+ZwukyAtbXfV32YZzZFeFK4ZDZWvKrmhMLCIT/vZaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759385; c=relaxed/simple;
	bh=z7pcKQoaNY4stb7WGSa9XzNRsCyBEUfZ7M6HAVWfHGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q4bfaEh7s7f2qSOBmL9fBxJmAt3N25Et26dpvGwKJjTzAtq1Yz+Gxqt7kfNvc2LIxqhRvOBwgdNCx0k1HbRqD4KSLcZ4sKmTQvUUUSiQy83Eihf9TMAxF27cxeEIUsFTv1iREH5uiUNJkIuJYDFSp/Kjz+BcPFYy2/bEoNsgVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0sGuYWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0sGuYWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B70C4AF09;
	Tue, 23 Jul 2024 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759385;
	bh=z7pcKQoaNY4stb7WGSa9XzNRsCyBEUfZ7M6HAVWfHGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0sGuYWX6J9fKCJaQ3iTPz6Ad8zG9+0fgBSM8CwQNRX0MZjIsinGncI/QkReo4Q+J
	 LzhHSmQaVw9y3/ksDLhbDgquUoldkrnYKfHOm99KushrXc9UolDsAku/Z4+N6XSGSF
	 7jUAyk2XtmqAA1QJW9pxwCg2meRDA32ko29ZRi+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/105] platform/x86: wireless-hotkey: Add support for LG Airplane Button
Date: Tue, 23 Jul 2024 20:23:44 +0200
Message-ID: <20240723180405.827538137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 151e78a0b89ee6dec93382dbdf5b1ef83f9c4716 ]

The LGEX0815 ACPI device is used by the "LG Airplane Mode Button"
Windows driver for handling rfkill requests. When the ACPI device
receives an 0x80 ACPI notification, an rfkill event is to be
send to userspace.

Add support for the LGEX0815 ACPI device to the driver.

Tested-by: Agathe Boutmy <agathe@boutmy.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240606233540.9774-2-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wireless-hotkey.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/wireless-hotkey.c b/drivers/platform/x86/wireless-hotkey.c
index 11c60a2734468..61ae722643e5a 100644
--- a/drivers/platform/x86/wireless-hotkey.c
+++ b/drivers/platform/x86/wireless-hotkey.c
@@ -19,6 +19,7 @@ MODULE_AUTHOR("Alex Hung");
 MODULE_ALIAS("acpi*:HPQ6001:*");
 MODULE_ALIAS("acpi*:WSTADEF:*");
 MODULE_ALIAS("acpi*:AMDI0051:*");
+MODULE_ALIAS("acpi*:LGEX0815:*");
 
 static struct input_dev *wl_input_dev;
 
@@ -26,6 +27,7 @@ static const struct acpi_device_id wl_ids[] = {
 	{"HPQ6001", 0},
 	{"WSTADEF", 0},
 	{"AMDI0051", 0},
+	{"LGEX0815", 0},
 	{"", 0},
 };
 
-- 
2.43.0



