Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625731;
	b=Oy77O8ljFwQ9FPp/KiBwLLImoOW9Rp8+w/PAYRA/jDmdTwDZLue5hUd5Q3HM6Vi5KIA1
	 bvCp2M4v5QoBndQByFLwyWCIeQs2LO8DjSHdgCbl3fowMRJKjZxLTwQ+Wwlqsjz70/otr
	 qHfehjS9t85X1oc0OFYD83Vr1OIFep5V9bIaMVfW9jw7vQBVRFcbOU6L/vMR6jpH7MeR9
	 XcDrNOgc/5Xw4UHJYnYa2OHBaIsIE2kgiN1BBdoQKEbl8H1WO/dUM+7cIIXYitJ2GV8rG
	 9DVJLu0qpmCKUljQlswWJs8UcN0fhvYt6/4TU/kobh5GQYTKioQoxG5OCQUTB6Mdp/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b5z6Ae6JmYFwRMd0hfoaNqUl9X0GADOfIDdd0UOAkKc=;
	b=WMlGoQxbBZ68ngNW5wYPqNusfBvJKQIS2e6GnIXhszLQ3zbcMDejDu8rfQAMxRdDPRSR
	 eO/00PDPzZa777QvxYrKk2XTj4IbiUG4s/NqAvFzLHp6SDt9SRgUMyHDeU1+ZLY7egMGJ
	 TAAWjTdzGeNoCLT8Lf0ZW1ETvuxK8JmtxtXrnsr1MiGKnTTXhWA4pkRD+LO4r2+DxUP3U
	 3TycezFD7RKMWVOC8rOYULAdnhbfd4Bh1lfF0wWgWsUfLwaMLG426K5RdkT8SlK6jCiZn
	 ZHK/qmImq8p4/Emx2/3/5So+4wORriMk7IGoVZx6B+c7nD6d+GAavIJggTS/pcf6lFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kHGgcvLE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADD9606A31E;
	Wed, 25 Nov 2026 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kHGgcvLE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1370A1F000C0;
	Wed, 25 Nov 2026 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625730;
	bh=b5z6Ae6JmYFwRMd0hfoaNqUl9X0GADOfIDdd0UOAkKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHGgcvLEQLUAI6ixtSpcECP/cbHQMUdTxte/klrw47d+sCY2oeRMPBCkdPQCAJq20
	 Jh+tXxvbb4mpkTZH8zOvuFdy3CW6rfZfgfinkeR/wLdSa1fyw6X4iD6rdPqmX2Vdeh
	 /iTN2e0H2w0s7gqsIlFrWwDiKJZUmhgY0b4acyiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 559/816] mmc: meson-gx: report busy from DAT0 alone
Date: Wed, 25 Nov 2026 15:35:07 +0100
Message-ID: <20261125143902.123846706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

commit 318fdb75f4dc9d18ae621b9fb25eb11160c95649 upstream.

meson_mmc_card_busy() reports busy only while DAT0..3 are all low. A
busy card drives DAT0 low and leaves DAT1..3 to the pull-ups, and the
callback is defined as "Check if the card is pulling dat[0] low". So a
busy card is reported free, and the core, which prefers card_busy over
CMD13 in mmc_busy_cb(), stops polling after CMD6 and erase at once. The
controller hides this on R1b commands, where it waits for busy itself.
Once max_busy_timeout is reported, the core sends the longer waits, the
120 s BKOPS and 240 s sanitize switches among them, as R1 and has only
the polling left.

Look at DAT0 only, as sdhci_card_busy() does. The checks around the
voltage switch in mmc_set_uhs_voltage() still hold: the card drives
DAT0..3 low together after CMD11 and keeps them low together on
failure.

Fixes: 186cd8b7f586 ("mmc: meson-gx: implement card_busy callback")
Cc: stable@vger.kernel.org
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -1079,8 +1079,8 @@ static int meson_mmc_card_busy(struct mm
 
 	regval = readl(host->regs + SD_EMMC_STATUS);
 
-	/* We are only interrested in lines 0 to 3, so mask the other ones */
-	return !(FIELD_GET(STATUS_DATI, regval) & 0xf);
+	/* The card signals busy on DAT0 alone. */
+	return !(FIELD_GET(STATUS_DATI, regval) & BIT(0));
 }
 
 static int meson_mmc_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)


