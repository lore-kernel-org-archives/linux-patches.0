Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058596;
	b=Pr4bO+Jpgz9mdt3Ni2D9Vm/Nu4QlEIQD2rcP86/tl8SVByW9MvvYOoFS1zgzCc0xBIdO
	 9jf/GxtJcKapvX49Fq7EO7ZIQrvWvqnyKGtjAt3hjGaYNlAuGiRgVUBiHL13WrU4pLHL+
	 jtk+RR67sxMgPaO5DZ4sQlu7WfAB8CcmmAk2O8sabAowSFkO098QI9MqX8xkGwcg0Pus4
	 0LZt6vb+zk/QMHD52BU8o8dykJ1ohYQS89ceOPamYE/oQl9e5B/ebpNzxzCN1KF3Io8L7
	 T+0skFyAZX51/XpXAAc74mMknZ9xtCr0w9gf6D+GjapbhbY6AuF1OanWR4hr23BoO0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aha9ghAuWwncoHj5laOztlhVC9/cqsV9HgnDxNc9qtw=;
	b=y78c+rAPG+uFCpoKj2fhiilGom3h0G4c4T+HPhgxGP2SIJf+2N9EtQn+NNgUHYhqttZg
	 uIOJky+y68zMan7tuco+z4j5YLLL1Ao2vxjHHblcNLWqczeb3sEajhxXgT1xQQLUc8aDA
	 aqpaY+iBng4917g8Gg1MHfp21SAqy9ZickVMw6GNJa4IbRUQkH6m1unJNAXfVN4y3W7iW
	 NCjxmIDcd3r6WWSF8qrq6/55lIboppOsmT5PbdIKBchQ/Hmt88aUWIEIoQtbSSPKzqNCs
	 yGlosCKitlA5W9acmc6fBTdMOgehbIzOb5xkCaU+i1qqPfAJKt9wmLCjCX/bPEFVsPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybL1a1jm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CD5606A334;
	Thu, 19 Nov 2026 03:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ybL1a1jm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9F11F000C4;
	Thu, 19 Nov 2026 03:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058596;
	bh=Aha9ghAuWwncoHj5laOztlhVC9/cqsV9HgnDxNc9qtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ybL1a1jm9yO8Pf55Owc8PYinn3bNXv7ZqkhhJH9Ryb+hLLwioKDt/qn5Pm8ixfpKP
	 IKUVZ35ovmkudP0OwifqfWMXrOpwsuRWgXZIj13ybC+X4UKi71liI2Ev3IHJ/bkuDc
	 whZtPZTrN0AVaPau0fdGmG84tlZQ4I58L9ehApLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0543/1848] rtc: cmos: Disable ACPI RTC event before handling it
Date: Wed, 18 Nov 2026 15:43:01 +0100
Message-ID: <20261118145937.705107841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5c0df138ca2c1..d0927b6414dba 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -764,7 +764,9 @@ static u32 rtc_handler(void *context)
 	unsigned char rtc_intr;
 	unsigned long flags;
 
-
+	/* Quiesce this event before rtc->irqwork can arm the next one. */
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	/*
 	 * Always update rtc irq when ACPI is used as RTC Alarm.
 	 * Or else, ACPI SCI is enabled during suspend/resume only,
@@ -787,8 +789,6 @@ static u32 rtc_handler(void *context)
 	}
 
 	pm_wakeup_hard_event(dev);
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-- 
2.53.0



