Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B72E2820B2;
	Wed, 23 Apr 2025 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421583; cv=none; b=ASQXawJ1DgwpDV6OWZd6QEmnYfPatIDQBq8VRLxcNZpMOEC5wHzEMRioDoeVACi3UwBKC4RpRdSIDgNeKWuApmBeVZGgFdOFt4qDHXPskgX+bXFGMaWkpwX0cBxkTOVOn1QBRQfiebIpDa+zaTHsLuYfzXyOhLpxxRPa1fbyoFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421583; c=relaxed/simple;
	bh=gCR+5VrWdO/mZRsJdMPC1CnSe9V6eZEq11SEnm21Lbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWFoyGp7zIwxaufTPp8wFgOuHmMcVrN/CTduSI9S7GEch+r8kx6dtCVfcHz9GvTzmrnedCrrtn1t7/T7S/YcYMXNIwXg7cH8dcRT0zvKIrJ8u+hR3O42OQP/JvDnsBvefbawzVc87U7nBCYr3ls4e7rOefFK6OnSoTUZS0QNXSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgSZf0Rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgSZf0Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3210CC4CEE2;
	Wed, 23 Apr 2025 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421581;
	bh=gCR+5VrWdO/mZRsJdMPC1CnSe9V6eZEq11SEnm21Lbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgSZf0Rb82jPI5Lba9+grZI762HqRu5Xyp3QZIt0tNnvS+WDnmzgyYNGOqNps9jwY
	 17P1rwJt6v58LqRuDXQFBN4JQi2AtLZgYwnzIYxEu0/lk2qPIQGrkZOHWE/RFLtcPZ
	 0xl91SdhbOPhGXb5Yo5cGhKmleWduPlZPrQJb45A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Herbert <Marc.Herbert@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 196/393] mm/hugetlb: move hugetlb_sysctl_init() to the __init section
Date: Wed, 23 Apr 2025 16:41:32 +0200
Message-ID: <20250423142651.482684840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marc Herbert <Marc.Herbert@linux.intel.com>

commit 1ca77ff1837249701053a7fcbdedabc41f4ae67c upstream.

hugetlb_sysctl_init() is only invoked once by an __init function and is
merely a wrapper around another __init function so there is not reason to
keep it.

Fixes the following warning when toning down some GCC inline options:

 WARNING: modpost: vmlinux: section mismatch in reference:
   hugetlb_sysctl_init+0x1b (section: .text) ->
     __register_sysctl_init (section: .init.text)

Link: https://lkml.kernel.org/r/20250319060041.2737320-1-marc.herbert@linux.intel.com
Signed-off-by: Marc Herbert <Marc.Herbert@linux.intel.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4695,7 +4695,7 @@ static struct ctl_table hugetlb_table[]
 	{ }
 };
 
-static void hugetlb_sysctl_init(void)
+static void __init hugetlb_sysctl_init(void)
 {
 	register_sysctl_init("vm", hugetlb_table);
 }


