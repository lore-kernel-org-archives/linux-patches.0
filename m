Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D7830649D;
	Mon, 13 Oct 2025 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367417; cv=none; b=o2oK7697CmeLX+Z7OBjKY8XBQxGqlRwZmGHPWzXqrc+OJd9MOEEaUhI4VhLclS50reCE7gXohe5MGpNH6bl+8bJ53SY+hsCglJvImLCeMsvvfx6DBS4sDrk4uLc/v2uF5ivU613LdSDaTSLTtSPh/2Zdj5j21lG+yi4PTxnzcx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367417; c=relaxed/simple;
	bh=SY5ANba5mQAEQ5B4+DJUpHnANAcVBNpxAE1wsIJsLl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgWzcWdrjCana/PjR0n/0BVG2OQ13AMaCSNWahOeWMiT56BBCBQ0qulY1X4WGlw3ohK8uKu51c8kSTy2AwDx7saCnFP0tJRsL42eBw0y6uNLjXaa+SDdvGOCqELOvLlnBRrz04LGzKiEzowpn1Bk+xXdJPg4wKiNBX3q5MIMKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygpVjzxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygpVjzxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5422C4CEE7;
	Mon, 13 Oct 2025 14:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367417;
	bh=SY5ANba5mQAEQ5B4+DJUpHnANAcVBNpxAE1wsIJsLl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ygpVjzxMeUtnn4KWoWOqgpyWt4fIbWi9CAgh83RBbdwU2FP4E8QehQP84V3sH6WgR
	 k9NW8XjFSPhK//7yvt4b1rk2j8jo09Zok3p5z67iwQNU+siESYUgNd+mdTpBcj13UP
	 YYoHGdoCKFFc6w4bSU8bD8fgrujTNyMulNYa6p+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.1 194/196] cacheinfo: Initialize variables in fetch_cache_info()
Date: Mon, 13 Oct 2025 16:46:07 +0200
Message-ID: <20251013144321.708322224@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: Pierre Gondois <pierre.gondois@arm.com>

commit ecaef469920fd6d2c7687f19081946f47684a423 upstream.

Set potentially uninitialized variables to 0. This is particularly
relevant when CONFIG_ACPI_PPTT is not set.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/all/202301052307.JYt1GWaJ-lkp@intel.com/
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/all/Y86iruJPuwNN7rZw@kili/
Fixes: 5944ce092b97 ("arch_topology: Build cacheinfo from primary CPU")
Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230124154053.355376-2-pierre.gondois@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -440,7 +440,7 @@ int allocate_cache_info(int cpu)
 int fetch_cache_info(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci;
-	unsigned int levels, split_levels;
+	unsigned int levels = 0, split_levels = 0;
 	int ret;
 
 	if (acpi_disabled) {


