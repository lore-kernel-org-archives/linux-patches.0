Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E7470123;
	Tue, 21 Jul 2026 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663670; cv=none; b=iH3GW1x8CkKaV3JfkXsTvUBGoz6/FUsO03JBmcVU9sp2Ub9dm/k+huOuY21Sv4vGeYuqJ4uigPmPmM+aLYSNNIiSNkdcEu69F9XlYrmqbcLvmy5VJK0LrF4c0L1NF3A7EY+UoPhfrTw44nqhElht1mW7YBKyXBMURVeczSI1+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663670; c=relaxed/simple;
	bh=7n//phQzOKk+BwrYR9uMBHmY3B4c2Pz1ayB4cIL2V64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+PK+EfKL6lOUAy9tiCcEPe+CBmTKtSbaPFq1N4ynBrwrOOSe4Z1rE3BXlUZwM31NulNgA8W/fcQUbJrU390EZ/1tGNnIuDFD8u+47e4fgOTTN3qUs95rTFBLz8Y3iWrLXQBoWPtpqLhG6VGhoTwRGT/O3OBkVEtrW3oScWkRJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM6PfOWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM6PfOWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C37A1F00A3D;
	Tue, 21 Jul 2026 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663668;
	bh=qH1zYFYZGJdJFdTmUAifARmPnYjkj8hboxH0C2UbtK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qM6PfOWQ/yO9IgpiM/DL78qW6oCgmou5qgwo5OxiH7iRVCfMERoU2d8V13PveGmFw
	 EqVHc8Lp9iGSXdFw7MhvXuJUEKors+DUffjw+i8nI8XGox+0aty9T4x7thmKveHk3h
	 yzutNkSPEmYU7JUlXXvkAaqk8kpY1xUmLy/3qdYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levente Kurusa <levex@linux.com>,
	Johan Hovold <johan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 0909/1276] MIPS: ip22-gio: fix kfree() of static object
Date: Tue, 21 Jul 2026 17:22:32 +0200
Message-ID: <20260721152506.377062641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


