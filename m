Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620718;
	b=pzqsHXQmMIPK+4g/lWaY577NmTEnlGh8aoe3Fqx40wV554R9yUo8pNU9070uFUEkBSU+
	 rwV+a60i7KmiEyUXK1AGK83fijU7IlPrGkcDrWqT0D/NMoQtZY9qCccMRRRi+4zAsNyj9
	 thZWssKC4SEROw1uRE2zhyVNZ/eCb6JMPTt/YU/1YZdlm7PbcMOTrlWXfAGMHWmJLSwna
	 6bHoAX/olVaDm1MSXxXiSRaSgw5bD8xSLJnj9Kbizr3gxVSkydfLYOX4JZEqZrPSEh3a7
	 VsXTf7hdXrVIcjH7TdqBjnAKHKyb3O42XJnWJTRYVnREvYC0OwDmBdA/bz5QBNxgJdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DB2JHEiKxPN0YckenKNOVdSUc+CSmRgaRwQccBhVbmw=;
	b=oun5VzPYkSPObfvkegC2azeuVreyXProJTZQd7PZm34ywfbp/Mc5zIb+6Lnz+ZIPDyni
	 4q5s8MNQBMkZh2oM+wEh8kZ+9tbP2nC1+hqUooTc2PkrsX85RYm9rfWhTargB5OfmPnL0
	 uZPvFMuljwOGrx96IjwCHoX3+fyo4lK4S+4SQfC+/E1bitO2hSsvKMHH+CotW/WuhakLk
	 o7gim0HPYwKdyRClfO/u0rQMqRnU5UkvNGikeTmnO+w/ma24lccyF8Fs0UYe2VbUcDp62
	 KhUacHtBiQY3zKwxCMybsNMyFMuMdar8nVK1oEs8LMY0gY7khXdx8GN/k+LMpGP810w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ryzsr0mo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23851606A323;
	Wed, 25 Nov 2026 15:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ryzsr0mo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117371F000C0;
	Wed, 25 Nov 2026 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620717;
	bh=DB2JHEiKxPN0YckenKNOVdSUc+CSmRgaRwQccBhVbmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ryzsr0mo5Orh021HFHDFD4+ekP8mc3SEfRE301fiyWu77rafxOAtnzUOf2snrpsi2
	 dUuDhfOsdEbB6U2WJqIo/YRzZLqB7YQL5r+eG9QSrDGf+ulv8qoyySxTa5hOBXnrkA
	 Di8bI6abqGE0nE8vHoBqZC03a1R3jG9cg50nCws0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viral Patel <viral8854@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0987/1005] iio: magnetometer: tlv493d: fix magnetic field scale
Date: Wed, 25 Nov 2026 15:38:45 +0100
Message-ID: <20261125143844.777412267@linuxfoundation.org>
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
@@ -299,11 +299,11 @@ static int tlv493d_read_raw(struct iio_d
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


