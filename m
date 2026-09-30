Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B719314A86;
	Wed, 30 Sep 2026 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788791; cv=none; b=Udx2mWfBbmY7Tn0Kor5rizBLh5I7BBpCetYm87aY8pMTEdhQ/bSErmxvD9lrhYc6dnCBW0fNWsFiec6DqyiX7Miy8voPuSUdl24Za+MAu63V4TkPSXEPzkFJV+9NAF1hNELRbNGAh7JDqQr+9Rj1I22OzjioKvVblc1GOxxR0ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788791; c=relaxed/simple;
	bh=P2BsaLZHs0NlmIJijngyWCvlO4mNKKH+51qJulwAJG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oAJ2JTAGIPCKqnIiQKDj2kq1EQS2XVkpeplnNP7Laf3sH9D92i+fusIEYzlgdw2V6jkRdAPKsXM6vnQV1uDSveGpkwaRJPY6dogoPt574gxpFhYQH1XprBHR3kcZybtL6kG51CV+rhqisNlxpszCpNCpEdOdlsqS0Wz2W4FEOa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbyqxwpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbyqxwpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C21F000FF;
	Wed, 30 Sep 2026 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788790;
	bh=rsu6Zsb5wTjBwxgYLOhnb6ib0z3WaWEYVX55mkO3wjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbyqxwpQvNgUtDWmO0jbeRS5mkJU3HaiWxoPVTzSRG05CC13yVDn3Lr3N9FzKqQG5
	 vmGhu6tIKkTlCdx2VfpH0vybzvw7rjDvq2zqLMktRe6WHYxv5ntphcJdwBSAvnwAfS
	 zubWycFNDhQR50dJf5UaJBEMm58fvSODpP7jfRyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 247/877] hwmon: (pmbus/core) increase number of phases and add new mask
Date: Wed, 30 Sep 2026 17:19:18 +0200
Message-ID: <20260930152420.054333389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Nuno Sá <nuno.sa@analog.com>

commit 06bd6794b5fd2163880ac3bfe973d4cc61f359f3 upstream.

Increase the number of phases to 16 as a new upcoming device supports
such a number.

While at it, add a new mask for controlling the source of the output
voltage.

Note (groeck):

This patch was meant to prepare for support of MAX20826 and compatible
devices, which support more than 10 phases per page. However, Sashiko
reports that the mp2975 driver already supports up to 14 phases, and the
mp2856 driver supports up to 12 phases. This already has the potential for
out-of-bounds writes when probing the affected chips, making this patch a
bug fix.

Fixes: 2c6fcbb21149 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2975 controller")
Fixes: f9e5f289b686 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2856/mp2857 controller")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260911-hwmon-max20826-support-v2-1-5e30cbd97d84@analog.com
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -241,6 +241,7 @@ enum pmbus_regs {
 /*
  * OPERATION
  */
+#define PB_OPERATION_CONTROL_V_SRC	GENMASK(5, 4)
 #define PB_OPERATION_CONTROL_ON		BIT(7)
 
 /*
@@ -385,7 +386,7 @@ enum pmbus_sensor_classes {
 };
 
 #define PMBUS_PAGES	32	/* Per PMBus specification */
-#define PMBUS_PHASES	10	/* Maximum number of phases per page */
+#define PMBUS_PHASES	16	/* Maximum number of phases per page */
 
 /* Functionality bit mask */
 #define PMBUS_HAVE_VIN		BIT(0)


