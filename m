Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620497;
	b=ymuT6I1AP/W6ju6mAEvMwfr3wYBb6QXutgF2+8cAunV1sKlq5kHH6Qw2n1pkPLw+FX+1
	 5XxenFS2+/NjoEUe2VTH8hPO3E30gU5Lmp9f+NHJaZGUWHEHJF44DudzAoMkHQAjwVWh5
	 ngYerrNbySk+hhRfKcqQ0xdAXUSAzt0q+tKRUeUyZVC7s4J1ahBNu0mFnTtOh84V7g5hZ
	 qxQ4IgyZPrTzAM6qgVTjjATABZ8Y51QoPlC290/MiMoCWW5lSWG58zIX98xpEeOk9y48T
	 SppFY7KAjQcoJQ1PWFsTOMcGiarrp3Eh8zi2Cbjf/oZp0h88wo/Qtkrbt7iaX82yBDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cXpQxf4REG2yMGUAwKEOTrfdDZJVKydBpULH380wp00=;
	b=rrJUMjAKH8c8SytTIjP+D4nRSYl7skP2P5418gnZfAll1XH0rZBOGOWv7goUnWX04Pqa
	 UwHE+sqB/OSqT6WcUh6IfStFcNiA83UznoibplYARlfymEXg+nl7HV9lxaM4Ai/+eGer3
	 Jr576U7elqeC8t6vbvHMCaC7Nf6mf3HhDFhQ+1EknSfk5ZC6r8x92nIc5xu5xS4qWb8zO
	 fAwdg1LRVd1tqiY1/o3khK+qRvapG8rbkYDO+Px7/yy/YLvaf1zEKPfZ0viQpEBFyV0Ho
	 7xwZ6v3xre9nnTQz4d9A7rQnooXJT0RdOOfkX+lX6hnWuEV4wXy6w4u43ggsVRFccBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AnPxLd34;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67640606A31E;
	Wed, 25 Nov 2026 15:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AnPxLd34
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3383B1F000C0;
	Wed, 25 Nov 2026 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620496;
	bh=cXpQxf4REG2yMGUAwKEOTrfdDZJVKydBpULH380wp00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnPxLd34VfMh784D2Hk2esJyjKAimjOSs8705Krfb2744tfS352H9O2MgpVeSXNzr
	 MgUqDDS7L6MeLtmSvrQmAqaRCF15v3YJ0UbxXDo+LSVWfrppgq7B2XfyeX+7DAcmKE
	 celw8Cg961r8WZ98l99y1y+vbww1qKigmBKYscOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0892/1005] iio: accel: adxl380: dont stay in standby on -EINVAL
Date: Wed, 25 Nov 2026 15:37:10 +0100
Message-ID: <20261125143842.590882128@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 4c56180167ea4d419a0578545bf62110494b563d upstream.

adxl380_set_act_inact_threshold() puts the sensor into standby, writes the
threshold and switches the measurement on again.  A threshold above 8191 is
refused in between, and the sensor stays in standby: no samples and no
events until the next write that succeeds.

adxl380_set_range() has the same problem and a worse one.  It rescales both
thresholds for the new range.  If one no longer fits it returns -EINVAL
with the sensor in standby, the new range in the chip, the old one in
st->range and rescaled thresholds in the driver's state: from the next
successful write on the samples are reported with the wrong scale.

Switch the measurement on again if the threshold is refused.  In
adxl380_set_range() see whether the thresholds fit before anything is
changed.

Fixes: df36de13677a ("iio: accel: add ADXL380 driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl380.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/iio/accel/adxl380.c
+++ b/drivers/iio/accel/adxl380.c
@@ -334,8 +334,11 @@ static int adxl380_set_act_inact_thresho
 		return ret;
 
 	ret = adxl380_write_act_inact_threshold(st, act, th);
-	if (ret)
+	if (ret) {
+		/* Leave standby also if the value was refused */
+		adxl380_set_measure_en(st, true);
 		return ret;
+	}
 
 	return adxl380_set_measure_en(st, true);
 }
@@ -698,6 +701,12 @@ static int adxl380_set_range(struct adxl
 
 	guard(mutex)(&st->lock);
 
+	/* The thresholds are rescaled: see that they fit before any change */
+	if (mult_frac(max(st->act_threshold, st->inact_threshold),
+		      adxl380_range_scale_factor_tbl[st->range],
+		      adxl380_range_scale_factor_tbl[range]) > ADXL380_THRESH_MAX)
+		return -EINVAL;
+
 	ret = adxl380_set_measure_en(st, false);
 	if (ret)
 		return ret;


