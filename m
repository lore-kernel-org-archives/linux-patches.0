Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043868;
	b=mB2AhpWJPnAHPituQzg2JfFRGENisXhpmp69uDRBbi4XW0QcudHtFu+stJzTLMwvMUkS
	 BrbthMOfsBKpGGHzxT0Rg+/3HPlmqbY4MC2tKqNJGFlOJPiC684/mBve4T79v8d0WBHCE
	 D7uVRhyKkS7VWMhe7ZBB+Q4uywsZZDvGOvd7Nu82R0bV9zcQ5p7ETS1nGDDXmjlkppjum
	 rqtcmm5lRtJ5frBU2pr3FrSIC4fyZX8vHRhnof22x802ZR74r/seTaGq8iIgvPu8Lnh9r
	 +Bkaj3jkwmi0oN+KjYza0xpemUZKnnIZ6R/OIfP+T8wOtEPsa+GipoA9Q+pk9ass0DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jZ9HU+lxgxZ8olI82zFT5fu1cZzONX6jBLuhdwYyJwE=;
	b=N5oE5NmM2chQOHZXCc+tU42Nm3EJLf1LRNtkKk4WdKNG5oN1A0xJPNgk0R2F5JHaS0j0
	 WsqwSH0zxLMKjpRxYVR4j7onodykJ99+zYR34uNjaqbqjhuOZD7q1XAI1JvBVSh5NdiuB
	 khhKmWYe1BPfC7LfJ3SlEIowlvcXrSDzid871FhEj3pwWN4NWDoYP4SDaQUo68twysq7x
	 8yMU+PUJ0Jz/MoyB7257ORLCGHm8+JytPUkzJbWuzEQFRg2hfwjDErlH02ewX+Uuqe2Xg
	 VXFEKMWFCzg2fH8aUnEQ2O2sv9f8kVpdbFaTbj3p0wC/a6qGg5VjvFpWNLPNdTyRI5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/DWMdYE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8278606A32C;
	Wed, 18 Nov 2026 23:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/DWMdYE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E711F000C4;
	Wed, 18 Nov 2026 23:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043867;
	bh=jZ9HU+lxgxZ8olI82zFT5fu1cZzONX6jBLuhdwYyJwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/DWMdYEmy+11LYC098Xu9pvWXoeoufxSy01i/iScWxuRcQMNkv5j4BwiMhB/ZnoQ
	 kwHPlRCuYs57bnDCSrguPwuJujf635JSq7AUq6nSZX7Wve6/CEKi4wt7m6385Kf4L1
	 Uk3ols0LcJGNMsYZbasDPBXE8Uf662a+Wz4ExUhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0362/2857] platform/x86: think-lmi: Use strreplace() to replace a character by nul
Date: Wed, 18 Nov 2026 15:23:16 +0100
Message-ID: <20261118150214.468445414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6cb9c8637c672584d4915559001020237840acba ]

We can replace
	p = strchrnul(str, '$OLD');
	*p = '\0';
with
	strreplace(str, '$OLD', '\0');
that does the compatible modification without a need of the temporary variable.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230918135116.1248560-2-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 54745d563114 ("platform/x86: think-lmi: Fix current password length check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index a0338c8ec7be7..f32f960b9a5cf 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -198,14 +198,6 @@ static struct think_lmi tlmi_priv;
 static struct class *fw_attr_class;
 static DEFINE_MUTEX(tlmi_mutex);
 
-/* ------ Utility functions ------------*/
-/* Strip out CR if one is present */
-static void strip_cr(char *str)
-{
-	char *p = strchrnul(str, '\n');
-	*p = '\0';
-}
-
 /* Convert BIOS WMI error string to suitable error code */
 static int tlmi_errstr_to_err(const char *errstr)
 {
@@ -411,7 +403,7 @@ static ssize_t current_password_store(struct kobject *kobj,
 
 	strscpy(setting->password, buf, setting->maxlen);
 	/* Strip out CR if one is present, setting password won't work if it is present */
-	strip_cr(setting->password);
+	strreplace(setting->password, '\n', '\0');
 	return count;
 }
 
@@ -930,7 +922,7 @@ static ssize_t display_name_show(struct kobject *kobj, struct kobj_attribute *at
 static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
 	struct tlmi_attr_setting *setting = to_tlmi_attr_setting(kobj);
-	char *item, *value, *p;
+	char *item, *value;
 	int ret;
 
 	ret = tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID);
@@ -943,8 +935,7 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 		ret = -EINVAL;
 	else {
 		/* On Workstations remove the Options part after the value */
-		p = strchrnul(value, ';');
-		*p = '\0';
+		strreplace(value, ';', '\0');
 		ret = sysfs_emit(buf, "%s\n", value + 1);
 	}
 	kfree(item);
@@ -1451,7 +1442,6 @@ static int tlmi_analyze(void)
 	for (i = 0; i < TLMI_SETTINGS_COUNT; ++i) {
 		struct tlmi_attr_setting *setting;
 		char *item = NULL;
-		char *p;
 
 		tlmi_priv.setting[i] = NULL;
 		status = tlmi_setting(i, &item, LENOVO_BIOS_SETTING_GUID);
@@ -1468,8 +1458,7 @@ static int tlmi_analyze(void)
 		strreplace(item, '/', '\\');
 
 		/* Remove the value part */
-		p = strchrnul(item, ',');
-		*p = '\0';
+		strreplace(item, ',', '\0');
 
 		/* Create a setting entry */
 		setting = kzalloc(sizeof(*setting), GFP_KERNEL);
-- 
2.53.0



