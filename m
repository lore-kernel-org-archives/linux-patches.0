Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6592C439904;
	Tue, 21 Jul 2026 21:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670044; cv=none; b=h5iBwoV6bKssCXExobwdmZqy0IzcgcwfZvhiJoDcPjN3iy3eOELc6xFhBPLUJUzO6dKRTqLSXZjWsYhIq+7yBb4wxljcRJ3SGGJEEqtYCqQim3ChDGhgepygIS0tuvw3N/gt4sRSEm06Y2Fp4bFWXw3FVQpltTrPU5Ba3VbF1is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670044; c=relaxed/simple;
	bh=/kKRyoR0qSa6ZukkbqZ/sTsuGnYjlP9TjrLEpYdsm8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enNnHJShUFDRwndTMeeRy5sxrHYGqdJmLpmRCBlyqamI7VNc3XmQIqzJAo10y+f6wRlyiXGFHrnsdV3q3yHKkETxp4DzxBZ81x1uO76/6gO7dn9G+GAC9xv6k1/3VtSmiY0O5OuGsQZ10YQ/yljRXDYzgnYruFbw7oYP7SwSnnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fH12DMv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fH12DMv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA12C1F000E9;
	Tue, 21 Jul 2026 21:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670042;
	bh=a7IHpFX+XbLRCVrUnwF+vj26yR7CFMD18scHVkwNHxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fH12DMv7rKCeJPmDB63Cvip6JrbXKIsG+x/PL9JJJxqUpMfs86QewS8MylKO96hP7
	 0FcGOIpbPTTbRMDyP0sfl2EoyG0DRK7FOJDm77CVWZsth3mxHgALgTTa8tjRMOh5YF
	 UO0Iqs0a4WjaaittODejpvbHHUsA2qbDzMkotdHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levente Kurusa <levex@linux.com>,
	Johan Hovold <johan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 0782/1067] MIPS: ip22-gio: fix kfree() of static object
Date: Tue, 21 Jul 2026 17:23:03 +0200
Message-ID: <20260721152442.063883753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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


