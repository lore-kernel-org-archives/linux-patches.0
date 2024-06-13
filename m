Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC942144D3A;
	Thu, 13 Jun 2024 11:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279663; cv=none; b=VwNvkd1692LAt2DAg26CS/S1IdEYV9TogRnGF3RyQU0M7Q5qMcBb3Rxo4M6VvAoZ9Ey1aWT2O1bLChGCxXfAmOaqF0CScS5DaSoJteQNvTiXyAesm90Jv0zkb2671qx9sp70q8klwJvdT4JOldZr7bjJ14oCJUJVfXHF9BIm6Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279663; c=relaxed/simple;
	bh=SajGuzFe7R46TX42ebM/xXHEU9JBMZlDK8IK/4l642Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqpW/hm5N8fZWQf4eWzB4uYQlltj+/NHLOOS6Iw70e9L7VoHfgxCg/+Kkp2Fc1GMvdOd7IJABEWQ1YZpGM4oBLs8AuG75NkV3PCLMBnd6RFhC/tuTIxfgt4pHnq8Y2owq9HnpsAg7KpaRzKHmu17KtatNHitolA3CC9MWkrEoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd6RoYSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd6RoYSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A90C2BBFC;
	Thu, 13 Jun 2024 11:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279663;
	bh=SajGuzFe7R46TX42ebM/xXHEU9JBMZlDK8IK/4l642Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd6RoYScky7W/i7gMaStdxnl8INNXHi044jQE8QBbHPCC9EgkN82sMFwYIwdavI8H
	 ro/PpjN90AkLnT60OnUdaQZID6tvpY1RAbBDCa+gbEv6CBqqpImzY4PPp2LehuHvKt
	 4SB+T72XfIrroc7peRDCD5j76LnPFiwhUpO9O3AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 6.9 125/157] parisc: Define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
Date: Thu, 13 Jun 2024 13:34:10 +0200
Message-ID: <20240613113232.245130100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit d4a599910193b85f76c100e30d8551c8794f8c2a upstream.

Define the HAVE_ARCH_HUGETLB_UNMAPPED_AREA macro like other platforms do in
their page.h files to avoid this compile warning:
arch/parisc/mm/hugetlbpage.c:25:1: warning: no previous prototype for 'hugetlb_get_unmapped_area' [-Wmissing-prototypes]

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org  # 6.0+
Reported-by: John David Anglin <dave.anglin@bell.net>
Tested-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/page.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -8,6 +8,7 @@
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #ifndef __ASSEMBLY__
 


