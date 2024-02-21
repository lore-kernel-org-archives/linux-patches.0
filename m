Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6F053816;
	Wed, 21 Feb 2024 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521211; cv=none; b=ABd1otd5+5AFxpj5xAeBQizp/lyKWEHUmwVlxAg6hFY2ITqqHA1iccSxuLg6hjn43K6i1I9dPDKO5QHWC/+zj3fxTA+B1eZQvBfdIKibnhZalcolgHdeS5Xg0JG6xmM0yROby/IzU2tqnMfzLtUHEth/Rl+lReaReCKuoYpoV9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521211; c=relaxed/simple;
	bh=8mRdwK5WYP6W4h9WizjksS3g3ltaV+vMqDwT7fVSN+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbn3VIEL8Vngemn67PFIlM0jxhYmOOA4sqc9h9Fyfc7/W4l5OOQslgHO/7TQe4SJvem3HGiQLkzzfZm2RT+cM6fxOM727P/W3DtK9ZmX38N5SRhx3V/9GPjJLAM3AjeySvbypR4fj4C4FMsFcezOXo3j86gGSHqFZc1EAX0UIvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thLdHVAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thLdHVAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A30C433F1;
	Wed, 21 Feb 2024 13:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521211;
	bh=8mRdwK5WYP6W4h9WizjksS3g3ltaV+vMqDwT7fVSN+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thLdHVAyusZx7217Jl+azIcO2oaaSq1AryjbEkW8JJjgqMfP56rq1LfTnJxw/d7/e
	 LdlzMf6BSs2Rq2kPrGuC3/undzTvMok8C4B3siifpi4Q3/+q3q2qpQnlOVaOLH/EFF
	 zAWyAtqdrJzYq/v4rsTPfwXzKvXuCC5n0fgtBstM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 020/202] driver core: Annotate dev_err_probe() with __must_check
Date: Wed, 21 Feb 2024 14:05:21 +0100
Message-ID: <20240221125932.409208356@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e1f82a0dcf388d98bcc7ad195c03bd812405e6b2 upstream.

We have got already new users of this API which interpret it differently
and miss the opportunity to optimize their code.

In order to avoid similar cases in the future, annotate dev_err_probe()
with __must_check.

Fixes: a787e5400a1c ("driver core: add device probe log helper")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200826104459.81979-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1582,7 +1582,7 @@ do {									\
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
 extern __printf(3, 4)
-int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+int __must_check dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \


