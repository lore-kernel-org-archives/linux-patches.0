Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829571;
	b=RMiDKob4At5xweWRajJvMxoHw7MdUvqLwsl0Ivxl2Q+SkDe5Mzxk9IoFo8g6HFDFxuMq
	 0H6LupL3DB5EJ6DfQiiD4z4Zw7GPnyFrRMV3j1t2LbfGWGAFI49HKOblWu8NPGM1wR0CD
	 MlII5+SaMY4rC4anXRz2TMSM7CQXpvS0+pcR4J2Z2PBtBfyWsF+A38LpewiWoedq/0OBa
	 6LER2lUXGudN3AA90myN9PIeOaxxwRYS1AbTt21RRgFmN5C8tZr82+fouMDjYFYmk93mX
	 CCFw2UBO75+sHWyF8dz/VXcnOoTOyfL7+AmdSd4STFkH1wvZPcKFbsqI+hR7oFxZOuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KgDhlAvhMXZkVYdt75gZ2sPCRfGSAnm4Hf9/oB53Jr0=;
	b=WM8/J1dq0irr70wMJ69XsOMsSzZkO3ZnDPdsC8bSherTJvkIY9TTsttGtQiK0Ri+vI7F
	 odf2ceDZ5shhD6NrbGDAg03akoCeDZ3xu71DmoN7LoZ53Qd7I3/v1QAWcSKbtsNepb+0R
	 H7jDS62p7CQCgDHZoj8GG9Qa/L9oXX5Jfo4h/wUJJVD4mXT/IXCvVy9mNNm8GZwjxArma
	 jcDlg/IiscDIoQGMfYtoMMf7GSAy5q6j+PtdfXWRMhi2kVKkXJy3yjZqtLKBg/IHbjqEP
	 kTWuNqDbNOMEnTgqFfiL3XIWg/mojARe4QhR9zotboHsfSHOS+JfSFYSa+KJDa0N9pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsJAXoO0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE5F606A33E;
	Wed,  4 Nov 2026 21:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsJAXoO0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A42D1F00A18;
	Wed,  4 Nov 2026 21:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829570;
	bh=KgDhlAvhMXZkVYdt75gZ2sPCRfGSAnm4Hf9/oB53Jr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsJAXoO08f9FfL05UKIFJdgu+hvXNscCHhPC8kl5Od0woyTfpYL1l9baZR+w3sDf4
	 9W8nJnGstxasdAU4c+epEFrvsIrfer3ag+XYDgJbCk0EM5HHnXYOcewJBMVeW1q+Nd
	 SmsQkRpwaC7xLBJi8oE9imVi5GJA8w6Tc8TJGT/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kate Hsuan <hpa@redhat.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0208/1005] ACPI: battery: Sanitise model_number by dropping unprintable characters
Date: Wed,  4 Nov 2026 15:59:01 -0500
Message-ID: <20261104211049.630881355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kate Hsuan <hpa@redhat.com>

[ Upstream commit 6587dd87595cfae6bf1304cd0cd1df2274424e42 ]

The battery Embedded Controller (EC) may return the model name with
trailing unprintable or non-ASCII characters. For example, on some
systems:

$ cat /sys/class/power_supply/BAT0/model_name
LNV-5B10W51864��

If a non-ASCII or an unprintable character is found, it will be
replaced with '\0' to ensure the model_number is a valid string.

If left intact, the malformed string prevents udev rules and hwdb
working correctly.

Link: https://gitlab.freedesktop.org/upower/upower/-/work_items/345
Signed-off-by: Kate Hsuan <hpa@redhat.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260710125122.1621877-1-hpa@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 296c2981b1a73..0b922aceb28d1 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "ACPI: battery: " fmt
 
+#include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/jiffies.h>
@@ -486,6 +487,15 @@ static int acpi_battery_get_status(struct acpi_battery *battery)
 	return 0;
 }
 
+static void acpi_battery_clean_unprintable_chars(char *str, size_t length)
+{
+	for (unsigned int i = 0; i < length; i++) {
+		if (!isascii(str[i]) || !isprint(str[i])) {
+			str[i] = '\0';
+			break;
+		}
+	}
+}
 
 static int extract_battery_info(const int use_bix,
 			 struct acpi_battery *battery,
@@ -527,6 +537,10 @@ static int extract_battery_info(const int use_bix,
 	    battery->capacity_now > battery->full_charge_capacity)
 		battery->capacity_now = battery->full_charge_capacity;
 
+	if (!result)
+		acpi_battery_clean_unprintable_chars(battery->model_number,
+					ARRAY_SIZE(battery->model_number));
+
 	return result;
 }
 
-- 
2.53.0



