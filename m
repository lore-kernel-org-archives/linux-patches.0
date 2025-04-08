Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AB926B2B1;
	Tue,  8 Apr 2025 12:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114389; cv=none; b=T5K327+xS3ExIdYbNpUzrt0/+41X5WAFBlufzgSNcLxonPx+ySlAGh77pRjB2A73abcZ14njAQi/rV7Y2F/OIttNnu/l85XqoH9NzKlzxrx/SCDgUYzCXpGICnA7y9D8i0F0UYIHsQXhePJZL8GLW3KPSJKbURCsJMG2qdu5fRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114389; c=relaxed/simple;
	bh=3cmOViJzCiRVUrkrN1kKuBoanjhTf9mCably8v9BUTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iqbRf2m/pTNFJYxoaqxppUT5xF20lK6pzPMwLiiqEre+A9prr4vke6cY2zwuxqWlWHVsWbI+kwOnuhR58jS0PyyZnXzYeRRpKfHWOBvdNMAHPgiaQNHZYG2eo9vujzqiQqEH1/WRdjLHIgTCn36PeaJXgjpw6XoVFGZw5RjuB+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8K6Mqi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8K6Mqi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE11C4CEE5;
	Tue,  8 Apr 2025 12:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114389;
	bh=3cmOViJzCiRVUrkrN1kKuBoanjhTf9mCably8v9BUTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8K6Mqi79o0aDooP9K84PbLjztkS0v9GFZq0edKHoNtpiYQGuZNHzvrNnkalDsDYd
	 uvaxSiyOKY8MEcC5q3NklTIHllBCHu7NJ5nBhNna52ynF6KrBeb6GlvuEWwAnhQQSi
	 FDkR2DCNYXpjkariNbUIDRzq9hWb8pG3ekw2s9Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 048/499] platform/x86: lenovo-yoga-tab2-pro-1380-fastcharger: Make symbol static
Date: Tue,  8 Apr 2025 12:44:20 +0200
Message-ID: <20250408104852.441089542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 886ca11a0c70efe5627a18557062e8a44370d78f ]

Sparse reports:

lenovo-yoga-tab2-pro-1380-fastcharger.c:222:29: warning: symbol
'yt2_1380_fc_serdev_driver' was not declared. Should it be static?

Fix that by making the symbol static.

Fixes: b2ed33e8d486a ("platform/x86: Add  lenovo-yoga-tab2-pro-1380-fastcharger driver")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250304160639.4295-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c b/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c
index a96b215cd2c5e..25933cd018d17 100644
--- a/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c
+++ b/drivers/platform/x86/lenovo-yoga-tab2-pro-1380-fastcharger.c
@@ -219,7 +219,7 @@ static int yt2_1380_fc_serdev_probe(struct serdev_device *serdev)
 	return 0;
 }
 
-struct serdev_device_driver yt2_1380_fc_serdev_driver = {
+static struct serdev_device_driver yt2_1380_fc_serdev_driver = {
 	.probe = yt2_1380_fc_serdev_probe,
 	.driver = {
 		.name = KBUILD_MODNAME,
-- 
2.39.5



