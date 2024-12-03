Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4823E20ADFF;
	Tue,  3 Dec 2024 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240059; cv=none; b=SpqON+ChfxB1XqYMokyXr7SiEDFral8cmL+kdcBBIBA7EaSML/cvy9ZXKF1QUfxNKYM8msWiCWu9Orje9KIW9JN658RT6bU6qE/92V58UVCTO6Xi2ODyAGqJtjvy39lklcwiyNeb5a7c7IrrtA0ADM5Ot2M6YtBxnGXzgsRBipQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240059; c=relaxed/simple;
	bh=gK2cAcKu57kF9+NHEHxVTly0BgXhtalABh/zVpetF04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn+FGn1MUbZc/P859cxJfX+zoOAF4vTzM5sSodQIL2o/wG+hdXOmUaNgDI8FTF8CqUxJZSPCqDO/NDnWH+8Ie4lUpugvJ+eS4kiFH4Jdjx79ClZ49lmwH0GAvVB6WIEhqAQvCEIhoZzJB0x2doY+MYtGIzdulphGPQQvhyg/l3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kwkRie9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kwkRie9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F3AC4CECF;
	Tue,  3 Dec 2024 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240058;
	bh=gK2cAcKu57kF9+NHEHxVTly0BgXhtalABh/zVpetF04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kwkRie9ZsSvbc1qYPiQ/MbCIIux8xaRPI9HMW7El17JgOESvpK5eB9cMfcE7I6sK
	 /OvfquDXRnJnAmWpcBy/jjtPIVN56Fl/rrWDTbydY5HjYSwohHWzITc06f9UUoQkmg
	 cUf9taXaYSFz8wURaah99e8C0jm6ifk7XQm2bbHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/826] MAINTAINERS: appoint myself the XFS maintainer for 6.12 LTS
Date: Tue,  3 Dec 2024 15:35:28 +0100
Message-ID: <20241203144743.497996068@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

I'm appointing myself to be responsible for getting after people to
submit their upstream bug fixes with the appropriate Fixes tags and to
cc stable; to find whatever slips through the cracks; and to keep an eye
on the automatic QA of all that stuff.

Cc: <stable@vger.kernel.org> # v6.12
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b878ddc99f94e..23d89f2a3008e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25358,8 +25358,7 @@ F:	include/xen/arm/swiotlb-xen.h
 F:	include/xen/swiotlb-xen.h
 
 XFS FILESYSTEM
-M:	Carlos Maiolino <cem@kernel.org>
-R:	Darrick J. Wong <djwong@kernel.org>
+M:	Darrick J. Wong <djwong@kernel.org>
 L:	linux-xfs@vger.kernel.org
 S:	Supported
 W:	http://xfs.org/
-- 
2.43.0



