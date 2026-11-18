Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029660;
	b=kO1X5H49P+GcqFDmE1BslPnH52Tch1qYWY6RwS2wrRlKQUy7shV3yq96CGMU5Bli80eL
	 Dl45hTfne8HQPC17jq8dkaB9mmJdVskX9L+OzsebI+9tzfwcHOucBBdbtAVY8NoOoDXcL
	 Falm80gEqlF4TQZvwVl3x0MRWruvnUhjHT7kL7ORvsiuGDrHsitKqHRU5ApG/sSMdQ19z
	 3p6Rye8XOwBgAK+kbzrVtquJKale6mrDB8Bn+jD//7u5ltMzRZl1fm91vrktHmp86yAAg
	 d95w9xLF1xIr5OlgvBNmQLTURUB26+YmuUhiDIyl4uwkiMYCtPITAOU7tEXdQkSAO6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ATm6Egz5JUFhWpnX7raxI9WguhjVRDdEX5cDDFL4j6s=;
	b=BoqK5DDzWUB+G5o/7Ch1D21OZF0JMjE94OntVFAOnKJ9yasFC1CA1Ui8yFBIPbtuEbhW
	 F1szohFx+RGTI4cFwoSniAMhD8kSZOW+j/pBYlXI85fo0eE1V6/VC2Fzv99wmNhn8fVn6
	 ZHdMp+KEftRu67UPvEMPwxX+/IWoMJC5WipwkpyaipSn+wXpWLIbGza9esC+O4v3otwBp
	 PbvylXyTv8wLJqsfAqr9DZNTMUDyYtSZ4Oeeo+nXgjsSaLQfQ4QzwiJIc6vjlSzpj6vbC
	 TwcQeppOicI4EEya57CKuuM96RZakSnFNLDUJrQ3R7KPy2o2HES5okUoUv6Gb3yh66g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LfAHPkI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01C6606A334;
	Wed, 18 Nov 2026 19:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LfAHPkI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255411F000C4;
	Wed, 18 Nov 2026 19:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029660;
	bh=ATm6Egz5JUFhWpnX7raxI9WguhjVRDdEX5cDDFL4j6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfAHPkI/fLWsVVYb/Q7ZCxK5wiRK02zrVj7Fv4Ez2OpIFaE/FEm4r7PdjHIqaHJcX
	 SXInb8/29415NqHvbWFn2g4NbdWlVKeRuMRraWPFecd6bEy92folgmPX4JvCaoyi7E
	 SBw2//T21RVZ8O3EtWcfO81bHMtp2uIMySBRT0vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0422/1756] mm/gup_test: report actual pinned bytes
Date: Wed, 18 Nov 2026 15:42:29 +0100
Message-ID: <20261118150025.566517467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Sharma <sarthak.sharma@arm.com>

[ Upstream commit 65a79b9b693d8c7bd7e5e4865c02cce922a7cc50 ]

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch. If GUP pins more than
0 pages but less than the requested batch size, addr still advances by
the requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Link: https://patch.msgid.link/20260901083452.115365-3-sarthak.sharma@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 6de8064090ea1..6014bbf2aadeb 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -180,7 +180,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0



