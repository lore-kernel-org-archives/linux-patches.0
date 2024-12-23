Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7616912D1F1;
	Mon, 23 Dec 2024 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970197; cv=none; b=SUQ96udF4Mdw+eCEpi/LhGAgS1lwQhVHNQxhP4KmJBliaLTBVNOjYnvu9+7FCyDC/q/CpbI+BxBDnmSCLqvuVb7HHQsxKivBQhQ6D92GN+ogyXjDmLIlCYTjZNKysLT6kTKk8L++v2WnKypCNIL3HTs8Wr0snlUTkzh9fn1be9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970197; c=relaxed/simple;
	bh=gR9jEeM6bO6MqLwooFV5h6KRhXev4G1t1Y5MKagtcmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alcHaXl5ncPcs9t6BSnUNjyewJ7wJYF8NwnasrM7e4kBwjyYiUssuLHWYtbHNDC8Ffj6Vxx8lBcjYUx3C9M43PuNlTmNeJr0nrKvpitw65C8dSTyEQO7BzFtYsCodcMk/EVEXoOm1Sq3WkXLy+ReXycySizrGz9K/4xKGMowox4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZ+Wi4Ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZ+Wi4Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D988CC4CED3;
	Mon, 23 Dec 2024 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970197;
	bh=gR9jEeM6bO6MqLwooFV5h6KRhXev4G1t1Y5MKagtcmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZ+Wi4AefcrB36wo/oKV+3eU252YDfA4eSss11l7hdMbTtoZPoP/hp46ZBWIQsZ03
	 o0IGvhC2uzXnsxJpFH4H6D6JNxruhtjw3kmci3caShQnMGHATQAm9MqLGKqLi8T7dd
	 pFwwkA+Yzr/L8Lz9N0zjJA5bpxCGK/MyKgI23fWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/116] platform/x86: p2sb: Make p2sb_get_devfn() return void
Date: Mon, 23 Dec 2024 16:58:03 +0100
Message-ID: <20241223155400.057672763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3ff5873602a874035ba28826852bd45393002a08 ]

p2sb_get_devfn() always succeeds, make it return void and
remove error checking from its callers.

Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240305094500.23778-1-hdegoede@redhat.com
Stable-dep-of: 360c400d0f56 ("p2sb: Do not scan and remove the P2SB device when it is unhidden")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/p2sb.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/p2sb.c b/drivers/platform/x86/p2sb.c
index 053be5c5e0ca..687e341e3206 100644
--- a/drivers/platform/x86/p2sb.c
+++ b/drivers/platform/x86/p2sb.c
@@ -43,7 +43,7 @@ struct p2sb_res_cache {
 
 static struct p2sb_res_cache p2sb_resources[NR_P2SB_RES_CACHE];
 
-static int p2sb_get_devfn(unsigned int *devfn)
+static void p2sb_get_devfn(unsigned int *devfn)
 {
 	unsigned int fn = P2SB_DEVFN_DEFAULT;
 	const struct x86_cpu_id *id;
@@ -53,7 +53,6 @@ static int p2sb_get_devfn(unsigned int *devfn)
 		fn = (unsigned int)id->driver_data;
 
 	*devfn = fn;
-	return 0;
 }
 
 static bool p2sb_valid_resource(const struct resource *res)
@@ -132,9 +131,7 @@ static int p2sb_cache_resources(void)
 	int ret;
 
 	/* Get devfn for P2SB device itself */
-	ret = p2sb_get_devfn(&devfn_p2sb);
-	if (ret)
-		return ret;
+	p2sb_get_devfn(&devfn_p2sb);
 
 	bus = p2sb_get_bus(NULL);
 	if (!bus)
@@ -191,17 +188,13 @@ static int p2sb_cache_resources(void)
 int p2sb_bar(struct pci_bus *bus, unsigned int devfn, struct resource *mem)
 {
 	struct p2sb_res_cache *cache;
-	int ret;
 
 	bus = p2sb_get_bus(bus);
 	if (!bus)
 		return -ENODEV;
 
-	if (!devfn) {
-		ret = p2sb_get_devfn(&devfn);
-		if (ret)
-			return ret;
-	}
+	if (!devfn)
+		p2sb_get_devfn(&devfn);
 
 	cache = &p2sb_resources[PCI_FUNC(devfn)];
 	if (cache->bus_dev_id != bus->dev.id)
-- 
2.39.5



