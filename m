Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213024;
	b=VRxrK5UMtkmuE/BsjxzsVNV9AgtFCTl+OKgFNPiywrUZIWlzDrLNjD0z3M8Cx3pRRRMU
	 ZXGXvcGum5OnCjisLcbcE/CxfSBIfoSJN4a6eg9z+1V4cBYAijzmGz8E3aVcDRX6+thCP
	 SW4VJJ6jjoB0beGIruWAqbWBon0m5OU85A4jqjKD5GOtAcHPVVSfIWivCtg6Zz7TVdGHL
	 qQ/YBcZjPx7/Hl+8Pt6gnmNug8eJRmvPyFQWpRyARpxUgZePSdkuN5wpPekY6Lhp+AyCa
	 mw/dL8M621Y9ce8oJfWWF4eU5hDlwi389OSipS5PXynJ9x80R9edc9vdP6MawFpdSmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8NHgZRYJcmTGs1rWW8F2GWxRk6wKxrMtw/Sw8hUhmp8=;
	b=WOwr1ej5tpChE1JCWR6Hf23tGOefw9G++bdbZ2Ml9jXtxZtm9t99pZSbbkNK+wP8efQI
	 plU4FIAsrfZiEhDgtA5Hor5GVuvnjnZrfA5Kn2YAPpcnh5dx+J+TubsT799TgvNHZAy7u
	 FWh4O4yYLk4mneMIOZJT/il8A0vHjfbm3ezoIvautUNdO/tYbp7qMIv16IN0rBA3vt5nM
	 jpamQiG7ao+x4/2UiBAeEaUKV8J+6oGBWX/45YsYIdAgPuav4y8YFuuFDABvSq46IRqqy
	 Ga5gHqpjGX6sMfKo3VO61DTSNDsFcI/m+CjhWtDRGWzTrPUKfn4iu9tKoiEtAL85Vaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYDGmz9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C23606A320;
	Wed, 28 Oct 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYDGmz9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCEA1F01825;
	Wed, 28 Oct 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213024;
	bh=8NHgZRYJcmTGs1rWW8F2GWxRk6wKxrMtw/Sw8hUhmp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYDGmz9eyGy5+pi48uyUhFeWjhQMZwO8H/R6SpVl8+zgg5aZiyRy/16f4Hi0xF6XZ
	 cCpWkV5yFc2LiZM2XDfeixUidAbuRZtVJ1smhefGzSN6OGHym1ddgUjSd9dIGLRbml
	 OsJLxBqAKjPP6qjzudMZJDKWyf5fxllIrEpW7wqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0343/1887] iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup
Date: Wed, 28 Oct 2026 17:40:39 +0100
Message-ID: <20261028170507.032274231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

commit 56c423b233b214182c58c99861899327b45b0d6c upstream.

The sampling frequency tables store each frequency as an integer part and
a fractional part in micro units. num_sampling_freq_avail is initialized
to the number of flattened integer elements because read_avail() returns
the table as a flat array.

bmp280_write_sampling_frequency(), however, indexes the same table as a
two-dimensional array and uses num_sampling_freq_avail as the number of
rows. Convert the flattened element count back to the number of rows
before iterating over the table.

Fixes: 10b40ffba2f9 ("iio: pressure: bmp280: Add more tunable config parameters for BMP380")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/pressure/bmp280-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -725,7 +725,7 @@ static int bmp280_write_sampling_frequen
 					   int val, int val2)
 {
 	const int (*avail)[2] = data->chip_info->sampling_freq_avail;
-	const int n = data->chip_info->num_sampling_freq_avail;
+	const int n = data->chip_info->num_sampling_freq_avail / 2;
 	int ret, prev;
 	int i;
 


