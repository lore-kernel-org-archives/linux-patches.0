Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B37C347BC6;
	Tue, 21 Jul 2026 22:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674267; cv=none; b=ON8qyf2XaCUNZ8OiFQRCpbIKZExXqr0KLUKv0VraB9VpzcS1svy9IoCmJ7UFslilGUgMDNqxkPOoWuqhmrO9r7Bji6170BnUucypnhtk+PJ7d5CaTkJKrjY1dxx4CbKrPvgNRPVyxTDqz7QJ9oBuKcXBFrV6sL8gBQznmKue4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674267; c=relaxed/simple;
	bh=i18x0nkGIk5+hLZdDNT/znp6csJvz/1oTUEDZhq9SSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laz0qPY/SO3IcfJNGVR7Vo4IVKlvPq7geZFSuCOalC4lyvI6XcU67ZYL7j2p0tPiexBy5GQ8aISypj+r38Br4UQEnznwqA390EKhqHv6fpGick6SGP8h4UnEPWgPLtr40w9DHHyNbXO2gazTAp0m7blo0hko1ff69IfaBv8NsS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kI7jy0nP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kI7jy0nP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911561F000E9;
	Tue, 21 Jul 2026 22:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674266;
	bh=Sq++AYZkjQR9OOjngF+ZL4llJBFxj2MEIFKWgXAXMdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kI7jy0nPqZu+0AwcFE92Bpr603eYPdxx3A++qU2B4dJOp05SBZQyWNqJm7X3+YF1n
	 9MC6p/UDrh+Cq5CDQgvyQmssYG0gP2YQolTZZTRkKLsBhedbowP3RYR4SOZQ8Gw55b
	 zbayLgxyKsnDV+wqUW023LGE5cLJPpX7aAd9Cbq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levente Kurusa <levex@linux.com>,
	Johan Hovold <johan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 476/699] MIPS: ip22-gio: fix kfree() of static object
Date: Tue, 21 Jul 2026 17:23:55 +0200
Message-ID: <20260721152406.436728569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit c62cdd3e919bdf84c37ec46810f87cdb1736e822 upstream.

The gio bus root device is a statically allocated object which must not
be freed by kfree() on failure to register the device or bus.

Fixes: 82242d28ff8b ("MIPS: IP22: Add missing put_device call")
Cc: stable@vger.kernel.org	# 3.17
Cc: Levente Kurusa <levex@linux.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip22/ip22-gio.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -30,7 +30,6 @@ static struct {
 
 static void gio_bus_release(struct device *dev)
 {
-	kfree(dev);
 }
 
 static struct device gio_bus = {


