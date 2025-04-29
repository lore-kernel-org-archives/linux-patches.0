Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149F722A81D;
	Tue, 29 Apr 2025 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946550; cv=none; b=OCDwmjFUBZwjOhCmskoTbFmlmn2LpUQH1FJ5xgwBMaToBfNzVKPOf5PR7MBG6Gq12E7NcUGiIeqoIa89CgOEw+WqqZvmLkPLz3AvaUknTHCtALPG7YnyS9w+3MJgJoC6SMqhzn4vj7bcNPuMBokPBLyJGR6Es55f8RTYzaBW7IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946550; c=relaxed/simple;
	bh=GHT2t/uo60a9BaQi2CvxZPerzjUNxym9JZZtbPKOps4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fR31A0tPl0uwGWNi7EXfjlBLljCAQgcEDRLn03jXB5ZOYhGmivVg5VmUeZWi1XR6E9RUnE1hM+M30dJhxp/RwD3XhZrCohBOcmyqZ2XZJvocOYEC0QfMNiyaU8I5iO8PpswK34D1g5VM04ZzTLCaFCh3r/nd4lrFCVDe36AbtAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07HjeJ7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07HjeJ7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B63FC4CEE3;
	Tue, 29 Apr 2025 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946550;
	bh=GHT2t/uo60a9BaQi2CvxZPerzjUNxym9JZZtbPKOps4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07HjeJ7SiLwU/kVjfWKulyaEXo80DBhE34ZkXXOxiUmfrBEaw5k44fOe8CX/QgHjB
	 DbMZ2Nf1E+fafmzWyOVqpehRr15EO1u03yOJvvC46YpzXJ0UN98OBTwnYGVKVZCl8x
	 q5g9kWNNqIhKvN6YRT9h24/CvuOHVm82bT4SuIjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.14 303/311] MIPS: cm: Fix warning if MIPS_CM is disabled
Date: Tue, 29 Apr 2025 18:42:20 +0200
Message-ID: <20250429161133.410809673@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit b73c3ccdca95c237750c981054997c71d33e09d7 upstream.

Commit e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
introduced

arch/mips/include/asm/mips-cm.h:119:13: error: ‘mips_cm_update_property’
	defined but not used [-Werror=unused-function]

Fix this by making empty function implementation inline

Fixes: e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mips-cm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -116,7 +116,7 @@ static inline bool mips_cm_present(void)
 #ifdef CONFIG_MIPS_CM
 extern void mips_cm_update_property(void);
 #else
-static void mips_cm_update_property(void) {}
+static inline void mips_cm_update_property(void) {}
 #endif
 
 /**


