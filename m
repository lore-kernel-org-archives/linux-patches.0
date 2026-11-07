Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062489;
	b=VMYu5l6c/4A4CbFL3S5gvVSRmAAs2GmrL8cS6As27o3Q+IzHxPFWFhIHi03Oru+a1oMd
	 mu/VAC8zb9vr1cxt9sJPv8822Oc7/MEpjY2uV30LHLJdI9z7Nf/3XdR3ROFehwm5T0Dd5
	 5rAGkiVBHFacVSL2KmfWMKbw7lkALr/x8ATXLMQij2JqRuXbXBqlmGcYLfQqHlCD+QJyq
	 rR7s+qxsqemOEIlFE8TWlM8floHjAavs4hgdjInlrhcSGyY6KJB9GSKDRLzc63Rn6Xxft
	 UrigiMhzLKcR2nt2fKiKV/54M+RpyKYqTfG0FG5wpbk9q+AMb/lNbwQZj22fc5Ucx9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PnJnQkv0ISH0RMEZEDRbEHCGnXekg0GZmZjAvmSQbc4=;
	b=w+iMDWtcfMFE5P5kL0oThpPFScoiZkzo/BdUY4KRmC512XO4FiZ5AKhFZqUYHtgvS9l5
	 NhPZRo6ml9/noxWveOBqX5ge6o85sto4QqYY3WR1cO4cn/V7WNDAlX7OwYmWD+JiHCDRY
	 fulU+s7/jLln1OQqt05fkCHHkgeUGQ3DlNB514NdVxOj53KeHvBo6khkR3Tb9PjRhYur0
	 4vCk7z/4Kmk5Yz9gTsWYgXDnh8cwYF7HFWD3tx8q5YPjBuVCNNNZesRWMneVRAjyfqbd8
	 mCNKsfr5u5e4IrJtiizFDc5alqwgG4XDqlDP9z5WC0CLFAuOFYme4wtXLr9xia0u9Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DO3pfSAy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061E9606EEBE;
	Sat,  7 Nov 2026 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DO3pfSAy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A939D1F0089F;
	Sat,  7 Nov 2026 14:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062488;
	bh=PnJnQkv0ISH0RMEZEDRbEHCGnXekg0GZmZjAvmSQbc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DO3pfSAyU6BOLZ1hc5XvrNdPSl6ptpqRBeC+xCnv2j66oQ+vnOvvYZVPNHY6XEaQh
	 qMzVpDGQVluv/N2OhG0nZEjAH2SmFuHxCOOPmytNNA/bZ/neiO4YswcWD+ZHddzXzO
	 4jilONuhKfdClI9QtVjCH8v3McYPsTd+tMYrcU60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1362/1536] rtc: cmos: Disable ACPI RTC event before handling it
Date: Sat,  7 Nov 2026 08:56:18 -0500
Message-ID: <20261107135036.088450697@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 3f67038df8b5cba07254d1cff60d73e988b49ab7 ]

Users of RTC_UIE_ON can stop receiving update interrupts when rtc-cmos
handles alarms through ACPI. In one 50-run test, 40 runs passed and 10
timed out after receiving between one and four of five expected events.

The ACPI ff_rt_clk counter stopped at 218, exactly matching the number
of events delivered to userspace, and reported:

    218     STS disabled     unmasked

rtc_handler() runs in the threaded ACPI SCI handler and calls
cmos_interrupt(), which schedules rtc->irqwork. The work can run before
rtc_handler() returns:

    ACPI SCI thread          rtc->irqwork

    cmos_interrupt()
      schedule_work()
                             __rtc_set_alarm()
                               rtc_wake_on()
    acpi_clear_event()
    acpi_disable_event()

The SCI thread then disables the event that the worker enabled for the
next alarm. That alarm sets its status while delivery remains disabled,
so no update interrupt reaches userspace.

Clear and disable the current ACPI RTC event before cmos_interrupt()
schedules the work. The worker can then enable the next event without
the handler undoing it. With this ordering, 150 runs delivered all 750
events without a stall.

Fixes: 311ee9c151ad ("rtc: cmos: allow using ACPI for RTC alarm instead of HPET")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261015173029.3091872-2-gourry@gourry.net
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 79ef0d8164788..2834c08c6e25a 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -757,7 +757,9 @@ static u32 rtc_handler(void *context)
 	unsigned char rtc_intr;
 	unsigned long flags;
 
-
+	/* Quiesce this event before rtc->irqwork can arm the next one. */
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	/*
 	 * Always update rtc irq when ACPI is used as RTC Alarm.
 	 * Or else, ACPI SCI is enabled during suspend/resume only,
@@ -780,8 +782,6 @@ static u32 rtc_handler(void *context)
 	}
 
 	pm_wakeup_hard_event(dev);
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-- 
2.53.0



