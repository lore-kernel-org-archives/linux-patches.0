Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ACE299943;
	Thu, 27 Nov 2025 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255272; cv=none; b=QfGXgGIIQhoYwTj77+T/VkYjow7dIq3frfPmhw3HYHagxb+b1bxaxoqcLHDio8UlbbBsr5hPKNK27LwnqxKsOxmkY00/pg/xhYOZW7RjBSulneUcX8/8OFnJur2ZLrvfTkicWPmZiBQ7Pl62cjkgmk8QdS0TjGASmJp3fG/twMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255272; c=relaxed/simple;
	bh=6dqLq0aMl7iV8qUB0SfsNuhAazKfUZU9OzhLQ9c+QqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIkWOjlqeGJUuv+gZBYX8xPgkGypo2+Gw1Ubc5/O6ZW8hDtUSTM+02XCZHl/ZxmlJKuCwiyJxpU34R8u1hCcKBO+NQuoQt1zGtX4dpJ4YIy4ynzqh/b06ZpW3lNq/wchDYuvhRAfuYSxGdYBW6t/AcTDfjDxF9ieJOPpOG0Hma8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/0rZxkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/0rZxkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFE4C4CEF8;
	Thu, 27 Nov 2025 14:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255272;
	bh=6dqLq0aMl7iV8qUB0SfsNuhAazKfUZU9OzhLQ9c+QqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/0rZxkLqy9GNTiFvS5e7hTD0XN7sz9g/miT4lSTF1tQRvT6mdv+Yduwp4xLJEUZF
	 FUahPKXXeLPg4IjS3W2OjeL0mVvFpKNWuYn7OWv6sZElgFb80xV4mDIrXxwC9hkzF6
	 ktu5VoodNGr/XyXuLmjCHqx7BkU8MNsB9ymjL26Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/112] platform/x86: msi-wmi-platform: Fix typo in WMI GUID
Date: Thu, 27 Nov 2025 15:46:02 +0100
Message-ID: <20251127144035.036782444@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 97b726eb1dc2b4a2532544eb3da72bb6acbd39a3 ]

The WMI driver core only supports GUID strings containing only
uppercase characters, however the GUID string used by the
msi-wmi-platform driver contains a single lowercase character.
This prevents the WMI driver core from matching said driver to
its WMI device.

Fix this by turning the lowercase character into a uppercase
character. Also update the WMI driver development guide to warn
about this.

Reported-by: Antheas Kapenekakis <lkml@antheas.dev>
Fixes: 9c0beb6b29e7 ("platform/x86: wmi: Add MSI WMI Platform driver")
Tested-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251110111253.16204-3-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/wmi/driver-development-guide.rst | 1 +
 drivers/platform/x86/msi-wmi-platform.c        | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/wmi/driver-development-guide.rst b/Documentation/wmi/driver-development-guide.rst
index 429137b2f6323..4c10159d5f6cd 100644
--- a/Documentation/wmi/driver-development-guide.rst
+++ b/Documentation/wmi/driver-development-guide.rst
@@ -50,6 +50,7 @@ to matching WMI devices using a struct wmi_device_id table:
 ::
 
   static const struct wmi_device_id foo_id_table[] = {
+         /* Only use uppercase letters! */
          { "936DA01F-9ABD-4D9D-80C7-02AF85C822A8", NULL },
          { }
   };
diff --git a/drivers/platform/x86/msi-wmi-platform.c b/drivers/platform/x86/msi-wmi-platform.c
index bd2687828a2e6..e912fcc12d124 100644
--- a/drivers/platform/x86/msi-wmi-platform.c
+++ b/drivers/platform/x86/msi-wmi-platform.c
@@ -29,7 +29,7 @@
 
 #define DRIVER_NAME	"msi-wmi-platform"
 
-#define MSI_PLATFORM_GUID	"ABBC0F6E-8EA1-11d1-00A0-C90629100000"
+#define MSI_PLATFORM_GUID	"ABBC0F6E-8EA1-11D1-00A0-C90629100000"
 
 #define MSI_WMI_PLATFORM_INTERFACE_VERSION	2
 
-- 
2.51.0



