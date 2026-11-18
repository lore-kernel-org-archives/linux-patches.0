Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043904;
	b=bPZ1EoD0mY30wUDHA/+gXihXYrTWe9Lyi0M4aIgQYl6M1Q6Jo6PEhtkFwVRfJ6lslBux
	 joETbldcv00UonJx922Ofu9Rc24OvnF1ljA4nNNKreH6o+Us+2hYje9dBOtkwUgVbXBIq
	 LYdCrPqD4eWpyvzXRT3QpxCr29s5SdqgLu/+DMhRfPtOlvJHFWiRz51ptkDLNCsjzgQEb
	 XHi51EAq0STA+jFTieDTdW2KNmQeBDCv9+jVC60u5UdlKD3GpjWHMcg2sGTKunb3dof9h
	 63e6FL0LPQHbNU0uAgWQbe03hny3m4BCJfPryH0eckl9n58s0xZelLwwCZIoXllDp0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YFM6lLBE/9BsQ2UJPF5Z/+22gsjfO8qMk+wqrXR9Wm4=;
	b=0BabZKaihiVsWq+CYVBsf08+Whd25BjDBkjBpxNKFLOJxi9TFINXSDEs1mdfD/VqL6ZW
	 0ApUwIvLu0LhQu03BevqTlfHmTbrsIXWXGySjtn/rQMbdBcWAVpuFB1WjpoX63JU58uKy
	 n7xsGdICzzhLHP4tTEA2yqi9JoclEw/2hZ/vCinptDthEV/+p0bsReaIm52APUDcf65aC
	 LfB7O1MDgN99gO97PiHYRYnwuuza8gn53W05n0fBMVeL3ud7jilI9Qg1bT/CKKzUZYwAd
	 VqquscTqXsbm3dxpxFAb0kyiE04mR+18fxJmWvIQnP2gK4jbJ/tytVeQ6MnSVo0xvcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VrF7ter9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332BD606A31C;
	Wed, 18 Nov 2026 23:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VrF7ter9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3151F000C4;
	Wed, 18 Nov 2026 23:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043903;
	bh=YFM6lLBE/9BsQ2UJPF5Z/+22gsjfO8qMk+wqrXR9Wm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrF7ter9Epb7Mapm702c1Wpv1AW/tN7Zde9UlJigQ6VSM7FClKEfYdyplKCFqKRRY
	 0RVZsMVhFbRrLVhxXYMZgTzztwlPvsmAte7RSRbanw85BTt3j3ej6haZEwj1AGfpjc
	 EyExIpDaoKg9YD6siP64csRqJooJjb/JdtcRqd80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0378/2857] iio: introduce struct iio_scan_type
Date: Wed, 18 Nov 2026 15:23:32 +0100
Message-ID: <20261118150215.019087077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit fd7179ece035417f44f7ecff086d6df674d8a5bd ]

This gives the channel scan_type a named type so that it can be used
to simplify code in later commits.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240530-iio-add-support-for-multiple-scan-types-v3-1-cbc4acea2cfa@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: f0ea4824deeb ("iio: health: max30102: fix NULL dereference in interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iio/iio.h | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 3f3602770b864..e18b3b2fd4260 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -172,6 +172,27 @@ struct iio_event_spec {
 	unsigned long mask_shared_by_all;
 };
 
+/**
+ * struct iio_scan_type - specification for channel data format in buffer
+ * @sign:		's' or 'u' to specify signed or unsigned
+ * @realbits:		Number of valid bits of data
+ * @storagebits:	Realbits + padding
+ * @shift:		Shift right by this before masking out realbits.
+ * @repeat:		Number of times real/storage bits repeats. When the
+ *			repeat element is more than 1, then the type element in
+ *			sysfs will show a repeat value. Otherwise, the number
+ *			of repetitions is omitted.
+ * @endianness:		little or big endian
+ */
+struct iio_scan_type {
+	char	sign;
+	u8	realbits;
+	u8	storagebits;
+	u8	shift;
+	u8	repeat;
+	enum iio_endian endianness;
+};
+
 /**
  * struct iio_chan_spec - specification of a single channel
  * @type:		What type of measurement is the channel making.
@@ -183,17 +204,6 @@ struct iio_event_spec {
  * @scan_index:		Monotonic index to give ordering in scans when read
  *			from a buffer.
  * @scan_type:		struct describing the scan type
- * @scan_type.sign:		's' or 'u' to specify signed or unsigned
- * @scan_type.realbits:		Number of valid bits of data
- * @scan_type.storagebits:	Realbits + padding
- * @scan_type.shift:		Shift right by this before masking out
- *				realbits.
- * @scan_type.repeat:		Number of times real/storage bits repeats.
- *				When the repeat element is more than 1, then
- *				the type element in sysfs will show a repeat
- *				value. Otherwise, the number of repetitions
- *				is omitted.
- * @scan_type.endianness:	little or big endian
  * @info_mask_separate: What information is to be exported that is specific to
  *			this channel.
  * @info_mask_separate_available: What availability information is to be
@@ -241,14 +251,7 @@ struct iio_chan_spec {
 	int			channel2;
 	unsigned long		address;
 	int			scan_index;
-	struct {
-		char	sign;
-		u8	realbits;
-		u8	storagebits;
-		u8	shift;
-		u8	repeat;
-		enum iio_endian endianness;
-	} scan_type;
+	struct iio_scan_type scan_type;
 	long			info_mask_separate;
 	long			info_mask_separate_available;
 	long			info_mask_shared_by_type;
-- 
2.53.0



