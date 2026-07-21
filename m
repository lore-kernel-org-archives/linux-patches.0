Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94E4472F74;
	Tue, 21 Jul 2026 20:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664836; cv=none; b=fi1+8H9UjbRV5M5bkfn7ZUC0tWy2dWUPGEkhlFM+vjzywQCXEv0mnN54mQVwfbwsm3dllglRV6b4CDgn/NYw+sYceTPEDhbEMGqiyksh76oT1zSK104xw99st4WGKUhiHYTXw31pShL1DDWwOCBjP20gig9Zo39TPX3Hqvca55w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664836; c=relaxed/simple;
	bh=eab6cSgH+To6XaviCCEGr7SpGKFdUJCkq4HRd19Gxyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+BP41Jv+ZO94Rwa18u/9GLBC5g2orziSSkF71dZzQf9J7NiFFWxpcEUysuNea7qyuocvkmTbc4nbY2zSmF37X+JEDOuLzQu2oBECdj4hOl2IITd6aEAFfbUWbWamjjVBQH+XUmcUKHhJniO4qxLuMv0LGhp0uUl5P71TGSaLMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsSt6Q0T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsSt6Q0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6041F000E9;
	Tue, 21 Jul 2026 20:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664835;
	bh=69sZYGtCr2m+K4trw/0NUHaoJS2DFlzfituP47THtCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsSt6Q0T3Zi4mS1JOvHoxHesWDgLDfz24QalioSCBn9SJ2HTv14gcPA98Lfrk43aO
	 sa1xhzHZyk/n1U9ShQ1mnc950yUz3qHj9ISiJqewO7RCiCdFaWsHysEypM9EFmOOY+
	 9Epq8l+YONoycXNjsPN4MFultTiDGuFAfu8oLYxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0076/1266] arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
Date: Tue, 21 Jul 2026 17:08:33 +0200
Message-ID: <20260721152443.501530927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <tabba@google.com>

[ Upstream commit f4d4ebc84995178273740f3e601e97fdefc561d2 ]

The `ID_AA64MMFR4_EL1.EIESB` field, is an unsigned enumeration, but was
incorrectly defined as a `SignedEnum` when introduced in commit
cfc680bb04c5 ("arm64: sysreg: Add layout for ID_AA64MMFR4_EL1"). This is
corrected to `UnsignedEnum`.

Conversely, the `ID_AA64DFR0_EL1.DoubleLock` field, is a signed
enumeration, but was incorrectly defined as an `UnsignedEnum`. This is
corrected to `SignedEnum`, which wasn't correctly set when annotated as
such in commit ad16d4cf0b4f ("arm64/sysreg: Initial unsigned annotations
for ID registers").

Signed-off-by: Fuad Tabba <tabba@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f7180d391f829f..43089787196bad 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1130,7 +1130,7 @@ UnsignedEnum	43:40	TraceFilt
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-UnsignedEnum	39:36	DoubleLock
+SignedEnum	39:36	DoubleLock
 	0b0000	IMP
 	0b1111	NI
 EndEnum
@@ -1697,7 +1697,7 @@ UnsignedEnum	11:8	ASID2
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-SignedEnum	7:4	EIESB
+UnsignedEnum	7:4	EIESB
 	0b0000	NI
 	0b0001	ToEL3
 	0b0010	ToELx
-- 
2.53.0



