Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A0333710B;
	Fri, 17 Oct 2025 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713703; cv=none; b=qApX2EsrvGzRjWJlW4SSr160crHPH1p3nkM2jDLWwOID/WB45itVHhUZQwiX+h6KBTr4tG8Pi9NCL/Hvj7T5GmtplCrpdmJIVPBKp1q3eEKPEwk9nTA7Jr6CErUljoj1cXXoxj91OFVEBljYslSyQoPacGk1lwCCkgv1Ty0TY68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713703; c=relaxed/simple;
	bh=6xyeBgczzkJTyq+LJg71GEA8ZMjkKOE3YNVc1gs3iEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSnxVwCw3WTfbxdkfvgk3AoK+77wIu+C2Sp+nM/2H0jMFem08YZnxvGBHMXnM6GkIIFGlSzPvCJNQqy7RiV3UzJzfW3fgfqLvp+0EPpo3kckGvJ3vjJkZG5Joo+SkfgsWmnklXp6IOJ9WcHOqScRHqQrihhGnPkXldBZWSO/78Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKN5JQAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKN5JQAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FBEC4CEE7;
	Fri, 17 Oct 2025 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713703;
	bh=6xyeBgczzkJTyq+LJg71GEA8ZMjkKOE3YNVc1gs3iEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKN5JQAix+4e6+wiMjwaI8OjaULEX0ZpK95N8r4XZDSzT331THDCNDz2/QAt54fVV
	 TG6eyx0A00Ntk+0050jp+ersWDrmeEYKE75iyye5LGhsW9kqEcquMklBlarB3TLYIK
	 5uK75eULGMHuvC7pbhWI2cIfkaEdd+C6zydnkdWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 091/201] iio: dac: ad5360: use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:32 +0200
Message-ID: <20251017145138.096514138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

commit f9381ece76de999a2065d5b4fdd87fa17883978c upstream.

Change the 'ret' variable in ad5360_update_ctrl() from unsigned int to
int, as it needs to store either negative error codes or zero returned
by ad5360_write_unlocked().

Fixes: a3e2940c24d3 ("staging:iio:dac: Add AD5360 driver")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20250901135726.17601-2-rongqianfeng@vivo.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5360.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5360.c
+++ b/drivers/iio/dac/ad5360.c
@@ -262,7 +262,7 @@ static int ad5360_update_ctrl(struct iio
 	unsigned int clr)
 {
 	struct ad5360_state *st = iio_priv(indio_dev);
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&st->lock);
 


