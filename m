Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0461A5A7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkzV8u5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5847DC433C8;
	Mon, 16 Oct 2023 09:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446871;
	bh=fz8Xh2GC3tB3+KQSxDfDO2ib+nyJx/y5hO2jIhERcQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkzV8u5MW8M6NSyBR8+2g6XLKKV8t28lmFmjVRHKvasM7Te5TNVFS3ajuubnATgkS
	 l0Py5+hM6uJECAC3oCqkP326v35AJOPc7WR0KODB7+VOl8JHGctmn+Ru5fGC71xiGv
	 /yzN9iNBZX6+5dY66GIRZ9SO0UNRZXwP6t25t9O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 084/131] iio: admv1013: add mixer_vgate corner cases
Date: Mon, 16 Oct 2023 10:41:07 +0200
Message-ID: <20231016084002.146522966@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 287d998af24326b009ae0956820a3188501b34a0 upstream.

Include the corner cases in the computation of the MIXER_VGATE register
value.

According to the datasheet: The MIXER_VGATE values follows the VCM such
as, that for a 0V to 1.8V VCM, MIXER_VGATE = 23.89 VCM + 81, and for a >
1.8V to 2.6V VCM, MIXER_VGATE = 23.75 VCM + 1.25.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230807143806.6954-1-antoniu.miclaus@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -351,9 +351,9 @@ static int admv1013_update_mixer_vgate(s
 	if (vcm < 0)
 		return vcm;
 
-	if (vcm < 1800000)
+	if (vcm <= 1800000)
 		mixer_vgate = (2389 * vcm / 1000000 + 8100) / 100;
-	else if (vcm > 1800000 && vcm < 2600000)
+	else if (vcm > 1800000 && vcm <= 2600000)
 		mixer_vgate = (2375 * vcm / 1000000 + 125) / 100;
 	else
 		return -EINVAL;


