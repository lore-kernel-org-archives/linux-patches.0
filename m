Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065027;
	b=ZqKSJTQ4j1OCZFIuYl2zRSaeXhR/Yt8fhidu5QgxGo6qvCX5J/xYisfmYaESj0rHibK8
	 1i7EK4pn0+ZMn5y32yaiStNvdoRwbXDOGSzaRihBixlx1f5YXbxy5mxxCdDElmAO4/xIr
	 OD67D6rydSD0+oF+jhmKku1QiJcjw2CJyh8jhOjxE9iH9gjXKjLxhaPVm2qyjsykZ4bCF
	 7tjYWj/PctwS+fonuD3ZvuqhW2w0P6yTna8nag5lz3ajDJdbssPRXkF6biisxVkXa0m/q
	 SUxChOg01GDZ2DmOTAWcdsPaQeF2pD23LmFUpGGmHW0kxFXxIme0O+LPLuEtcMVGsOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IRUDZiRVzqn7C11MtvDw3q9Emw8R9cikvQz0jD4r1G4=;
	b=O0mPi/JWJDVOs0HLqx/JixLuph4Kw+fFSsMN0t89RdjJF7EgoTR5UsV9zVTnrIn3HBVg
	 kycLiASOM0aIzcXXmd/kT1sahs3SQ4g+LIOXdOi4RvBfvIaAXxLmr2sA/HJrbXln4I2dC
	 EQZXVcoVFRsDZiok2VIx/XU16GF9ukwZRIdbgD3RRP2ej7EqcUXsPKsSeeQmm4xOPbXoh
	 KYdYNW3wWD6svkZw3sx8EWPNi176NRPVZonCjc0SldS3R7yoPNIrL+Ftic0UrUUbpCo/1
	 QZmT0+2dHXrJWB4+BwZgOUHmvJtMSqKrkJVojsjIRLWLQMGS9RR780+c/Oq+LnuAzyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+RFpJ1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E825A606A9E7;
	Sat,  7 Nov 2026 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j+RFpJ1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FF41F0089F;
	Sat,  7 Nov 2026 15:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065026;
	bh=IRUDZiRVzqn7C11MtvDw3q9Emw8R9cikvQz0jD4r1G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+RFpJ1u+MERMSOsM6SVpu/MXs5QzcxU5GisnUStQjecBxvnZECmRkihri7RIh2ZG
	 kc+g9FwRBSBjItTJ61FK4tjMpXzAbO0vg8paSA2/1lPxBT1Jop2cXWr3Ux3V1qPjqa
	 NgJPvgN1U6hOIngJq6s7xX7qHfnmM1sMC8XmqpiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0886/1257] rtc: cmos: Disable ACPI RTC event before handling it
Date: Sat,  7 Nov 2026 08:53:02 -0500
Message-ID: <20261107135003.790287693@linuxfoundation.org>
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
index fa04ece151b8b..fe514b1aa3433 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -758,7 +758,9 @@ static u32 rtc_handler(void *context)
 	unsigned char rtc_intr;
 	unsigned long flags;
 
-
+	/* Quiesce this event before rtc->irqwork can arm the next one. */
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	/*
 	 * Always update rtc irq when ACPI is used as RTC Alarm.
 	 * Or else, ACPI SCI is enabled during suspend/resume only,
@@ -781,8 +783,6 @@ static u32 rtc_handler(void *context)
 	}
 
 	pm_wakeup_hard_event(dev);
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-- 
2.53.0



