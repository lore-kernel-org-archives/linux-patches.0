Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF91B67E;
	Wed,  8 Apr 2026 18:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672177; cv=none; b=LAjaoUSiO/zWnENaMkC1XXe99vPMc2kl+1e8IevwCrTFAON2jgsmKCa5rvARu6yQ5R/NTVBipZDZSsA7xOV6Nz0irmRrQZ4YUWKWQdYtjrR3CfyXDUirtjM3EOl55+c4ncnoAV+EH5mQExCp9fmxRqTf+PiT/kxp7UU3lbgbgtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672177; c=relaxed/simple;
	bh=KJBkDsoqkJ8CgFCbkbrx3M16Ha2+mVbn2BhT4TFoDYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnvl9Iw/zOEgZNQdHRRgu14pXg3LF5A+yAWBJ9bPUIkMQBySb8Yop4ABgbJ3PESJOpbzNw49C9G6YaJfwf2/bN85dKKYI+8/L0wI8yHTkZC4My2qrI7am/ZFWs2DYRBRVpBjVKP+h9Hy9csgGSwInwBXj8FcwPf1A8Bsh2GIEDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsLOEiQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsLOEiQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61005C19421;
	Wed,  8 Apr 2026 18:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672177;
	bh=KJBkDsoqkJ8CgFCbkbrx3M16Ha2+mVbn2BhT4TFoDYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsLOEiQlE4abLfdesMP43HyYGiGuETDEUkB7/7yApKFCnDHhisfDtrZdyTZAEn+E6
	 PY4CBtqzjmHLtaQ96ri7YTQ3OCS0QPpNlToRYiVXIB3muu9wuekuxKknVnIF9944AV
	 Gb/ga4ftcnRSxcRlgOBl2/c3TyVGEA0Rr4PZHps4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 219/312] iio: dac: ad5770r: fix error return in ad5770r_read_raw()
Date: Wed,  8 Apr 2026 20:02:16 +0200
Message-ID: <20260408175941.937964259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit c354521708175d776d896f8bdae44b18711eccb6 upstream.

Return the error code from regmap_bulk_read() instead of 0 so
that I/O failures are properly propagated.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5770r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -323,7 +323,7 @@ static int ad5770r_read_raw(struct iio_d
 				       chan->address,
 				       st->transf_buf, 2);
 		if (ret)
-			return 0;
+			return ret;
 
 		buf16 = st->transf_buf[0] + (st->transf_buf[1] << 8);
 		*val = buf16 >> 2;


