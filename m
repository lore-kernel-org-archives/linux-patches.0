Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B39E254863;
	Mon, 12 May 2025 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072604; cv=none; b=kb3wCCY70yjAIX9L18/XbXy+qEDdbKLmZKPPS93fNsRmqrihHogpxNRpWrHsenTS64FVm8OcCrzQygpqA+Id5xqUjA9ioeC9LT6kWfWyDslLFONxRcwzzrVvIdsf2rLNNTm8fZFBSqlOXiNzVusV4Xm5JwekkJsNsF2McCtLhaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072604; c=relaxed/simple;
	bh=Vr8FwFvoPymV0pmie+6Rg3DnaRVr6Og9LczwK0vhCDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3qM/rUJszqZ9kWHCd8buYP59W+lBPdlCs41GIoX14qfaajfGR4oAVSUM9mPB1GTPHBBpYngRcms9dGXksXAvK8UCYOlqrYloXmB2bzl+Lz1b6wGKkSUmdKLXHaihSxsDYGjieMnOdShI7RvbSGK67r1NfuBookFLwG73IkXle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BmA/xKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BmA/xKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D470C4CEE7;
	Mon, 12 May 2025 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072604;
	bh=Vr8FwFvoPymV0pmie+6Rg3DnaRVr6Og9LczwK0vhCDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BmA/xKM/g/Y97diPi5TvqN4mMEOyCXyiTD0jv9dUFInLFuBQFU+ycBFI1OBXj1If
	 WaFX/geHB/1tLeFVtenGODPNzcY4CwmYbxjmDKfVkyzXGJlHpj4Wzdq9iWaSqQiK6v
	 zAXBukEuloEIOKqxYtxd6kctnwvKDWaoJi7Q4FW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 63/92] iio: accel: adxl355: Make timestamp 64-bit aligned using aligned_s64
Date: Mon, 12 May 2025 19:45:38 +0200
Message-ID: <20250512172025.681598272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4bc648eac8b29..e73573cd773a4 100644
--- a/drivers/iio/accel/adxl355_core.c
+++ b/drivers/iio/accel/adxl355_core.c
@@ -175,7 +175,7 @@ struct adxl355_data {
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



