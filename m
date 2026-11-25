Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620534;
	b=YXrwJN7Kq3W1yJLM1exN7XF7Hy9O+cViLMev8/OJSotWnMkOv3nHDIgI4/61j+Yuvphz
	 3LhGMXOf1my2CZ2JRKHHMhbW2dpyFu1MQRvEDn21MDbVzR08F5kkbnYEcI4dFd6yv9Zow
	 IcrcVOmwPJpZStqSh5fy68wY6+8WvUxItNCBhj2DbpOBZbSxwlTP2/QaWKkR1mJhENgvy
	 CJ0/YtwHInuK5668NsRKDHLNM2JydFzk9wsE3YZwRZWiYjnr2K9j2dImuKsafjCexkHXt
	 9blnTP9VL+Dw6p1w9VyrCxTpC6A8rJM1JRSbofv58O/ld3SR2Z7Kj5psso1917Zym5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gq6GbXlRC0KSqGZRfrSfnqnHIbPKg33OhekDsFRjk7Y=;
	b=ldvtkXo6g/FGFoPW+E8JAWzUHH0KUqOxia4wR2aq9aFg0Q421TI+nGNM7QW1kJanQGrr
	 s01M/2RF22JKxth3/ibawxUCDeZEVh8/Vv608CphQQQBRgRO+7K0AbDV6z5j80rwryXGJ
	 1ccxmmuqjtxppcKeR5Wn2UyX4QT58nP3w4/Wc/Vd+U+1cypnC+NEBCgUEAI2AWqvN06pq
	 dN0YDPoFqG0qjSxtQCAU8+l0uVyNhWJybutqYxtZm1jnx94COCdBE19ukAShaS+s+/f2t
	 +BV0REbz2wm12AVECyh6c9Fm9VrqqvDAw26tnyRKJftzQz9izkHqbRYC/dHTk52GFaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mcrrNnk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E802606A323;
	Wed, 25 Nov 2026 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0mcrrNnk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AFA1F000C0;
	Wed, 25 Nov 2026 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620534;
	bh=gq6GbXlRC0KSqGZRfrSfnqnHIbPKg33OhekDsFRjk7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0mcrrNnkc3Eyul3eVbDR3Seo+FwNPaFU+iDfmcLqs/BlYXtzs1oQv92U9336tJpyT
	 sfMJzMtWpLOCz8RJsEoPcRotGeplpY0OIl5tJV60b8kicKX3keDeTQWDSTXQkXr8Xf
	 N979la5qVWIrKG86wzGGcCrhl0hZljNQUhe6UC8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 7.3 0950/1005] w1: w1_therm: leave the slaves of other families alone
Date: Wed, 25 Nov 2026 15:38:08 +0100
Message-ID: <20261125143843.929107652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit c0eadd2e06e52563cae2b80491e56eb9712eb727 upstream.

The file therm_bulk_read belongs to the bus master.  Its callbacks walk
all the slaves of the bus and look at sl->family_data as if every slave
were a temperature sensor.  A 1-wire bus can carry other devices too:

- The family data of a slave which is driven by another driver, such as
  w1_ds2433, w1_ds250x, w1_ds28e04 or w1_ds28e17, is a structure of that
  driver.  bulk_read_support() takes whatever is at the offset of
  specific_functions for a pointer and dereferences it, and if the
  result happens not to be 0, the callbacks write the state of the
  conversion into that foreign structure.

- For a slave without family data, which is the case for most of the
  other drivers and for the default family, trigger_bulk_read() gives up
  with -ENODEV.  A single serial number chip on the bus is enough to
  make the bulk read unusable for all the sensors.

Only look at the slaves whose family is one of ours.  A bulk conversion
now works on a bus with other devices.

Fixes: 57c76221d5af ("w1_therm: adding bulk read support to trigger multiple conversion on bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-9-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_therm.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -907,6 +907,19 @@ static inline bool bulk_read_support(str
 }
 
 /**
+ * bulk_read_slave() - check if a slave of the bus takes part in a bulk read
+ * @sl: any slave on the list of the master
+ *
+ * The family data of the slaves of other families is none of our business.
+ *
+ * Return: true if it is one of our devices and supports bulk read
+ */
+static bool bulk_read_slave(struct w1_slave *sl)
+{
+	return device_family(sl) && sl->family_data && bulk_read_support(sl);
+}
+
+/**
  * conversion_time() - get the Tconv for the slave
  * @sl: device to get the conversion time
  *
@@ -1496,9 +1509,7 @@ static int trigger_bulk_read(struct w1_m
 	 * so we can apply a strong pullup if required
 	 */
 	list_for_each_entry(sl, &dev_master->slist, w1_slave_entry) {
-		if (!sl->family_data)
-			goto error;
-		if (bulk_read_support(sl)) {
+		if (bulk_read_slave(sl)) {
 			int t_cur = conversion_time(sl);
 
 			t_conv = max(t_cur, t_conv);
@@ -1536,7 +1547,7 @@ static int trigger_bulk_read(struct w1_m
 			/* set a flag to instruct that converT pending */
 			list_for_each_entry(sl,
 				&dev_master->slist, w1_slave_entry) {
-				if (bulk_read_support(sl))
+				if (bulk_read_slave(sl))
 					SLAVE_CONVERT_TRIGGERED(sl) = -1;
 			}
 
@@ -1565,7 +1576,7 @@ mt_unlock:
 set_flag:
 	/* set a flag to register convsersion is done */
 	list_for_each_entry(sl, &dev_master->slist, w1_slave_entry) {
-		if (bulk_read_support(sl))
+		if (bulk_read_slave(sl))
 			SLAVE_CONVERT_TRIGGERED(sl) = 1;
 	}
 error:
@@ -1933,16 +1944,14 @@ static ssize_t therm_bulk_read_show(stru
 	int ret = 0;
 
 	list_for_each_entry(sl, &dev_master->slist, w1_slave_entry) {
-		if (sl->family_data) {
-			if (bulk_read_support(sl)) {
-				if (SLAVE_CONVERT_TRIGGERED(sl) == -1) {
-					ret = -1;
-					goto show_result;
-				}
-				if (SLAVE_CONVERT_TRIGGERED(sl) == 1)
-					/* continue to check other slaves */
-					ret = 1;
+		if (bulk_read_slave(sl)) {
+			if (SLAVE_CONVERT_TRIGGERED(sl) == -1) {
+				ret = -1;
+				goto show_result;
 			}
+			if (SLAVE_CONVERT_TRIGGERED(sl) == 1)
+				/* continue to check other slaves */
+				ret = 1;
 		}
 	}
 show_result:


