Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F4B1FBCB2;
	Tue,  8 Apr 2025 11:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110434; cv=none; b=B+9LCKLwYBNdi6ZKCJoUf6ys884Lg+v+etP3n67MOscWsr1GXbhLffqd/EImGb09RCa7PISlDjCvpd/olSPN7ekKSqFU+TuXnURoO0FxBnTWXrij7gcvO+bF/vJKQ6G9NPGkbG8ajNYRZtzVBlVIGphvBEN0t5ueQHWnm9X2lyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110434; c=relaxed/simple;
	bh=gkXorPlmHLHelmY7yQijnNV9fgblR3NsCB4RtGxsMDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sv7KsXw8z7mU+tRHaIa0veMyw0lLOPvPS/cdqJ5PyvOxCqyKhgXAgFZ4G8eQ8sP+wOO+r7KQo8Ug74yPxoacGMjp17CgFk4yQ90zNGLTOuxHDz+5DshJfbMq0ceOT+4YHyPLpB1PVZu+CXPb81hHyMww7cMJG1xu76h22THy7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyWt6zGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyWt6zGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A14C4CEE5;
	Tue,  8 Apr 2025 11:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110434;
	bh=gkXorPlmHLHelmY7yQijnNV9fgblR3NsCB4RtGxsMDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyWt6zGkyMDQ+4hvuozpcBnhcXS9rqNAzL/FiWt/qUvDci4tOYuXnvnAJ0neMB9FQ
	 bdriBnyL3WsesdK63kJn8AwwnVKhrN5t3YP657XS6g2xwfBXfdb/1tt88VxsaLUkEM
	 auHfhlsYYyf2BZLyfXp0ukuWNNV2fwtDJ0cT+1HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 062/731] platform/x86: lenovo-yoga-tab2-pro-1380-fastcharger: Make symbol static
Date: Tue,  8 Apr 2025 12:39:19 +0200
Message-ID: <20250408104915.715006551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



