Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6327268FDE;
	Tue,  8 Apr 2025 12:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116161; cv=none; b=amXv03twaIlVPLIiFPrF0r1VgAGUURaPg0UZ5433X/tzCnkt0cgsLJvfvwZJw6IPc1N0U0+uoU8P6UhUHcTiFAbU8Pzi+iun0Kzyt78TDRgymoSB4pUTJ6qEbQizsB+0P3ksKJiaI3JaCZMYe+AcnVen3q10HHq1+GEJy5NzuYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116161; c=relaxed/simple;
	bh=A5ll7hZbNn6IytcjyAkLZCSBvzHfq6WX5sIKQoG0Tic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oH0n7NmkVNtFF6ihJFFqMksAw5IboqfcqPJ0CykONhCHTWHo7Pwj0+AM/CxrlR/XdaMAukB90dGRWp2rvzqSxgZcIwhOI/H8EjVopnj3Kl7uOKwh+CQqhrENg/h9a6ixtjBYC0Dc2DRn+PM6WFKoESgg1V3cdw3PkpDybEaW6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp3ddKfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp3ddKfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6840DC4CEE7;
	Tue,  8 Apr 2025 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116161;
	bh=A5ll7hZbNn6IytcjyAkLZCSBvzHfq6WX5sIKQoG0Tic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp3ddKfgz8GNrOocs335T9iqZ57E7LGGM76Wg4eJW1XsPtT9vNnFfF+XKTLoC1D7I
	 NfkHZj3kyTo0m7sXKCI3u6MWfrcGO8M2pum5zzJegQB4EGY4g0CVahjyHjfV1Y/RiX
	 dplyv0lZoWcGb03pz5b17Co8wIbkc0c2igNRuIvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/423] platform/x86: lenovo-yoga-tab2-pro-1380-fastcharger: Make symbol static
Date: Tue,  8 Apr 2025 12:46:03 +0200
Message-ID: <20250408104846.614089874@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 32d9b6009c422..21de7c3a1ee3d 100644
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



