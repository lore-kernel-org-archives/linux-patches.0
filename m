Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060813;
	b=ueDzEIXQXOHrMf30dTEBwTRDa/Gu1UUTMxTKBF7cG+hhJ7nEWUy8RjzSkOMCW/GLONjo
	 mDwo6fVipBqUfVj7RbbvzPHVhKcZoVB4GYkKhy9kr62kmTr1UlYpE2OwOEBfhaxU4sRFg
	 N2eiyNE2w0VWZ93IzlKTp9ARq5EsHeMzJgh51goDaQPbBnvvpJhXIHBRnc6DEiBrHJXtH
	 btcSgZZ1IrooMXvzXsmJtS7b7h2alwneI9IK2jpPOfoxHYcRXv2eQZ4l5mJXd5FmwQxGx
	 nRQmfK0U6Ry2xpbsduVkXIOy+bKnjV+wnj+2N8q0LCEAuAhULfGlDVl03c4lHqJDovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2UEpLgrlxBzU7VZLrF8dhcf1AE22pUowj9bjwNJQBHc=;
	b=lYmkRgQJO7edB6jWA0Xbw2kbxyDatEFI8IVk6LhbQWswtXlkAIaEPLslBFRqYeH0Ehsc
	 NpdRKNbBV/E3wIZWgys/0li82Jv6NyqqZOK2IeCjP0eW/EG0aCiOKoklEQNhQdDmY+nK7
	 ixP0SI2AZaNxSz7Eunlt1ZLqYeR4neKbRiHdZy0myvqB2iacxR7ziolI1F3ghX2chylg+
	 14D3ZDrQZwqWzdk/jaS2ouzuCCB8JIHZw6p9Olumctqgh/GXbCteQHVMix/NeYYuwFysL
	 c+dd5NzISj+ter0H1/QvpLZFB33GCycIt23GTQi2OoNXDRCd9PS/CjGqJB6HzBy5qQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sxX/jQvg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3238B606A326;
	Sat,  7 Nov 2026 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxX/jQvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5BA1F0089F;
	Sat,  7 Nov 2026 14:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060813;
	bh=2UEpLgrlxBzU7VZLrF8dhcf1AE22pUowj9bjwNJQBHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxX/jQvg2AuLtYVyvz5zEUTIhRtO97GZHB24RChvbNsQFZYfSqlMGw/T0aAy34pfN
	 KQ/o7jRGRZbFvPbFvbUg6OVfX5ODe1iHYgY+OYKsnKwAAt1yICx1yOsslSqWGs7IxM
	 3QmJznomKCHa1gId/Wyl2iZdHoRNSW+XCPb/CDpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kate Hsuan <hpa@redhat.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0172/1536] ACPI: battery: Sanitise model_number by dropping unprintable characters
Date: Sat,  7 Nov 2026 08:36:28 -0500
Message-ID: <20261107135002.491454083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c69970ba1843f..236944e1f0a0f 100644
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



