Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052736;
	b=InL7KUL4fdLCLdDdzistSUnRk8EYL2fCr3QaCxcMdZojICfNy5bgPlei9khR14y91QFQ
	 kS4GMykkuYnV1M4meFcwle3KIUeb1T0ESN0CsiF1Cm9D9kK7RC9t9JLQqsTSPbof66Cbn
	 Sgfz2mrtiaeSsKCS0EO41MlGrLQKDq2vTxNiJFOrM5xlSkKrhwK2/Pj1YBzoEDAvfbSel
	 iP/And8rraRXRCVpWJVrRYaUhCyg9klVvfnwStYE1QiI1gQYP6NHuNpZM7Jmhrc8R1kJe
	 fcEvg7mrHia9Nl+ex8bSFzYO48CBH5jgjBDImv2oLgJuf0k9U5CSP3JNc5+4YvueDog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pa7aPHrbyxlFkK79cWlksCh+GnwWw9l2ZVOCd5DC4aU=;
	b=Pv1MIeuN7WnF/py7V9ZbQPAfVsNAwiNv+8mYpK0gGIQK821jWMXrPatprouHnLcjALDu
	 tq9cLpBEV6PmblddV05akN7xhH6sAb13YpdjGyQmMSE3aqR6NVW7x05r+nLtKMBAzhLXw
	 XLB5g4jhffgbUsZs2jeEVkq2kH6oWgSwoK4JSUAfoEnflV0oODl58hJPmXy9qCtK4r1nd
	 6Fgytb2YWMfuVUchQjgR8x3RzcGFTI8HUAKSyAFCvZGbVrCbOITpRBVU8Hr3LlTtmwHDm
	 g2CbAXLkT+sSuGUtuJafTAkxbU2R1Y4oSz7g9zn8RFvCFlgEGnfxoqLaUQ+Xn3vWuBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtbZmhun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A93606A325;
	Thu, 19 Nov 2026 01:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtbZmhun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35CF1F000C4;
	Thu, 19 Nov 2026 01:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052736;
	bh=pa7aPHrbyxlFkK79cWlksCh+GnwWw9l2ZVOCd5DC4aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtbZmhunqnEEGhWK+ayY0rrGoKFila967sFnAuy07sXgQqATW2i8h0yFcfS2hMtrL
	 HDfZldGfgnoi/JHhO9s0isERCHBdMVjG6UnPsEg8+TQgpqyX3UeQGyMxAWzh6CIBtd
	 l7pAjUewwCnnuBt3atyhgYfLExB+UiP57gKRrjkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0668/2214] rtc: cmos: Disable ACPI RTC event before handling it
Date: Wed, 18 Nov 2026 15:39:04 +0100
Message-ID: <20261118150038.556617005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 33642da811817..6cb6ee19a17d2 100644
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



