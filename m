Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D3E629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ED9C433D6;
	Wed,  2 Nov 2022 03:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359796;
	bh=JjeIzlE8eQaGHGfa3JuPbJB+POP7qOf0td7u3hlJGZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoCEOwPC5XChytIJwycRzJdlou+HPjz3vKpqKpPnPJGU6RnGCHkebUIec0Rd/ntRZ
	 94T78PvecKnBl3Iga0mosZ3Lj3gVu1ojF678hFbj8czupIFQdI8N1pBR1lowkRFlJo
	 Gm7uf2ceSkjEh3y8Ot0ZAZL90LrHg6DX8lR0isHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 35/78] tools: iio: iio_utils: fix digit calculation
Date: Wed,  2 Nov 2022 03:34:20 +0100
Message-Id: <20221102022054.024975091@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 72b2aa38191bcba28389b0e20bf6b4f15017ff2b upstream.

The iio_utils uses a digit calculation in order to know length of the
file name containing a buffer number. The digit calculation does not
work for number 0.

This leads to allocation of one character too small buffer for the
file-name when file name contains value '0'. (Eg. buffer0).

Fix digit calculation by returning one digit to be present for number
'0'.

Fixes: 096f9b862e60 ("tools:iio:iio_utils: implement digit calculation")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/Y0f+tKCz+ZAIoroQ@dc75zzyyyyyyyyyyyyycy-3.rev.dnainternet.fi
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/iio/iio_utils.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -546,6 +546,10 @@ static int calc_digits(int num)
 {
 	int count = 0;
 
+	/* It takes a digit to represent zero */
+	if (!num)
+		return 1;
+
 	while (num != 0) {
 		num /= 10;
 		count++;


