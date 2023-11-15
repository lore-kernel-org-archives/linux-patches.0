Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F4D1FCF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eg+vPbcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECEEC43395;
	Wed, 15 Nov 2023 20:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081849;
	bh=KaSzXWctiE4At2IKDDGvyy/741dA9r02BDvzrGsmkk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eg+vPbcy9t1bbWUrPaklfn2C5RkL12V8/i1bKgzzJ38Ig1xGKtgxoCnU21iX+oViW
	 TFsNQEEQuS74FuRpMnu29uNL79g6v2WHD+gVpzsg/XdFK8eNle1SaE6Z/WNDDfhTlr
	 OivqlDK5m3CEJENFJ9zMRuSTTO2C4T1+96RfR6tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/191] tools: iio: privatize globals and functions in iio_generic_buffer.c file
Date: Wed, 15 Nov 2023 15:46:45 -0500
Message-ID: <20231115204652.329960570@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit ebe5112535b5cf389ca7d337cf6a0c1d885f9880 ]

Mostly a tidy-up.
But also helps to understand the limits of scope of these functions and
globals.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20210215104043.91251-24-alexandru.ardelean@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 2d3dff577dd0 ("tools: iio: iio_generic_buffer ensure alignment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_generic_buffer.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/iio/iio_generic_buffer.c b/tools/iio/iio_generic_buffer.c
index 34d63bcebcd28..7c72405537770 100644
--- a/tools/iio/iio_generic_buffer.c
+++ b/tools/iio/iio_generic_buffer.c
@@ -49,7 +49,7 @@ enum autochan {
  * Has the side effect of filling the channels[i].location values used
  * in processing the buffer output.
  **/
-int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
+static int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
 {
 	int bytes = 0;
 	int i = 0;
@@ -68,7 +68,7 @@ int size_from_channelarray(struct iio_channel_info *channels, int num_channels)
 	return bytes;
 }
 
-void print1byte(uint8_t input, struct iio_channel_info *info)
+static void print1byte(uint8_t input, struct iio_channel_info *info)
 {
 	/*
 	 * Shift before conversion to avoid sign extension
@@ -85,7 +85,7 @@ void print1byte(uint8_t input, struct iio_channel_info *info)
 	}
 }
 
-void print2byte(uint16_t input, struct iio_channel_info *info)
+static void print2byte(uint16_t input, struct iio_channel_info *info)
 {
 	/* First swap if incorrect endian */
 	if (info->be)
@@ -108,7 +108,7 @@ void print2byte(uint16_t input, struct iio_channel_info *info)
 	}
 }
 
-void print4byte(uint32_t input, struct iio_channel_info *info)
+static void print4byte(uint32_t input, struct iio_channel_info *info)
 {
 	/* First swap if incorrect endian */
 	if (info->be)
@@ -131,7 +131,7 @@ void print4byte(uint32_t input, struct iio_channel_info *info)
 	}
 }
 
-void print8byte(uint64_t input, struct iio_channel_info *info)
+static void print8byte(uint64_t input, struct iio_channel_info *info)
 {
 	/* First swap if incorrect endian */
 	if (info->be)
@@ -167,9 +167,8 @@ void print8byte(uint64_t input, struct iio_channel_info *info)
  *			      to fill the location offsets.
  * @num_channels:	number of channels
  **/
-void process_scan(char *data,
-		  struct iio_channel_info *channels,
-		  int num_channels)
+static void process_scan(char *data, struct iio_channel_info *channels,
+			 int num_channels)
 {
 	int k;
 
@@ -238,7 +237,7 @@ static int enable_disable_all_channels(char *dev_dir_name, int enable)
 	return 0;
 }
 
-void print_usage(void)
+static void print_usage(void)
 {
 	fprintf(stderr, "Usage: generic_buffer [options]...\n"
 		"Capture, convert and output data from IIO device buffer\n"
@@ -257,12 +256,12 @@ void print_usage(void)
 		"  -w <n>     Set delay between reads in us (event-less mode)\n");
 }
 
-enum autochan autochannels = AUTOCHANNELS_DISABLED;
-char *dev_dir_name = NULL;
-char *buf_dir_name = NULL;
-bool current_trigger_set = false;
+static enum autochan autochannels = AUTOCHANNELS_DISABLED;
+static char *dev_dir_name = NULL;
+static char *buf_dir_name = NULL;
+static bool current_trigger_set = false;
 
-void cleanup(void)
+static void cleanup(void)
 {
 	int ret;
 
@@ -294,14 +293,14 @@ void cleanup(void)
 	}
 }
 
-void sig_handler(int signum)
+static void sig_handler(int signum)
 {
 	fprintf(stderr, "Caught signal %d\n", signum);
 	cleanup();
 	exit(-signum);
 }
 
-void register_cleanup(void)
+static void register_cleanup(void)
 {
 	struct sigaction sa = { .sa_handler = sig_handler };
 	const int signums[] = { SIGINT, SIGTERM, SIGABRT };
-- 
2.42.0



