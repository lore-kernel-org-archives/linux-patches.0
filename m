Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063504;
	b=UFG/bBZuvbkYj7PoNlFrPCZqKAxdcm7CqeyCwkM1fGlB4HLewy9KT3bxJHJoDsD08DxO
	 SqQcpLYkOOkMavXrXISHSWYhvToNkvh763Yqw9iuwe5NUR1vB9BFVz3Gb83aoobqTzIlo
	 XKV81rSJ1FYZhMGf3MgNqGNpNJmodUgaHq85T21QOpk3g7SAeutSGkZL5DAl7Pkoa9Ete
	 s9iny0pO+tplZ/7CUfVhdo6YkCp5V1lc8Gilz0ndV6A4HIz1z/CNhl9ezZMex/JSmbOM0
	 9HdyDRlrEmMEfyjgnHmoL9pMNFElKuVKWhm125Mn/5ckk2hrKbvLZKJOuU6dE+dgdhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R6a5SdnDnrvheCh7WwlCMebbyuys8CLBnW01yFftzmE=;
	b=wfy9RjDT0kVMr90r45D5siyH9XbzCCx+fiiH6haqBdqBycK61GtndgFozKAAxokg9umJ
	 WrAAX9IM85bMf8rNsbzBe1+RnTEN8JPbOBfCBHBELIMlMcUAYJKKmgvlqXrk713fkNZbQ
	 jN9Vz11lhARt1Ek2Crp3Po0XNpigeDp75KnhOeR/i1hk6NZ80goJfzPLsWu2IdY7VUM1G
	 rgleet4jcrdI3UzlEV+UkwiL6RgtcBCCKl0FjIhHKegRPAeXTNt1ff0/f8h3E61UnGwHg
	 zeEyke3xTygHi1+ZgsSgVf1lMErzQt+dRbxEA8iydY5y0tLaoAN0zNq6SteUKCFTwWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gx2hOK/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0F9606A338;
	Sat,  7 Nov 2026 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gx2hOK/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CA01F008A6;
	Sat,  7 Nov 2026 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063504;
	bh=R6a5SdnDnrvheCh7WwlCMebbyuys8CLBnW01yFftzmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gx2hOK/gj/59IjTc/CoC6R7dUhXSoORu6T2o6/6Yc8V9b6ajiGGAZ3YLvf7cl6gYG
	 bp92weopkYZPzaMyEEvvpe8/mEaKHgdlsQjqNbV50zY93cEq3SH6YtSBf7SwqLHSGV
	 oOl6nvl8pU/eSZFDr3iavFX7R0YG+kc8+yoeiPNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 649/869] rtc: cmos: Disable ACPI RTC event before handling it
Date: Sat,  7 Nov 2026 08:55:31 -0500
Message-ID: <20261107134915.010960675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b537f40654b72..9dfa1f4ef7ff6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -753,7 +753,9 @@ static u32 rtc_handler(void *context)
 	unsigned char rtc_intr;
 	unsigned long flags;
 
-
+	/* Quiesce this event before rtc->irqwork can arm the next one. */
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	/*
 	 * Always update rtc irq when ACPI is used as RTC Alarm.
 	 * Or else, ACPI SCI is enabled during suspend/resume only,
@@ -776,8 +778,6 @@ static u32 rtc_handler(void *context)
 	}
 
 	pm_wakeup_hard_event(dev);
-	acpi_clear_event(ACPI_EVENT_RTC);
-	acpi_disable_event(ACPI_EVENT_RTC, 0);
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-- 
2.53.0



