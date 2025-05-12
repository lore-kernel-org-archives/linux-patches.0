Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C180297A76;
	Mon, 12 May 2025 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073127; cv=none; b=uDxkOtbz6EwFUxS9CttXn0uTS524P0FkQOnip9pu8fOGxyG3B3rZEEHn7MexGL/Qkul0sIv+JujgGo/MBeCRcZHs/bEw2q8e/An0nsAR4URa2TSe1VjHnZyQcSCZRzh97SEZGgEtyO/EHaul4/jo8N+xp+gJ34BxjpKdmu1e1dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073127; c=relaxed/simple;
	bh=MX3xLzgEhdX7bcz/sY6cCvVHneGXLgqNEPSjPqEwE6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FkYszEdrHMTXHP/g4cnb1lXvbm/ZfMfySm5d4fTUmR0sWW3ersBL0Io+Ed5nb6YSH26X/0ikZ9CnX2I+9pzXRGJ2x6wXGfh3tlBP4aGc0xKfY7yD5UkAVo7r9AIpddIqUCIqN3gDelgp5wzj7SzAwSECiBcAKp5nG4iSiopmwrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBsN/6W2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBsN/6W2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C283C4CEF0;
	Mon, 12 May 2025 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073126;
	bh=MX3xLzgEhdX7bcz/sY6cCvVHneGXLgqNEPSjPqEwE6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBsN/6W2N6fT1q1/WlDmAnkSLYk6syOiA6p9nPKmQ0YwjqVrQrQWko+cefWEm98dq
	 Qbk5hv/LxzG3owG8sLfsk6mkF7AZuuCgidXAWF+/Uo4MoOaiTd+TTHcpMNP1zohnlS
	 jHHHqCcDTJAhfPzj/sL+/1CpaY0aBQhv0m03Jp2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/184] iio: accel: adxl355: Make timestamp 64-bit aligned using aligned_s64
Date: Mon, 12 May 2025 19:45:34 +0200
Message-ID: <20250512172047.233535868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 1bb942287e05dc4c304a003ea85e6dd9a5e7db39 ]

The IIO ABI requires 64-bit aligned timestamps. In this case insufficient
padding would have been added on architectures where an s64 is only 32-bit
aligned.  Use aligned_s64 to enforce the correct alignment.

Fixes: 327a0eaf19d5 ("iio: accel: adxl355: Add triggered buffer support")
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-5-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl355_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl355_core.c b/drivers/iio/accel/adxl355_core.c
index eabaefa92f19d..5e1946828b968 100644
--- a/drivers/iio/accel/adxl355_core.c
+++ b/drivers/iio/accel/adxl355_core.c
@@ -231,7 +231,7 @@ struct adxl355_data {
 		u8 transf_buf[3];
 		struct {
 			u8 buf[14];
-			s64 ts;
+			aligned_s64 ts;
 		} buffer;
 	} __aligned(IIO_DMA_MINALIGN);
 };
-- 
2.39.5



