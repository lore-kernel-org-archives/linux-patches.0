Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4B449EB6;
	Thu, 30 Jul 2026 16:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428218; cv=none; b=YrdzzZOXf5WUAo2PbiwlB5BScxCSFZOnk87zIaK9JFLqZiNcDxAqm3/ExSyhzoPqH9vEjYDdmlywXQYWkMpp5VueboENUcOT3v+jY3Ru2XJ4EVl1ngcFfTrDXYWxihSsEpjAs3fQtTSZDaxhGSlwmUUDpzwQM7MlAyHQ5mwbC4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428218; c=relaxed/simple;
	bh=GPOeNgTZDRL7h9WgT+lRR+8yM14lWmcnWsqc6yQSWL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pk+5qt/QfbCOSDU0neHE9lqKPoS9BIH7eu0Qj7J8XOIQJfye3xm4Hm2R/vbiB9H/jg81xQHG2WaMWb4LM6ZziOx3vmnN4RethQtW7rJ3hXY/ns8rC1zM63MX9xtRauTubG9jHlWoY2Jntt+uVmDGvPnYEziB42Rk44Se+1N7pP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FT/+GXt+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FT/+GXt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339C91F000E9;
	Thu, 30 Jul 2026 16:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428207;
	bh=6Q8Sp0CRatTkq178WZBl2NERGzo8wWEyn1rYpZAYwDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FT/+GXt++K23Z9RyJhX1F8RehVVArf0wQMf7Kz0Nl3LZ1gPVJyPjgdDy1uTg4lsyx
	 4sI0foHrBMVd6HlhSypRwrC0MDXDuKI6Zi+IlRIQCdqIhsAEWUGzQp+nYr07HypAhT
	 Tl9MYj31MuN0vV9KTAgIiXnU40TPf7AVXRz3udx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyndon Sanche <lsanche@lyndeno.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 441/484] platform/x86: dell-smbios: Move request functions for reuse
Date: Thu, 30 Jul 2026 16:15:38 +0200
Message-ID: <20260730141433.059446114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyndon Sanche <lsanche@lyndeno.ca>

[ Upstream commit 33245680ae565aaa114d726bf407c8ff38e75e71 ]

Move the dell_send_request and dell_fill_request symbols into smbios-base
so that they can be used in multiple modules.

Signed-off-by: Lyndon Sanche <lsanche@lyndeno.ca>
Link: https://lore.kernel.org/r/20240529174843.13226-3-lsanche@lyndeno.ca
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 6e9cab2247e5 ("platform/x86: dell-laptop: fix missing cleanups in init error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-laptop.c      |   23 -----------------------
 drivers/platform/x86/dell/dell-smbios-base.c |   25 +++++++++++++++++++++++++
 drivers/platform/x86/dell/dell-smbios.h      |    5 +++++
 3 files changed, 30 insertions(+), 23 deletions(-)

--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -353,29 +353,6 @@ static const struct dmi_system_id dell_q
 	{ }
 };
 
-static void dell_fill_request(struct calling_interface_buffer *buffer,
-			       u32 arg0, u32 arg1, u32 arg2, u32 arg3)
-{
-	memset(buffer, 0, sizeof(struct calling_interface_buffer));
-	buffer->input[0] = arg0;
-	buffer->input[1] = arg1;
-	buffer->input[2] = arg2;
-	buffer->input[3] = arg3;
-}
-
-static int dell_send_request(struct calling_interface_buffer *buffer,
-			     u16 class, u16 select)
-{
-	int ret;
-
-	buffer->cmd_class = class;
-	buffer->cmd_select = select;
-	ret = dell_smbios_call(buffer);
-	if (ret != 0)
-		return ret;
-	return dell_smbios_error(buffer->output[0]);
-}
-
 /*
  * Derived from information in smbios-wireless-ctl:
  *
--- a/drivers/platform/x86/dell/dell-smbios-base.c
+++ b/drivers/platform/x86/dell/dell-smbios-base.c
@@ -320,6 +320,31 @@ out_smbios_call:
 }
 EXPORT_SYMBOL_GPL(dell_smbios_call);
 
+void dell_fill_request(struct calling_interface_buffer *buffer,
+			       u32 arg0, u32 arg1, u32 arg2, u32 arg3)
+{
+	memset(buffer, 0, sizeof(struct calling_interface_buffer));
+	buffer->input[0] = arg0;
+	buffer->input[1] = arg1;
+	buffer->input[2] = arg2;
+	buffer->input[3] = arg3;
+}
+EXPORT_SYMBOL_GPL(dell_fill_request);
+
+int dell_send_request(struct calling_interface_buffer *buffer,
+			     u16 class, u16 select)
+{
+	int ret;
+
+	buffer->cmd_class = class;
+	buffer->cmd_select = select;
+	ret = dell_smbios_call(buffer);
+	if (ret != 0)
+		return ret;
+	return dell_smbios_error(buffer->output[0]);
+}
+EXPORT_SYMBOL_GPL(dell_send_request);
+
 struct calling_interface_token *dell_smbios_find_token(int tokenid)
 {
 	int i;
--- a/drivers/platform/x86/dell/dell-smbios.h
+++ b/drivers/platform/x86/dell/dell-smbios.h
@@ -64,6 +64,11 @@ int dell_smbios_call_filter(struct devic
 	struct calling_interface_buffer *buffer);
 int dell_smbios_call(struct calling_interface_buffer *buffer);
 
+void dell_fill_request(struct calling_interface_buffer *buffer,
+			       u32 arg0, u32 arg1, u32 arg2, u32 arg3);
+int dell_send_request(struct calling_interface_buffer *buffer,
+			     u16 class, u16 select);
+
 struct calling_interface_token *dell_smbios_find_token(int tokenid);
 
 enum dell_laptop_notifier_actions {


