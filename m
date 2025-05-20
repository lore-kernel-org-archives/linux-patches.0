Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9861522D7A8;
	Tue, 20 May 2025 13:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749212; cv=none; b=dpir87EUexvgY11uyJ8MJPy1SEzeKe+AFII6lWj87gwL7M8B5ttD3UCHz3u8lIpbYJKjNbpIJ1lDR2CFdb1RQOE4j4PSUkrqDYbjmbJtOxKnh2HINf1uIAoHepUU72ir/EYywJmwwb3iMgbvTrZ1Aze9nqv9P3b8h9Ue5zbh2fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749212; c=relaxed/simple;
	bh=Kkjb+Dhtn7Xdw3WVmUwTGjrzxM9VSOOa3Vj6a1XzN7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4PtTzBG6tDKCPzDN1usYgJEnLJgZEqFLa8xfE707ciixyqf2Q4CKes9o1RZr9zfHaHD7px3+x1talPdQOT9PXQPF7LAXNUiA/RpXUhffETtxe5arV/zNOl4g0itBch2yktscpAxaoUql/2mh5kRKr3QQOGwX9LNXWRNSll8NSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joZPO+Lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joZPO+Lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2A0C4CEE9;
	Tue, 20 May 2025 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749211;
	bh=Kkjb+Dhtn7Xdw3WVmUwTGjrzxM9VSOOa3Vj6a1XzN7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joZPO+LjjP0lR7ZI7rBf3Zeidi/RiYvuvao9USXSlaq0FcHqLLPfcu+E7tVHdM6Tt
	 Lb49KH6XloLdhA77SqR+KvT3/v/h6G3iuh1i66DecZ1rFoPc4ZuBztknQ3jxgyTfjh
	 AohvrEV8tD5ed+AOPqyDDjotuDEGyDADJxc8s150=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/59] iio: chemical: sps30: use aligned_s64 for timestamp
Date: Tue, 20 May 2025 15:49:55 +0200
Message-ID: <20250520125754.013566906@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit bb49d940344bcb8e2b19e69d7ac86f567887ea9a ]

Follow the pattern of other drivers and use aligned_s64 for the
timestamp. This will ensure that the timestamp is correctly aligned on
all architectures.

Fixes: a5bf6fdd19c3 ("iio:chemical:sps30: Fix timestamp alignment")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250417-iio-more-timestamp-alignment-v1-5-eafac1e22318@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/chemical/sps30.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/chemical/sps30.c b/drivers/iio/chemical/sps30.c
index d51314505115e..43991fe2e35bf 100644
--- a/drivers/iio/chemical/sps30.c
+++ b/drivers/iio/chemical/sps30.c
@@ -108,7 +108,7 @@ static irqreturn_t sps30_trigger_handler(int irq, void *p)
 	int ret;
 	struct {
 		s32 data[4]; /* PM1, PM2P5, PM4, PM10 */
-		s64 ts;
+		aligned_s64 ts;
 	} scan;
 
 	mutex_lock(&state->lock);
-- 
2.39.5



