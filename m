Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB41E40587A;
	Tue, 21 Jul 2026 17:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654348; cv=none; b=segIw/9DoDVjV7Z3VOeXru7xZ2Lf51Txph0UuAXpDH7T/K5mQJmhmqDHC4P7qDQ2bmXfsP6T/lL3zMi23N8VW3MV5GFpVPunQ5zUZSK40R/VS1xsPv5hqV6lgmFJf6vc0F+VMYR1tEGAGLo6jZQQz2ZSXB1TEwwosLCd5lJF+Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654348; c=relaxed/simple;
	bh=KhBHBU+FTveB39bALWIhtHicsjdYlTHOcqkaMTkHAbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNzBsY02XsoxP6ZpOIXQ8xzohnTaLLYhA8S6ItSusHVoCH603nO4r3XK+haKqyAMdfgWtepSsT82kVfSayTasY3Vk7mQOyumK+K4pLlEXB6vX82fhPnFEdUcxdyPMdUgUjTfH6WyqJk/16fFZYchasUWKqXh+q1ATjZdeNvimeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4N/uV3F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4N/uV3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A41B1F00A3A;
	Tue, 21 Jul 2026 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654346;
	bh=qywigUS36CDyQ6GbrqpivApNsWt1F1MC3kTCv4aIA24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4N/uV3Fti+Hf8aF42jqG9wayIHy6pQ9NRSkVCooi9YwxSY8Bla/eBbRTNkXG79b2
	 x+dx7FV2UpWk0N1biWN07621w1tlphFVI7ievDJfkHpXLIiM42HSDVNneIE3aOTXhT
	 bS5QEhFz7l2eBC1bN0owTlPPD90A3CLtbIgDpzIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levente Kurusa <levex@linux.com>,
	Johan Hovold <johan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 7.1 1671/2077] MIPS: ip22-gio: fix kfree() of static object
Date: Tue, 21 Jul 2026 17:22:24 +0200
Message-ID: <20260721152632.156683323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


