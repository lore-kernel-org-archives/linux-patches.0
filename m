Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA0220FAAB;
	Thu, 27 Nov 2025 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255731; cv=none; b=ZhuhNZS51Qid6NFEGP3aCECCbH7G7MJYd+jIWIhnCx7kLIgSIOQaE7xx6QmJJMX680fKY02tbY1ngauo/nayZ51pddIfoaljm7Lr0DuEcilWqjDseLjkl4ZKxcRUv0Mw9OeMb+O6WrO5aCJhw0HnSMzLI8zQRscd+x3FsYjvtlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255731; c=relaxed/simple;
	bh=JTrF5blgTB4rKjCArWc93vK0e7D6KGFGHWDlRjxCA3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rFc+z5Q7ozASZLLp73FQwkUhs5TUvIY//uA2q/SZ3+9L1pOySfZERxUDs0OCEVhgniZOIcspbGY+HrF9eBhr7eNTNE0IwECvRIoLLGv61P0+mMKIXi0hGJsn56wskhsdld/+NPa5KN0B0ibdn7duaU5ZdBmA9DMJP1aRKjhUh4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnPy6XYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnPy6XYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54ADC4CEF8;
	Thu, 27 Nov 2025 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255731;
	bh=JTrF5blgTB4rKjCArWc93vK0e7D6KGFGHWDlRjxCA3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnPy6XYF4bu3M4KpsBTCUdg1gxBC2pbKJDwvFLdyAA1KQnA3g1vBcqYgbNdtuMLjs
	 QtL1+JvYY0HrF8ypJljCcBkDa2Gdqs3oDAozJWSbYbGIUTAQBC17GKQIHJqj9B0H19
	 apaZn3pmlsfuowBAXy5qQuUgv5vc1UhQ2xgNcNh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 093/175] platform/x86: msi-wmi-platform: Fix typo in WMI GUID
Date: Thu, 27 Nov 2025 15:45:46 +0100
Message-ID: <20251127144046.358571072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 99ef21fc1c1ed..5680303ae314e 100644
--- a/Documentation/wmi/driver-development-guide.rst
+++ b/Documentation/wmi/driver-development-guide.rst
@@ -54,6 +54,7 @@ to matching WMI devices using a struct wmi_device_id table:
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



