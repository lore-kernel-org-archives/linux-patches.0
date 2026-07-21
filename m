Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66913B95E0;
	Tue, 21 Jul 2026 20:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667316; cv=none; b=Xs+xuWTOQWCPThN/cd2/eK7WZ/RGhC0pZJqjUKevOFExsQjz+RA9I8aDQxXxqKUTwkyXMrRPuOoGrwkt90IajND6qQxARFll5N4IvDBvARwTHN0xk9RlUhwk0l9jv+5kFOomkMyBEaguJ+HYcyyhvSWy9LjEOy+fwtPScUC3/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667316; c=relaxed/simple;
	bh=YBghbDHUaWzUgR28de6nfDa2XfqHe3+eTrqAFcLUGi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl0DuM+fmTUrgnhtCCMQibSbZX+RqGzt0wfuXTwHonhY8tYdHCGuIC8RGXQEsVFNLrqBb/Sdj0ronfiMvPjl/lwHcDLUl2N30Z1mRGjzRfgtvVHEE6Y/8817aRJy95c/91TaSbzMDgNlpgohGaLIhNYWrwkXBrP8iMrOjFMrBZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQv0caBB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQv0caBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129611F000E9;
	Tue, 21 Jul 2026 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667315;
	bh=Z3+I9VUTagEXxehf88k2bmSPQFSDUH/8qdGPSo5mfeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQv0caBBcvodEkcovzf5i5vh9rgw3J/d2io277teH2jBuxTyURmMMi2C4Wvt/53Ug
	 ht2FOhTBZOtyxJkEpqA5q98ZHRzp9RvlSbRVLBOUWN8wH+MJyPXay5fvuXt3kTOp8F
	 74HWWQciQkv7tFml02CYF+/9iFWFVIjTOkqmcnV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levente Kurusa <levex@linux.com>,
	Johan Hovold <johan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 0971/1266] MIPS: ip22-gio: fix kfree() of static object
Date: Tue, 21 Jul 2026 17:23:28 +0200
Message-ID: <20260721152503.562402462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


