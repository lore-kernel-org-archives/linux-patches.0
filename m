Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831031DB34C;
	Tue, 27 May 2025 17:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366247; cv=none; b=nP+1AWqahQfS8oLGE+g9DW4jS3alKMitGO21Vs3XqTK8Rb207dHAHFv0gPtWynTLnB7ev/d53nizG046qMPR847JFzrr0l0ya3Wn0TnWugRpK9XY1hMUaDj+kt6o16qOQGvIlvqA96qU9pWZivbZ1pVIvDbpFDWmqmlo0g9cjAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366247; c=relaxed/simple;
	bh=TAJQAeuKI23WEJlzs+2DLYiPrHk9JN+YhvLBl0Cvoa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SdCJyJ56NHctvAxFWp0hUzl41PEMcL80dqhcGskU7I3YSqvOVpvMqwptGNaHqdZHm9gFf3sKweaZUJmQ3+LfCess/LDJZ8UOqh6Kq3KQL0ZBbme9nOdxrRuTbnBPH3HavWDy3eQwHwLzu3dNYVrPyUta3FzgsfvfNf48tzEk6Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzUwPPDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzUwPPDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEBEC4CEE9;
	Tue, 27 May 2025 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366247;
	bh=TAJQAeuKI23WEJlzs+2DLYiPrHk9JN+YhvLBl0Cvoa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzUwPPDkPXDCEl+MQ+q57e+y810zXNB7kbhvIT9RxQOp+zJJYapj+n6Wi0LvKxC5l
	 nqauYnCk/7y1p/gwvRZ7OwfHoUnFHQuy4b4cakTUkmB/Ac0hl4qpKKRd05PQ3epNwT
	 3gHC9xtOq2AxprQXoA5tRIRak8rkTiH8LKkBUKPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 608/626] platform/x86: think-lmi: Fix attribute name usage for non-compliant items
Date: Tue, 27 May 2025 18:28:21 +0200
Message-ID: <20250527162509.701623120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4cfb53206cb84..1abd8378f158d 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -995,8 +995,8 @@ static ssize_t current_value_store(struct kobject *kobj,
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
@@ -1026,7 +1026,7 @@ static ssize_t current_value_store(struct kobject *kobj,
 				goto out;
 		}
 
-		set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->display_name,
+		set_str = kasprintf(GFP_KERNEL, "%s,%s;", setting->name,
 				    new_setting);
 		if (!set_str) {
 			ret = -ENOMEM;
@@ -1054,11 +1054,11 @@ static ssize_t current_value_store(struct kobject *kobj,
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
@@ -1568,9 +1568,6 @@ static int tlmi_analyze(void)
 			continue;
 		}
 
-		/* It is not allowed to have '/' for file name. Convert it into '\'. */
-		strreplace(item, '/', '\\');
-
 		/* Remove the value part */
 		strreplace(item, ',', '\0');
 
@@ -1582,11 +1579,16 @@ static int tlmi_analyze(void)
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
index e1975ffebeb42..7f9632a53736f 100644
--- a/drivers/platform/x86/think-lmi.h
+++ b/drivers/platform/x86/think-lmi.h
@@ -84,6 +84,7 @@ struct tlmi_pwd_setting {
 struct tlmi_attr_setting {
 	struct kobject kobj;
 	int index;
+	char name[TLMI_SETTINGS_MAXLEN];
 	char display_name[TLMI_SETTINGS_MAXLEN];
 	char *possible_values;
 };
-- 
2.39.5



