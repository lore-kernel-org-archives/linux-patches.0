Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977A02DEA74;
	Tue, 21 Jul 2026 18:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660378; cv=none; b=B+6WN/7Jwg9PaOBIv6HC7nqiruV5kgMlvgTFMWiacttaM+V52oBHyQMHR0h1lEFm/2RHzqQRdkpHjHQA4i+uBgoEWumHOPVf1iwrPVJRSK48vKPihgVH7E7A8sqlXFb0XbBwGrpmYIpjyQ5TLRR+3BwVR9cXRr58ytF1etEXyCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660378; c=relaxed/simple;
	bh=tWGYu+fdFLGF1gV3L+5a/gvphTZcfVtgYtfSiEiI+os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld/fdabUvO8XcPSofV3BzqouY+U3K/lSfUjDWvSvGqSTW1z9pn3lfTBc/h6hRINMizn9adpPFh+dNFVPddv1tAMcDWoo6ct1MBlUHlu9+uMkRCuDBXZ5W16b5p1mHf4a3POgJ1l5zWzfTkuET8E0SYi/aWfUVSOG4ExnxzcI8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yu2gxpa6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yu2gxpa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088D41F000E9;
	Tue, 21 Jul 2026 18:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660377;
	bh=hwmEQ1HGeCHLhI/innuFmCF2JThu5glY3N5D/emd8cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yu2gxpa6LJDDcyUS4pR1ChKpgjFkNXpNt5BBvfEKFUPjRJrV/b6goiGk2hI5p565A
	 HfipuMPo6abn2J4J6rp6XyB/9V4vyKI6xPaYWj+NqyXk8aAUzMo5YPj/9c7+LdxvIf
	 n1+cmQ4W1dDncrBXnySx+ElcJdwUT5fmrbD4MwMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0956/2077] docs: memfd_preservation: fix rendering of ABI documentation
Date: Tue, 21 Jul 2026 17:10:29 +0200
Message-ID: <20260721152615.368872855@linuxfoundation.org>
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

From: Pratyush Yadav (Google) <pratyush@kernel.org>

[ Upstream commit 3a358c78093f98a70d84c934b7054f636bc846f2 ]

The "memfd Live Update ABI" section in include/linux/kho/abi/memfd.h
currently does not render in the exported documentation. This is because
it should not include the "DOC:" in its reference. Drop it to ensure
correct rendering. Tested by running make htmldocs.

Fixes: 15fc11bb2cb6 ("docs: add documentation for memfd preservation via LUO")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260605160645.3650271-1-pratyush@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/mm/memfd_preservation.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
index a8a5b476afd306..c908a12dffa7c0 100644
--- a/Documentation/mm/memfd_preservation.rst
+++ b/Documentation/mm/memfd_preservation.rst
@@ -11,7 +11,7 @@ Memfd Preservation ABI
 ======================
 
 .. kernel-doc:: include/linux/kho/abi/memfd.h
-   :doc: DOC: memfd Live Update ABI
+   :doc: memfd Live Update ABI
 
 .. kernel-doc:: include/linux/kho/abi/memfd.h
    :internal:
-- 
2.53.0



