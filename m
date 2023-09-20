Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259CA15AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A112BC433C9;
	Wed, 20 Sep 2023 12:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213466;
	bh=5TJk3nsrvYx/dI934kKu+QBoEttnuiPGUvIKP/oHGTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No6Wt4rOuXzFHOutmXQC73VR38wmWFCptKslq5/VNIkY3ZXGHIJirALcpEgdWc+qC
	 jZQCyG2u3l+NnrFP/jBa33p2QcLzNXf3mNk3blxGcqDytwgtmlz+tVuxa216r6iAIB
	 p1Tb7r9yL8owaSgWTT9CzXsS1YO+oZS5XGV542Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 248/367] parisc: led: Reduce CPU overhead for disk & lan LED computation
Date: Wed, 20 Sep 2023 13:30:25 +0200
Message-ID: <20230920112904.972862261@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 358ad816e52d4253b38c2f312e6b1cbd89e0dbf7 upstream.

Older PA-RISC machines have LEDs which show the disk- and LAN-activity.
The computation is done in software and takes quite some time, e.g. on a
J6500 this may take up to 60% time of one CPU if the machine is loaded
via network traffic.

Since most people don't care about the LEDs, start with LEDs disabled and
just show a CPU heartbeat LED. The disk and LAN LEDs can be turned on
manually via /proc/pdc/led.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/led.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -56,8 +56,8 @@
 static int led_type __read_mostly = -1;
 static unsigned char lastleds;	/* LED state from most recent update */
 static unsigned int led_heartbeat __read_mostly = 1;
-static unsigned int led_diskio    __read_mostly = 1;
-static unsigned int led_lanrxtx   __read_mostly = 1;
+static unsigned int led_diskio    __read_mostly;
+static unsigned int led_lanrxtx   __read_mostly;
 static char lcd_text[32]          __read_mostly;
 static char lcd_text_default[32]  __read_mostly;
 static int  lcd_no_led_support    __read_mostly = 0; /* KittyHawk doesn't support LED on its LCD */


