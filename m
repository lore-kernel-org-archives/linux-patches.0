Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFD5195FEC;
	Mon, 21 Oct 2024 10:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507654; cv=none; b=qXoJDXKLCIxAg8KDSGZFZbEWELJG7/gdCxEbXqcSVqY2rErTHZbweOIE5P3hYORg19Cw23AMvpLp0B2JiwhKoSAzVSLaOu3VNw3AEIE27nDBwnV8CL71eT8RJrPMlmAlSZt9Qh+xxQRuzp00GD5DVC4KdczaCT/Hw/wpOKPp6ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507654; c=relaxed/simple;
	bh=Y9V+/oRcX7GMg9hOXrhJZzlu5J8midIBEurIdAfhouA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhDD2xxJFYjbY9m6a7kM1HOYA/BYUwYGfBABecDDNWfPUBQ/Dxg96Tpkn267+A9+jzuYVqPKS3DE3FLM/42U0si8jLkGtqhWHVaACw9AnGRFsOJUWQj1H6340+JpdaQ9Wv2t5at/kzESw6LFnozRDQ+ZgOo/XuLzPid9OKI6Nn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKduNQzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKduNQzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C44C4CEC3;
	Mon, 21 Oct 2024 10:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507654;
	bh=Y9V+/oRcX7GMg9hOXrhJZzlu5J8midIBEurIdAfhouA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKduNQzqnx00DHqh/UZGnVnGcBQExyWq3+rgSLrF0z3MeRA2N/WoeHx3YkbAYACwa
	 GmUsQL4OKml0ch0zXvbRpD6h4pfx34SXCx2rCxnfaa81HJAXZAGJr5q66B1zNVS2Eg
	 mnvUFNirN8aAChniETsxuGNXd1iz2CAfHLYNStQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Gedenryd <emil.gedenryd@axis.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 58/82] iio: light: opt3001: add missing full-scale range value
Date: Mon, 21 Oct 2024 12:25:39 +0200
Message-ID: <20241021102249.524153631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Gedenryd <emil.gedenryd@axis.com>

commit 530688e39c644543b71bdd9cb45fdfb458a28eaa upstream.

The opt3001 driver uses predetermined full-scale range values to
determine what exponent to use for event trigger threshold values.
The problem is that one of the values specified in the datasheet is
missing from the implementation. This causes larger values to be
scaled down to an incorrect exponent, effectively reducing the
maximum settable threshold value by a factor of 2.

Add missing full-scale range array value.

Fixes: 94a9b7b1809f ("iio: light: add support for TI's opt3001 light sensor")
Signed-off-by: Emil Gedenryd <emil.gedenryd@axis.com>
Cc: <Stable@vger.kernel.org>
Link: https://patch.msgid.link/20240913-add_opt3002-v2-1-69e04f840360@axis.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -139,6 +139,10 @@ static const struct opt3001_scale opt300
 		.val2 = 400000,
 	},
 	{
+		.val = 41932,
+		.val2 = 800000,
+	},
+	{
 		.val = 83865,
 		.val2 = 600000,
 	},


