Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4147B1E47B7;
	Mon, 21 Oct 2024 10:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507903; cv=none; b=t77w4sQ/AYTuRAAtbdQLQ+2KhX8QnyW64ZQN8+su0mK8QdKbCIm/NaQFGEyFC1M9sZTQ25WcqgpE7D3pInx5ucTyRn1nZpawNn9A0MZgqQRPiRggZt4d1lDUS1lp430EriI3f8AaA7hRMBOIP8BVqPVykAYP4PewBqoTDTLjy0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507903; c=relaxed/simple;
	bh=pckRBn//ZopwukBrqnnFyBhcA9hnvQuJfcWeODLVdZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHz6OBKfLZx2lLiJqRuxBBkXqwlzOmNygighY5LZPluhJwZqFzu1faj4dv+Gk+qFu3t5nX3YqwU+9hq30ISYNQyJ/1BZG3EhCGhZH9jfwAvqKpgD/sUFEuh6IJxp71Uvr+WnmqMTzWlSfvRNCBzjlnvEGrf1i7/g2Q0G/EW0YJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHq8Bjcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHq8Bjcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748DBC4CEC3;
	Mon, 21 Oct 2024 10:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507902;
	bh=pckRBn//ZopwukBrqnnFyBhcA9hnvQuJfcWeODLVdZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHq8BjcwN5Xggg8wFXEcxLuUH5lECv9vb8ZLF67XmpnwbBTLN2HKbk8pZvPRTMeXO
	 sHIlAAvbkNV+yWobols2gRJ8N2TY0z8BqmuLWvWGJ/pn5TUvmhJtZhxX0aoBWxsmVg
	 bnrv3Mb+OucQr+GgDU98rs0cm8Zc3ReLLJ57713s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 31/52] iio: light: veml6030: fix ALS sensor resolution
Date: Mon, 21 Oct 2024 12:25:52 +0200
Message-ID: <20241021102242.846138157@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c9e9746f275c45108f2b0633a4855d65d9ae0736 upstream.

The driver still uses the sensor resolution provided in the datasheet
until Rev. 1.6, 28-Apr-2022, which was updated with Rev 1.7,
28-Nov-2023. The original ambient light resolution has been updated from
0.0036 lx/ct to 0.0042 lx/ct, which is the value that can be found in
the current device datasheet.

Update the default resolution for IT = 100 ms and GAIN = 1/8 from the
original 4608 mlux/cnt to the current value from the "Resolution and
maximum detection range" table (Application Note 84367, page 5), 5376
mlux/cnt.

Cc: <stable@vger.kernel.org>
Fixes: 7b779f573c48 ("iio: light: add driver for veml6030 ambient light sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20240923-veml6035-v2-1-58c72a0df31c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6030.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/veml6030.c
+++ b/drivers/iio/light/veml6030.c
@@ -780,7 +780,7 @@ static int veml6030_hw_init(struct iio_d
 
 	/* Cache currently active measurement parameters */
 	data->cur_gain = 3;
-	data->cur_resolution = 4608;
+	data->cur_resolution = 5376;
 	data->cur_integration_time = 3;
 
 	return ret;


