Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623764;
	b=K5MkY6hdVrfs6veyEup/ZgWZ88/bVmbXZryds/389ep/67iS4JmMZUy0ioG+LPJqifoz
	 NXs1JSqOHKONlxDqTKjiXJFYvs8H7nhHjfrROQH4ySRyiE9L7MI6P1JAa7GEpqYoJiJ1K
	 gh8tY3UgJNHhgvLegBA93vzTojHrqNYT8KlmLGi7SZAqd8rElCeGWLYvLaeFqsez03m5u
	 USqrjiJhDsBJunnHNZ8tl97zKkmBTrEQA/27RHvnbCgSXj5Kimf6/uaO7GRoAthv1/poJ
	 04b64OHRU7eww1BfU0qdoPtmkdJ1Ualc/pc/3TQqv1p3FYPX/GEIPprjOmHxx7AeH3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SALp9h9U3ujXm/tjDBxSO6Axhrfyw6LLkGFfvpTGsr4=;
	b=QnPSA8YMl125Hstdw6DRiZOR97AT8x8sbuF+IcrPvIz27cKk1iQNFlv+XxK1S4m7ZK8e
	 f4Hakt8XxBUOxUAXSjLoWCBz7zQ2kILLmM5PHlKZ6Hw1u6JS2uIPDG5c1rJubuvXrBAFB
	 xBMBtSuGZDKO+KUq47616ijvtOVyi7pVSAPOp+GRStLdsTkdI0poBs1pxi/JcSWrrhR/u
	 syp0D1x78Uup0jd9woKkjw//kLniaNV5emHRAgswfRMA6bMqlEBk2gppvcwWQz/rEH6V9
	 UTHtVk6sE1LSQYJDjZhNdoY2hFj7HbZMk8TxrhX/DOZHprKRSYxYi1Qb2eBd2qjOBWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=En7Y3ycD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EA6606A321;
	Wed, 25 Nov 2026 16:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=En7Y3ycD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08BE1F000C6;
	Wed, 25 Nov 2026 16:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623763;
	bh=SALp9h9U3ujXm/tjDBxSO6Axhrfyw6LLkGFfvpTGsr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=En7Y3ycDTxtQbDDLexbCM3dgdXuW2TvD6S3X3iMnkqFjyu7cVQMo0zBIUIhif0UAp
	 bw+Z/aTmvte4h2jNNj+jhL79lOpsQT2Sii5ha6gmCLHItGDsY8bhuFbfaJVLe/kcIr
	 ZwIHbg4m73Wnxm5EUZN3oMRGPBVXwn6OU5Dm/CKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viral Patel <viral8854@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 962/990] iio: magnetometer: tlv493d: fix magnetic field scale
Date: Wed, 25 Nov 2026 15:38:49 +0100
Message-ID: <20261125143844.519937522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viral Patel <viral8854@gmail.com>

commit ef5c183a863bb69bf019a2d2ae0e1bfdaebe6222 upstream.

The TLV493D-A1B6 datasheet specifies a magnetic resolution of
98 uT/LSB (0.098 mT/LSB). IIO reports magnetic field in Gauss
(1 mT = 10 G), so the scale should be 0.98 G/LSB.

The driver currently reports 98/1000 = 0.098 G/LSB, which
under-reports the magnetic field by a factor of 10. The comment
also gives the resolution as 0.0098 mT (9.8 uT), mixing up units.

Correct the scale value and the comment.

Fixes: 106511d280c7 ("iio: magnetometer: add support for Infineon TLV493D 3D Magentic sensor")
Signed-off-by: Viral Patel <viral8854@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/tlv493d.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/magnetometer/tlv493d.c
+++ b/drivers/iio/magnetometer/tlv493d.c
@@ -300,11 +300,11 @@ static int tlv493d_read_raw(struct iio_d
 		switch (chan->type) {
 		case IIO_MAGN:
 			/*
-			 * Magnetic field scale: 0.0098 mTesla (i.e. 9.8 µT)
-			 * Magnetic field in Gauss: mT * 10 = 0.098.
+			 * Magnetic field scale: 0.098 mTesla (i.e. 98 µT) per LSB.
+			 * In Gauss (1 mT = 10 G): 0.98 G per LSB.
 			 */
 			*val = 98;
-			*val2 = 1000;
+			*val2 = 100;
 			return IIO_VAL_FRACTIONAL;
 		case IIO_TEMP:
 			/*


