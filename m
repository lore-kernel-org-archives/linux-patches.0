Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620649;
	b=I2aeX+VOkLkrtvNxGjCPrEJzpB83Cx6Ti9UwYZQqtIfTccHZof4qu+/pdm6XKOPTCl7Q
	 oUrsIN259BJmsj5C7Q0ahNhS4Bj1ef9sVt8PH0cmHVrsUADWfrg0DStODEQ0pl69/0J2y
	 ABixstHVVQi7P4f9qVv4ntEqJ2o4W+t3k1PdODijiPy325KwXbcSjd9lICL4eNb175VAs
	 nq6YUppGrloht+tWValGyMSlDGpBtn+EEHSGEEs7K7YJMntp7epEP0CNXvvLoh0EYmUjl
	 navrL1GVmIZS4ZHlpL/SeWBwj1McRtHSUtXBRBfU8eZkv8QfLUIt71nm23oek6VptRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2gN3DdVUG0DFgsvPKojZ1ygc+G3BJTG7mMZaqe5df4=;
	b=0NuTZkTsaQa+jBLnnjV9fobdeEq3I/aPneHQHmgJ5TWoyMCY9WrA2VUElzQRgCGKyCnj
	 CWfYk7/BVZoureLlDBIOeV/OGCUrsEtAAO4ruEUPctnrOYsiU0l7RUGt7tO1p/QujCEfo
	 o/XeNNRWQkG9Kx6J9XNEq5Pl8P+vxGZTDYvHm9NO4Sc70mAP/2w4dP9k1RwJ1OK+61lPr
	 LRkAtcmc/oTORwmwMwm0pld5kF9C2z7lC2vjDsi9IiLPo4Q241O8yXdn6f9W4z0zPGOVP
	 J8jpFLyX94i6uLBBbUGDVnPBBZhJdJYR6lg+YFNOgxna+y4Sebd4b8yxxJQjgW/vLGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ldFo7Yg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA86606A33B;
	Wed, 25 Nov 2026 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ldFo7Yg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFFB1F000C0;
	Wed, 25 Nov 2026 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620649;
	bh=Y2gN3DdVUG0DFgsvPKojZ1ygc+G3BJTG7mMZaqe5df4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldFo7Yg3X/HkKWDt/IuWU0zcCB8Im+W9k96pVBf3P1BfDtJOA8XOqnx0fIZsPe4eK
	 GISHv70N3I+xmFdo6xGevlDEHJh0WR+w/FXyOaUdNR5omn25yJHiyUMq9KvGU/Seaa
	 k8SOhLv770RUomM2n1mcas+ff8kHvUlZQ8qQ2N6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0981/1005] iio: inv_sensors: do not compute period estimation when updating odr
Date: Wed, 25 Nov 2026 15:38:39 +0100
Message-ID: <20261125143844.640176848@linuxfoundation.org>
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

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 0d695709ed380f1bc9303a91f57525d33766a07e upstream.

When odr is updated, the delta between the interrupts will change and it
will lead to a bad period estimation.

Avoid this by preventing the period estimation in this case.

Fixes: 82bd09ce4fd3 ("iio: inv_sensors: improve period measurement by using a longer delay")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -142,6 +142,12 @@ void inv_sensors_timestamp_interrupt(str
 	/* update delta timestamps and estimated period */
 	it = &ts->delta;
 	ts->delta_counter += sample_nb;
+	/* reset in case of odr change */
+	if (ts->new_mult) {
+		it->lo = 0;
+		it->up = 0;
+		ts->delta_counter = 0;
+	}
 	delta = timestamp - it->up;
 	delta_threshold = INV_SENSORS_TIMESTAMP_MIN(INV_SENSORS_MIN_IT_DELTA, ts->chip.jitter);
 	if (delta >= delta_threshold) {
@@ -161,7 +167,7 @@ void inv_sensors_timestamp_interrupt(str
 	it->lo = it->up;
 	it->up = timestamp;
 	delta = it->up - it->lo;
-	if (it->lo != 0) {
+	if (it->lo != 0 && !ts->new_mult) {
 		/* compute period and check validity */
 		period = div_s64(delta, sample_nb);
 		valid = inv_validate_period(ts, period);


