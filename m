Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DC944C6F;
	Thu, 13 Jun 2024 12:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280706; cv=none; b=Bmuf0JQkJhBLjcVlHjNBUJgLCmZuBadUMOEGu7bcu5NdzkXhbrO0+t4v0h/sDdhhIE0fY6FlQ6ibgYxt84sC4CFC+MMsfTyLFM95xZj5+BLsoJNt0DQAYjd4NTcdIpi0FpM0DAjBawc5krOJTrq6/8FJYyvg8BkBiG/S9QtJjgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280706; c=relaxed/simple;
	bh=Lel2nnbRqt/xP1Ikh/CoiFYzNHyTn+6EPvP7asrG9P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qby9Uu8I+/u/0JZergspptQnlShSpl5ErTkCo6faV/DdyXIuOMj5uSBNX0GeR+PFKxOvGy80sjj/zyFM80G4+qMsRRyunNRBAv0Mlhovpnb/s7Jj2iU5yHzoo1/Mc1+hfdjSZa33tggpaa0hsy8ho0vxRXSE4x4ly2yT2tiY3Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvvwhD71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvvwhD71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925A3C2BBFC;
	Thu, 13 Jun 2024 12:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280706;
	bh=Lel2nnbRqt/xP1Ikh/CoiFYzNHyTn+6EPvP7asrG9P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvvwhD7122YTNEXbmvpBwUmpDmNgP4BHzdb1A5BTweCk5dauPMv3ypKeD6uH646bk
	 dI5D2CgeQMxKXux3vTVRuw8XQdjWL/FkPCgXe83X1PPICtfRmkbkc9aZd7O33WPS63
	 f4jLAp9wIJzNlJsCVJQ1JQ5ZmXN26i5pDKrufzN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 6.6 114/137] parisc: Define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
Date: Thu, 13 Jun 2024 13:34:54 +0200
Message-ID: <20240613113227.719608686@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -16,6 +16,7 @@
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #ifndef __ASSEMBLY__
 


