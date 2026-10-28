Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215439;
	b=SyUmWsicEAAaEH32HHERyK32JXIg4WsOCQ1+BwbsZRkcNjhlVL5T//q4+4++ax2hBrv3
	 b5uqUMf5NbgbjWH2Od0s9O//Qq1YUm4DE97WlPqOD3JbGAv24j/z0eI1MGvNjUAiGBetV
	 JPm8XYnBYk8criR3I0aWKW3spIEYOwSy24g5ocvK2GMN7bXLQZs2HH+IEjuEtGOf8wbrV
	 bYYbYy0+Z5lHFptTc+w2y+jXSCJVwpzZZdxMkkN9ylPir3uXmsfUAN2LyaezbeLrONi/X
	 deWJgRrlDzl1xo+URWLKVjQt7sGChfEjRXQ39TgcjNgsj9+n7xGkBpbd49DvvAyiB2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AFS1mYr9+OllwXmXdeY60y433I9wfHQx73qZzWnMW48=;
	b=stGaCnVBLHaZuhGn13FdVjqH6Z74IZXwxNYCVrCYRSfxRixrTLDv/p9RewDIA1EGCUoV
	 cRYTZfWfEOhQdRz51CurcOyL3dt5I0VLkDqcX1fPL3DVzSABV8zEzyJL3P3XcrsbschQd
	 fA58HNtX3+liFJjLupBmOUj0WTsmxHInzHJnh7Hf4o1QX/dOFvyPbC5xgUMxfXTONWibT
	 bISj+7Ld+HR0FZVy2yUKaZ3lTqUItk7eiHyj1yQa18j7LGzof1VoC9lwsRyBVL+ahQ40F
	 YwO4nCQzY6oxrtgXJITA+ZLXt2+nMBRuLjk6cj6FI5GPBXxIFD66UzaNe16vTWkACEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1XqeW6s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A52606A31C;
	Wed, 28 Oct 2026 19:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1XqeW6s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84E01F01825;
	Wed, 28 Oct 2026 19:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215439;
	bh=AFS1mYr9+OllwXmXdeY60y433I9wfHQx73qZzWnMW48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1XqeW6sJKECsNMXB3h5B/W/uKDyWAPULzU3MaA859dzGqXpVZ0P/L+oUo0y6JtvN
	 Rl3mYzR2eW8nihtaaU5BJCrYrx+sORLvwQkDTU5UPBMf7wrTla30f1e+8ANkZpJ5WC
	 U1UFKFKLafVzznjSJoiiH6rSFbe3zlZGwSTo59bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyndon Sanche <lsanche@lyndeno.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1210/1887] platform/x86: dell-smbios: Move request functions for reuse
Date: Wed, 28 Oct 2026 17:55:06 +0100
Message-ID: <20261028170526.943514210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/platform/x86/dell/dell-laptop.c      | 23 ------------------
 drivers/platform/x86/dell/dell-smbios-base.c | 25 ++++++++++++++++++++
 drivers/platform/x86/dell/dell-smbios.h      |  5 ++++
 3 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-laptop.c b/drivers/platform/x86/dell/dell-laptop.c
index 215861c11dc45..14772ba16f75f 100644
--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -361,29 +361,6 @@ static const struct dmi_system_id dell_quirks[] __initconst = {
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
diff --git a/drivers/platform/x86/dell/dell-smbios-base.c b/drivers/platform/x86/dell/dell-smbios-base.c
index 9a9b9feac4166..636d881c94777 100644
--- a/drivers/platform/x86/dell/dell-smbios-base.c
+++ b/drivers/platform/x86/dell/dell-smbios-base.c
@@ -320,6 +320,31 @@ int dell_smbios_call(struct calling_interface_buffer *buffer)
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
diff --git a/drivers/platform/x86/dell/dell-smbios.h b/drivers/platform/x86/dell/dell-smbios.h
index 75fa8ea0476dc..5706fdd1318c8 100644
--- a/drivers/platform/x86/dell/dell-smbios.h
+++ b/drivers/platform/x86/dell/dell-smbios.h
@@ -62,6 +62,11 @@ int dell_smbios_call_filter(struct device *d,
 	struct calling_interface_buffer *buffer);
 int dell_smbios_call(struct calling_interface_buffer *buffer);
 
+void dell_fill_request(struct calling_interface_buffer *buffer,
+			       u32 arg0, u32 arg1, u32 arg2, u32 arg3);
+int dell_send_request(struct calling_interface_buffer *buffer,
+			     u16 class, u16 select);
+
 struct calling_interface_token *dell_smbios_find_token(int tokenid);
 
 enum dell_laptop_notifier_actions {
-- 
2.53.0



