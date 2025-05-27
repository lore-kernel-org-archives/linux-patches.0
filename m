Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EC627FB10;
	Tue, 27 May 2025 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368640; cv=none; b=PGZPUqgr/hROy3yCfah/x0iis3cIm2sYGwDLvzGYQO8mGRugyexsZTxmjkjMsFT4+o4CaCKqq+T+q3vZ0hF55PaRA0pROr2eDYYuJY3o3R/nBoddMbs0WLGW5qYOnE2qkgdqkGjzlGihn2rYuJUBNtJpXDZAHbQvjaqHVVRce+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368640; c=relaxed/simple;
	bh=67iyEWe2vTqMDZFQd1OxoShNear1oIII/RtzNN0O8fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDZENe5k+nm6N0gogPjeRCY4FGjJY0E11XaQYFu3lcgIEu2FGMioHC43BTVoc0UoIXoPc3UgEGl2Nfq8QkR++HFcaGaVdYreMvwbRFViQlxU2znxeuNGkxlLzhsGAERgcLIWx5sIWAl5HxDhMFUjDd8BthKAXz8RbA6mX9TNwyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3id+vGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3id+vGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DB1C4CEE9;
	Tue, 27 May 2025 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368640;
	bh=67iyEWe2vTqMDZFQd1OxoShNear1oIII/RtzNN0O8fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3id+vGWqmLO10uQBlXCI3TjjugRT1SydULymkjDfQndk7NfwPzGXHxAl+Ryqxi/B
	 Rw5JJXQJhYnaShLTjNrwfaUGUs3G9KcZz427dbHWOFAp3k0x7uHsAOqip/DL18c+Q6
	 udCMHfAHRl5+I8zyGADWOAiKQh/DhF5Ydmr+Ns4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 770/783] platform/x86: think-lmi: Fix attribute name usage for non-compliant items
Date: Tue, 27 May 2025 18:29:27 +0200
Message-ID: <20250527162544.493607898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 8508427a6e21c1ef01ae4c9f4e2675fc99deb949 ]

A few, quite rare, WMI attributes have names that are not compatible with
filenames, e.g. "Intel VT for Directed I/O (VT-d)".
For these cases the '/' gets replaced with '\' for display, but doesn't
get switched again when doing the WMI access.

Fix this by keeping the original attribute name and using that for sending
commands to the BIOS

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250520005027.3840705-1-mpearson-lenovo@squebb.ca
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 26 ++++++++++++++------------
 drivers/platform/x86/think-lmi.h |  1 +
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 323316ac6783a..e4b3b20d03f32 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1065,8 +1065,8 @@ static ssize_t current_value_store(struct kobject *kobj,
 			ret = -EINVAL;
 			goto out;
 		}
-		set_str = kasprintf(GFP_KERNEL, "%s,%s,%s", setting->display_name,
-					new_setting, tlmi_priv.pwd_admin->signature);
+		set_str = kasprintf(GFP_KERNEL, "%s,%s,%s", setting->name,
+				    new_setting, tlmi_priv.pwd_admin->signature);
 		if (!set_str) {
 			ret = -ENOMEM;
 			goto out;
@@ -1096,7 +1096,7 @@ static ssize_t current_value_store(struct kobject *kobj,
 				goto out;
 		}
 
-		set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->display_name,
+		set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->name,
 				    new_setting);
 		if (!set_str) {
 			ret = -ENOMEM;
@@ -1124,11 +1124,11 @@ static ssize_t current_value_store(struct kobject *kobj,
 		}
 
 		if (auth_str)
-			set_str = kasprintf(GFP_KERNEL, "%s,%s,%s", setting->display_name,
-					new_setting, auth_str);
+			set_str = kasprintf(GFP_KERNEL, "%s,%s,%s", setting->name,
+					    new_setting, auth_str);
 		else
-			set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->display_name,
-					new_setting);
+			set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->name,
+					    new_setting);
 		if (!set_str) {
 			ret = -ENOMEM;
 			goto out;
@@ -1633,9 +1633,6 @@ static int tlmi_analyze(void)
 			continue;
 		}
 
-		/* It is not allowed to have '/' for file name. Convert it into '\'. */
-		strreplace(item, '/', '\\');
-
 		/* Remove the value part */
 		strreplace(item, ',', '\0');
 
@@ -1647,11 +1644,16 @@ static int tlmi_analyze(void)
 			goto fail_clear_attr;
 		}
 		setting->index = i;
+
+		strscpy(setting->name, item);
+		/* It is not allowed to have '/' for file name. Convert it into '\'. */
+		strreplace(item, '/', '\\');
 		strscpy(setting->display_name, item);
+
 		/* If BIOS selections supported, load those */
 		if (tlmi_priv.can_get_bios_selections) {
-			ret = tlmi_get_bios_selections(setting->display_name,
-					&setting->possible_values);
+			ret = tlmi_get_bios_selections(setting->name,
+						       &setting->possible_values);
 			if (ret || !setting->possible_values)
 				pr_info("Error retrieving possible values for %d : %s\n",
 						i, setting->display_name);
diff --git a/drivers/platform/x86/think-lmi.h b/drivers/platform/x86/think-lmi.h
index f267d8b46957e..95a3d935edaaf 100644
--- a/drivers/platform/x86/think-lmi.h
+++ b/drivers/platform/x86/think-lmi.h
@@ -88,6 +88,7 @@ struct tlmi_pwd_setting {
 struct tlmi_attr_setting {
 	struct kobject kobj;
 	int index;
+	char name[TLMI_SETTINGS_MAXLEN];
 	char display_name[TLMI_SETTINGS_MAXLEN];
 	char *possible_values;
 };
-- 
2.39.5



