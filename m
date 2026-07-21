Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7413E43D51D;
	Tue, 21 Jul 2026 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672392; cv=none; b=huyD4kcIqh9qE0OWEEu29doid+ASiLMX1jaLRVaRBz4oJm9EjvDBXxbAY7bNgSha0VKK64WrH9DEug74j44hOUrbEBiDj26Vzme07roRo6XFsQOgNuniFuxD10G2rqyfSIm50EdjsFIrMeZsAxFEsnoFv3UhM7V+5cs/hIfv80s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672392; c=relaxed/simple;
	bh=1fl6kE0bHg9dl+W7uvdWlrKFs5a19aR4HGnf79rN+Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hgfcg8EYE6ChVBSxWCW8XK0shYMf+OU4xghS5hSXcrKEibyU4Sw489YOc5XGX7mHO5HaXg/eXbAAMBnEDA3lpxC/yeEcWBhu/hIGiwHvl5aaiRKBgxjWfEniGvMjythh7Ss3Er66SqNcH3jZaGOeDsdPOYazMulsYE377n8zP/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAg1OQHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAg1OQHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0321F000E9;
	Tue, 21 Jul 2026 22:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672391;
	bh=EMgaMrA6YpKP3cumHUACXhH3IcfllG5xqbWma4hoW1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAg1OQHYIUYr+S+HYVVlRe2igfwpSdwQyI/q0VNVeH9HgwVmlE9Wck10XqxnXba2S
	 LPNV28iDmKFXtPDG0K8BltDw6cgk4P48xZaIqZDWowhobLhLc/GV5FW22POMT8l//l
	 pFeKWTRNRYMauPs70txruH5/ePoZYtUmTLFjwMmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levente Kurusa <levex@linux.com>,
	Johan Hovold <johan@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 607/843] MIPS: ip22-gio: fix kfree() of static object
Date: Tue, 21 Jul 2026 17:24:02 +0200
Message-ID: <20260721152419.704499828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


