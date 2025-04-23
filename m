Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D586F28D849;
	Wed, 23 Apr 2025 15:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421074; cv=none; b=d6gybAwO2h1xhuBCpEpnPR/Cu1RNIlgM1AIxqjM8KodS4f7q/5C9OMF45joGmypdJJgZ4F1gQs1FziX0GHpnUciz9Zq8yJID/Sk5J0aKvVs84fU98OYGuSppe0mv5SMhGHfdmlaQ06iDRJl7qog8HTP+Dyf52fke5NrxGEXtgHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421074; c=relaxed/simple;
	bh=F+hx4Fn5mDfpyt0oGlpKpllYKk1cWAK1EFxhtiq3FK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6ejhX8GCBw+F4zsQUA4Jcd/s8pQAUWmlSGM5d3Jc+R+5r2T7O2IUJiKU1WxS9cWPiESYnushGhgNfB/C20SWNOKg/KxkoouthXrD6YevyJupCYZLmi5s5qKI+JSuB3hDib8c+2S0rQ/gcpfgsfcl0yw53zZ2P0R8ZLbxoYf9KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muBl9RGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muBl9RGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097EFC4CEE2;
	Wed, 23 Apr 2025 15:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421073;
	bh=F+hx4Fn5mDfpyt0oGlpKpllYKk1cWAK1EFxhtiq3FK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muBl9RGQg5hOTawKUYt3aISA7ofsXcDD2l7VaiJp0G1/e+v1Wcb1nM/HW4Wve9ktJ
	 9GO7SNUUa3Q4vHsRsOsTIqHNkU2dj0Q6LFziSuEeXmhy99sb7GTBzQhgs1a+DPjDSi
	 wAyfJbTlWt3xDSyApWiub5Po207YBYflida11p44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 189/223] arm64/sysreg: Add register fields for HFGITR2_EL2
Date: Wed, 23 Apr 2025 16:44:21 +0200
Message-ID: <20250423142624.873400250@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit 9401476f17747586a8bfb29abfdf5ade7a8bceef upstream.

This adds register fields for HFGITR2_EL2 as per the definitions based
on DDI0601 2024-12.

Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20250203050828.1049370-5-anshuman.khandual@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/tools/sysreg |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2694,6 +2694,12 @@ Field	1	AMEVCNTR00_EL0
 Field	0	AMCNTEN0
 EndSysreg
 
+Sysreg	HFGITR2_EL2	3	4	3	1	7
+Res0	63:2
+Field	1	nDCCIVAPS
+Field	0	TSBCSYNC
+EndSysreg
+
 Sysreg	ZCR_EL2	3	4	1	2	0
 Fields	ZCR_ELx
 EndSysreg


