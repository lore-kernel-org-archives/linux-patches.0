Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065028;
	b=SGU8zuQlR79If2KdUQlbCl/MijaelGXS9Cn9xifean8MdXQvZdXCsLyr7IUWMBl6YRn7
	 jhBffWA8hiiRuOwAsUk2Voadh/oThEJPMERQd/OSJaHv2QS1ltF68IOeuK9Nwa8xxl8Ww
	 No3GxliXnRKpw2/Zha11PlqyyF75vNnekyHhJU1GfZLsjmZWmojXUru43FvkMSaI+pkQq
	 /4F0s/1VagrxDHJHvbUM1aHgTQxEI0sj53EiztU2vDP1urQ8riwv6wrYiMcOIlX9VXDVs
	 ezgby0GICmC+DUyL6rDYfaMF60m9hdBK1gf7WUnGNjt54RZLoZeOflO0dcQ9CC7HH8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OCjIk8O+u46JtAEzpuKelUKn6WEZxsubJtZFOVM6tEs=;
	b=UbtzCRTJ+bOXfPuMPBMvecfaSDCDfGZGCvAUMJbNl6FkTvaE1QolQKRfSYgqlbKAkoRa
	 u+QrwZC5QB9N9/xtUIMBEEUKNlOpJdmpYu6ggMMzS/JOn8h/pMYC7BDEJx59A3PghBb+m
	 O8JOO+5x4R2H2PMkQ23Eif5qDxvyAdspuud2SjtvxEd3v76fDpKSoFA50j4YBf7Z24SnA
	 mERvq2l1hHVmFVcVYLxM1JBJjIYZGqg6IQe8Z6F62djIRfUc55SRte8gn5wdkKJ0PaY8J
	 00YhpAYZkV5sPq3q1jeeblPNn3Lx1aSOEoLh+TlHlcVw1xZ1nZRr2emDDKHLmrG+Tvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUkwMthb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26148606A336;
	Sat,  7 Nov 2026 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUkwMthb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ADC1F0089F;
	Sat,  7 Nov 2026 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065028;
	bh=OCjIk8O+u46JtAEzpuKelUKn6WEZxsubJtZFOVM6tEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUkwMthbFZ15Mjgk/aspS4Ff0wfRqRCiL8RTAdL7HceA15WaUjvP77khTKLnxlJDj
	 3zq57DU3Dc2YICZ6+lud3xi1Med/FRehSbz80hX5UhktfEjfHCi98rP54+zcBBINQ5
	 97oMaZ7DK8vAJsdaaY89Zgum5Wrv4nDjgQRQSkKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0887/1257] rtc: cmos: Honor explicit use_acpi_alarm parameter value
Date: Sat,  7 Nov 2026 08:53:03 -0500
Message-ID: <20261107135003.819494186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 3c7acb209e1d630b734a2ec72bd988f5da2ac55c ]

An explicit rtc_cmos.use_acpi_alarm=0 command-line argument is ignored
on systems where use_acpi_alarm_quirks() enables ACPI RTC alarms. The
argument appears in /proc/cmdline, but the read-only parameter reports Y.

The boolean parameter defaults to false, so the driver cannot distinguish
an omitted argument from an explicit false value. Use a custom setter to
record whether parsing occurred and skip automatic selection when it did.
Preserve the bool parameter type metadata. Automatic selection remains
unchanged when the parameter is omitted.

On the affected system, the explicit false value reports N after this
change. The HPET-emulated path completed 100 test runs without a failure
while the ACPI RTC event counter remained at zero.

Fixes: 36d91a4d401c ("rtc: cmos: introduce quirks to enable use_acpi_alarm mode")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261015173029.3091872-3-gourry@gourry.net
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index fe514b1aa3433..209aa4ec732c8 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -57,7 +57,28 @@
  */
 
 static bool use_acpi_alarm;
-module_param(use_acpi_alarm, bool, 0444);
+static bool use_acpi_alarm_explicit;
+
+static int set_use_acpi_alarm(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+
+	ret = param_set_bool(val, kp);
+	if (!ret)
+		use_acpi_alarm_explicit = true;
+
+	return ret;
+}
+
+static const struct kernel_param_ops use_acpi_alarm_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = set_use_acpi_alarm,
+	.get = param_get_bool,
+};
+
+param_check_bool(use_acpi_alarm, &use_acpi_alarm);
+module_param_cb(use_acpi_alarm, &use_acpi_alarm_ops, &use_acpi_alarm, 0444);
+__MODULE_PARM_TYPE(use_acpi_alarm, "bool");
 
 static inline int cmos_use_acpi_alarm(void)
 {
@@ -822,6 +843,9 @@ static void rtc_wake_off(struct device *dev)
 #ifdef CONFIG_X86
 static void use_acpi_alarm_quirks(void)
 {
+	if (use_acpi_alarm_explicit)
+		return;
+
 	if (acpi_gbl_FADT.flags & ACPI_FADT_FIXED_RTC)
 		return;
 
-- 
2.53.0



