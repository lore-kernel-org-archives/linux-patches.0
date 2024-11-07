Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAD547F4A
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730993120; cv=none; b=hLz0TryD6GJWDJ5tb3pSgJGYEYftez63sKLKkH9bAW/wuRcQDCIQX7zSo1n6KROImNMQdFtL+EwakmQHly7oEd4GcZ3KmnqYW+oZuCgY4OEx8FKHfHSVGcXov3UdtHham3AG18pP2dlyJwtGMIKQsUEabYjRFyaDBzrAwoHF8p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730993120; c=relaxed/simple;
	bh=zmmURaCZvXE4+kB7JLY8MS1IeA8+E+rhjn3iho+XAj0=;
	h=From:Date:MIME-Version:Content-Type:Message-Id:To:Cc:Subject; b=YUYsB+gaiIKYiRXHN17V/ZJ0+R9SrVZX9ZdoB9hPQQdFYbjgf/0jzau83AxmrhLiacepe29mQ19o2HRabJZvcZFXkFhV929ylsrsihWHd2+1MOCGsq+MKmgs07XkI4co7xeO9TEkdVJiSe5RPaoc3h+8cyQuUPc2j3+TnAmUvrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD2DC4CECC
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 15:25:19 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 7 Nov 2024 15:25:16 +0000
Resent-Message-ID: <Zyzb3CDvOrU7UMEb@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Thu, 07 Nov 2024 15:07:47 +0000
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=GIuI=SC=pengutronix.de=jre@kernel.org>)
	id 1t946r-002MCP-Ey
	for broonie@sirena.co.uk; Thu, 07 Nov 2024 15:07:47 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id B5D865C28BB
	for <broonie@sirena.co.uk>; Thu,  7 Nov 2024 15:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 2BADFC4CECD; Thu,  7 Nov 2024 15:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3713C4CECC
	for <broonie@kernel.org>; Thu,  7 Nov 2024 15:07:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org D3713C4CECC
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from dude04.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::ac])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <jre@pengutronix.de>)
	id 1t946e-0003NQ-3U; Thu, 07 Nov 2024 16:07:32 +0100
From: Jonas Rebmann <jre@pengutronix.de>
Date: Thu, 07 Nov 2024 16:07:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-spidev-test-word-delay-v1-1-d4bba5569e39@pengutronix.de>
X-B4-Tracking: v=1; b=H4sIALLXLGcC/x3MSwqAMAwA0atI1gbaKgheRVykNmpAVBrxQ/HuF
 pdvMZNAOQortEWCyKeobGuGLQsYZlonRgnZ4IyrrTUN6i6BTzxYD7y2GDDwQg9a8uRd1dQVecj
 xHnmU+x93/ft+yB2VKGgAAAA=
X-Change-ID: 20241107-spidev-test-word-delay-1abab23743ab
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel@pengutronix.de, Jonas Rebmann <jre@pengutronix.de>
X-Mailer: b4 0.14.2
X-PTX-Original-Recipient: broonie@kernel.org
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=GIuI=SC=pengutronix.de=jre@kernel.org
Subject: [PATCH] spi: spidev_test: add support for word delay
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: lXTjdIZxsyEr

Support setting the word delay using the -w/--word-delay command line
parameter. Note that spidev exposes word delay only as an u8, allowing
for a maximum of 255us of delay to be inserted.

Signed-off-by: Jonas Rebmann <jre@pengutronix.de>
---
 tools/spi/spidev_test.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/spi/spidev_test.c b/tools/spi/spidev_test.c
index 9179942d7f15ceb5cab17477d950800f545b6ab4..f2135d619a0bb4aa3eff830af0f2114ad9991cc5 100644
--- a/tools/spi/spidev_test.c
+++ b/tools/spi/spidev_test.c
@@ -42,6 +42,7 @@ static char *input_file;
 static char *output_file;
 static uint32_t speed = 500000;
 static uint16_t delay;
+static uint16_t word_delay;
 static int verbose;
 static int transfer_size;
 static int iterations;
@@ -124,6 +125,7 @@ static void transfer(int fd, uint8_t const *tx, uint8_t const *rx, size_t len)
 		.rx_buf = (unsigned long)rx,
 		.len = len,
 		.delay_usecs = delay,
+		.word_delay_usecs = word_delay,
 		.speed_hz = speed,
 		.bits_per_word = bits,
 	};
@@ -172,11 +174,12 @@ static void transfer(int fd, uint8_t const *tx, uint8_t const *rx, size_t len)
 
 static void print_usage(const char *prog)
 {
-	printf("Usage: %s [-2348CDFHILMNORSZbdilopsv]\n", prog);
+	printf("Usage: %s [-2348CDFHILMNORSZbdilopsvw]\n", prog);
 	puts("general device settings:\n"
 		 "  -D --device         device to use (default /dev/spidev1.1)\n"
 		 "  -s --speed          max speed (Hz)\n"
 		 "  -d --delay          delay (usec)\n"
+		 "  -w --word-delay     word delay (usec)\n"
 		 "  -l --loop           loopback\n"
 		 "spi mode:\n"
 		 "  -H --cpha           clock phase\n"
@@ -213,6 +216,7 @@ static void parse_opts(int argc, char *argv[])
 			{ "device",        1, 0, 'D' },
 			{ "speed",         1, 0, 's' },
 			{ "delay",         1, 0, 'd' },
+			{ "word-delay",    1, 0, 'w' },
 			{ "loop",          0, 0, 'l' },
 			{ "cpha",          0, 0, 'H' },
 			{ "cpol",          0, 0, 'O' },
@@ -237,7 +241,7 @@ static void parse_opts(int argc, char *argv[])
 		};
 		int c;
 
-		c = getopt_long(argc, argv, "D:s:d:b:i:o:lHOLC3ZFMNR248p:vS:I:",
+		c = getopt_long(argc, argv, "D:s:d:w:b:i:o:lHOLC3ZFMNR248p:vS:I:",
 				lopts, NULL);
 
 		if (c == -1)
@@ -253,6 +257,9 @@ static void parse_opts(int argc, char *argv[])
 		case 'd':
 			delay = atoi(optarg);
 			break;
+		case 'w':
+			word_delay = atoi(optarg);
+			break;
 		case 'b':
 			bits = atoi(optarg);
 			break;

---
base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
change-id: 20241107-spidev-test-word-delay-1abab23743ab

Best regards,
-- 
Jonas Rebmann <jre@pengutronix.de>

