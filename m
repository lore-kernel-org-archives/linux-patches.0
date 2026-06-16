Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F734418D7;
	Tue, 16 Jun 2026 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630074; cv=none; b=TNFEPehDqAhsdgafOY7Af55UqfA8vmjnNj4R0BIUrb8A0Y0XRknPWh1DOrmxZMrAUyJ/CoSuKJk3KtiBB0YmuZiIsBU/rwWkpz2MpkIDskfitad0YDY7JQg3H4lmksSx1428FOkft1Ctkrx4ul+upGXZKl1wu9FPZS9VElNcVLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630074; c=relaxed/simple;
	bh=jRRlUi6OMMru6j2UeIkb/wMDCjPSFy4CiuAlCg8L3zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myQDbcq/U6PmtgH53UPAWtfdXHWMVPvmTHp0xO/ucTqIi1I8ArfBX7EIDCKaUNp6KsFo9qiKxsxDCv6n6ZMJ4MR1q7r4wSNbeXOY3WopzzWV6ieD9Kgl3fbABdIYAMJj4uSyBhwhFQFh326kFQLtdTzMmK5FzAwq2e5jb2ifhZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za3rMzce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za3rMzce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463871F000E9;
	Tue, 16 Jun 2026 17:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630073;
	bh=rAjQamoMAo73a5s0mBJz6r2GWk69nKcgBksB0KH7e4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Za3rMzcev3DnuaaDRJLNdUy/e4qY2dgPEpdUxkGn5uUyppOGVE2yoyEdOZUkVG3rJ
	 OMZTS7hc+jwiZ3TRD72X/1k043PLhB5BKlW9yKhcKJXY1Iy8kV3h05uajqJAwDaJC4
	 kFKllcrRj7UdAZtBLFHjKCgSSrns4YSv4XEVuKYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/452] serdev: make serdev_bus_type const
Date: Tue, 16 Jun 2026 20:30:31 +0530
Message-ID: <20260616145138.052489056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: "Ricardo B. Marliere" <ricardo@marliere.net>

[ Upstream commit 88cddfb7bf23b06876da6c3e9f296e666d0f6332 ]

Now that the driver core can properly handle constant struct bus_type,
move the serdev_bus_type variable to be a constant structure as well,
placing it into read-only memory which can not be modified at runtime.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: "Ricardo B. Marliere" <ricardo@marliere.net>
Link: https://lore.kernel.org/r/20240203-bus_cleanup-tty-v1-1-86b698c82efe@marliere.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 375ba7484132 ("Bluetooth: hci_qca: Convert timeout from jiffies to ms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serdev/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -441,7 +441,7 @@ static void serdev_drv_remove(struct dev
 	dev_pm_domain_detach(dev, true);
 }
 
-static struct bus_type serdev_bus_type = {
+static const struct bus_type serdev_bus_type = {
 	.name		= "serial",
 	.match		= serdev_device_match,
 	.probe		= serdev_drv_probe,


