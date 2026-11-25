Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620369;
	b=BmD1A2yuFCiqbm2LpmUY0cLlUZDP732czosB2yF1kCk8UCf/amswTc6eEJtd6cuZFRFH
	 oSeS7lkxei9P+tHu4/+byAHgNl6eMSf7jhYO/ltkJV8Vc2wH3MtF7ZA6tf8cutYomUMWL
	 Jd3TfksMPo6dqXVs2WUBVWkHgbIJu8cy6HxOZ9PwEjWKsE5dK3XSsI9X2UHV2jgruyn2z
	 +QsUTj/Vfmf+FQe5G3YYCjXoR7P8sTry0tc+cpCym9CBV6NeR6gCX/Lvt/WZJu1z6bkWf
	 5z1fljK21/zqyZli6/E4f65qxaTlmjTueilrHsUzB/u9Kr3JSU5eYoGSpeWZX+6trzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+XzefMYrsdYvQWPfDcWZMAKHNgpFTmvgQfocb3FioIQ=;
	b=EMhz59MMq5wm42v7W84kF+eGYhIgPoZzaM/xrCIyRSNts+LDEmQDPgXFxgCfhaG7ILCo
	 KFer9n8L+oNhC7ZJg0rPylMqOfaiCN5bZIdt9Lovz2Mg90dbP8RSPd3UNP39dZboVF0DE
	 w95PcnuD8jRTlvdM1pLssUhT8rfkI5LtHKDDIt2cHMWpS/o3LvZQkUoV4QWO6Nvy8tMUW
	 OGk+8KwvVcw+KMAxcOFv9LbpTBcqd+FyrXamCPu5vfBd+AiP2/SmQfWazgpc6FLiS8Lez
	 AlB9nFQHhY3XHUVhKV/0TOgUnrUZ5q8ihLq3fgqrPcuatY1dL9HDrmBlx+Wu95R+FDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03S4jAFh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF97606A31E;
	Wed, 25 Nov 2026 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03S4jAFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1961F000D2;
	Wed, 25 Nov 2026 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620368;
	bh=+XzefMYrsdYvQWPfDcWZMAKHNgpFTmvgQfocb3FioIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03S4jAFh3IexbMQ1S5+rPrsUtvnQRTukF91bIhMxGNUouX0IHWtJWpvnxoqs5cFvo
	 PRQrYyipIrap+YxdgvH8KgzIAItjVRY7xSnMu+M7Gf9/pvFcBxdfN48CCfbJqY4z/P
	 mCRTfgxheQkghUJKoA7A+lT3sRQpDPZremJqw5UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0895/1005] iio: addac: ad74413r: fix the values of set_multiple
Date: Wed, 25 Nov 2026 15:37:13 +0100
Message-ID: <20261125143842.661540594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -312,7 +312,7 @@ static int ad74413r_gpio_set_multiple(st
 			return ret;
 
 		real_mask |= BIT(real_offset);
-		if (*bits & offset)
+		if (test_bit(offset, bits))
 			real_bits |= BIT(real_offset);
 	}
 


