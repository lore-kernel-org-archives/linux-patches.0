Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57860332EC5;
	Sat, 12 Sep 2026 14:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221611; cv=none; b=N/d6bdXhDbOJyWhgpjUjDcRhPB8+eas2MgefXjA5+NJnBi5cBprSx9xiGqAR9SQDJgG0klsMLDmrNGQW5GBnqJG3VG989oqPlPkeXzG9SQmnSJOT0X+1JpTvb3IKWNsiyHUag8CAkEN6bSHZABD14hwwbHt5utUzTe4i9O46xCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221611; c=relaxed/simple;
	bh=rlfHdE5OkyH7bqYu4b63M1q/fNrmB3eaYl04U2FyGu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POuERSazxvkVj2Ne85YDIgJI9KbhdBsDb7strhk1EaxMowXH6ioCF5JNOdJ3iwYiogIXa2IMC64iYeqj48PZ752DZc6JMp2Ur56CHanzA6enfxJJAf1cmLduE5o9O4UpGyMlm6ki+V40L4zcQCqdfsu2+YcB7Q9u7JM+t8Eqp3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/qaZ8vu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/qaZ8vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107DC1F000FF;
	Sat, 12 Sep 2026 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221610;
	bh=UmIhTN9YhwrBhGLBRIYi1GBn1ePYpFVmY9QXiIG+YZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/qaZ8vud9z+yMfL3MWbeSCi6hwrnY28hDKhKEWD9chOGiAKFEYO+B/66R4Q4EoDA
	 Ux+oj5qTxasLjaApKoYoGaw8GYNAzt6sda+ucl3kQzB1OgSg8c8GKthFPz7JfdPoFL
	 NNW4qeUWdGdUL0d9QivOXgDe2waoggaNAaXQiM88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgi@tchankvetadze.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0418/1424] iio: light: cm32181: return zero after writing calibscale
Date: Sat, 12 Sep 2026 08:47:30 +0200
Message-ID: <20260912065616.641136912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>

commit 8756acd30919a3e9f547ea4a1d4b7f7895f4d340 upstream.

The write_raw callback is documented to return 0 on success or a
negative error code.  However, the IIO_CHAN_INFO_CALIBSCALE case
returns 'val' (the user-supplied value) instead of 0.

Fix it by returning 0 on success, matching the behavior of other
calibscale implementations in the subsystem.

Fixes: 971672c0b3cc ("iio: add Capella CM32181 ambient light sensor driver.")
Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -370,7 +370,7 @@ static int cm32181_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBSCALE:
 		cm32181->calibscale = val;
-		return val;
+		return 0;
 	case IIO_CHAN_INFO_INT_TIME:
 		ret = cm32181_write_als_it(cm32181, val2);
 		return ret;


