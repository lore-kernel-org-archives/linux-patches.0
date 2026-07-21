Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EA8470429;
	Tue, 21 Jul 2026 18:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658656; cv=none; b=XSmFXEhVf5cjsMHem5PMe9m63vwP4yStNzazy3j3s9YFz1IuQ/fwm63frirUVsxtd3/Wyzpsk2gGLuwzJyr9NmYrLzLqOtZZmYwVruWkNHo5eBf7euLjgkQFP7JK/NbuXqcnU8WfR5+xv/s/AY9ohwe54Ded0r4IChwBrKyzVS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658656; c=relaxed/simple;
	bh=Czn5c/QwJozBP1jYDEiSrhsvSz/wR41/dGp/9rFHtWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6sp9Z92SyPUZcM6dkFuh4j5pI9vxqS6R4lU7Xr5KlgaHdWNzPdcTugGnqjS3QRVEg+1+Y9L24scMDOY4R2LmbeV41DV8zpkSdcQJEvbmgfjPNRnAiG+YWIrCUs3HwOZvlE6nr+T3xvRW5Eh3KwPigRxBdJi1Zd2lR9uRzNdZDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTAgOy2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTAgOy2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCC01F00A3D;
	Tue, 21 Jul 2026 18:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658654;
	bh=qGH3FFdtvrWe6KmoX5Qqt7GsLKlla8EORkyBhLOBYxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTAgOy2REJfqUHaGK7MyfY3Ly8lWQolMk7vmg7WYIkyqwQRrzdGdo9byEV8wkjXiY
	 69ReoqXg4t5QsFABhSStamNP2iFbgqZz8CRI646XIras2ibIsfevu6QiBlj85h1bSH
	 vEOOqPoDEiIC2id4hB7A2MoUnGanyYk0DpK35WSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levente Kurusa <levex@linux.com>,
	Johan Hovold <johan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.18 1225/1611] MIPS: ip22-gio: fix kfree() of static object
Date: Tue, 21 Jul 2026 17:22:21 +0200
Message-ID: <20260721152542.990978931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


