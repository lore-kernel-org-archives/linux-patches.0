Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623665;
	b=vnn0Fh5eRt4l3BNim0ckO3vTS7iqJPRBXzF58iyOzxUdUKQQi731io1AQD8oEJyTz7ws
	 ebf8O99XrkPkghkL5Sw8PCxrOhrbIZY3wTKrwWx3E+NxdgWYb2VxWxy6rEZKnqCy8URv1
	 kHqu3q99Iqay6BBbKRiCHU/X2OIf2qDOl2ssAmmdfRg5SUb6FPtUa8QLYMe7wolTGrefi
	 2wVr4KY9lHZEnTnvEdHpE6IGiDxLYbxM5aTQ5nKPbwAhAsrDqTVxy8EireRt8iAgrj3wD
	 DvQef7GhTMpzvv13J2bdKSCVAC+/u1pgKdo4qoI//dtz0yPgOgTOu/V8jkJBs8E8/Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hoePwj5f9rehFV8ypoFR84i/Kw4T5sPjdxSsX3ZvQ4U=;
	b=OjITGb/fdMD293tYIlYGMIm2pTKPl1C1I091E3X5IYtbLQE7AafBXrfwOBMvb2KeIuhg
	 WMAS+osp6K0GcWpDzyypB6MyDyajlecUZA7Zbr3LfNUMFmmGKV+x2TofhQIPN+cBmG6qx
	 CsUvnYUbapCnOLlAQO2wfgF7R1KiTpSoqQenjVWqJItDD7xB/T00/W22/US+4XhelpB+2
	 4mwnt0r7pwif4LWpEpf/uD2gLZBUvfSr3hu/SU9YX0vf9gkaMO9I/vUMfeqqdLWdNfLIn
	 vjDN3k+lLDwiO/2nHqtM/aa6o2ke97DiUTyEZmYHcrPMrI49gaNBXyK9Eu1r2p4lQ8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvOqvXX9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E39606A685;
	Wed, 25 Nov 2026 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zvOqvXX9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8886D1F000D2;
	Wed, 25 Nov 2026 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623665;
	bh=hoePwj5f9rehFV8ypoFR84i/Kw4T5sPjdxSsX3ZvQ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvOqvXX9HBS3eTpADg4CNv1FTpPNbErTteVVLG9ihxByU7ffyYI4XsQyOKahHAmIN
	 7DyrgCx98v/nRUDl6Vgig8rQ29lFp8f6O1TulalUh9QHK7YT2F+YDRoggQUTjw17o0
	 usDXiCESiYiyBInTHgGeD+3npViAwL8rI1HH+TfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 888/990] iio: addac: ad74413r: fix the values of set_multiple
Date: Wed, 25 Nov 2026 15:37:35 +0100
Message-ID: <20261125143842.812475663@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit e6dfbd84b833ed595a5236b027357e917de28260 upstream.

ad74413r_gpio_set_multiple() walks over the lines in the mask and looks up
the new value of each with

	if (*bits & offset)

offset is the number of the line, not a bit mask.  Line 0 is always driven
low, line 1 gets the value meant for line 0, line 2 the one meant for line
1, and line 3 is driven high if either of these two is.

Test the bit which belongs to the line.

Fixes: fea251b6a5db ("iio: addac: add AD74413R driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/addac/ad74413r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/addac/ad74413r.c
+++ b/drivers/iio/addac/ad74413r.c
@@ -313,7 +313,7 @@ static int ad74413r_gpio_set_multiple(st
 			return ret;
 
 		real_mask |= BIT(real_offset);
-		if (*bits & offset)
+		if (test_bit(offset, bits))
 			real_bits |= BIT(real_offset);
 	}
 


