Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7421A1870;
	Thu,  6 Jun 2024 14:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683717; cv=none; b=uYp97bfT3AczJcjOUSiHwAakG5w1TsI5BzL8sjMCeJD2Yguek2Py5ewanPQjLMrzCE5STmve8z6exziz3gcFKy/fgK2aW+dGbfvXzcyKFzLZBOFmLDQrgQSisSChDp5rN3WC6s9C2qeX2paHVsn1tV2+gddwdF5jsjJ0gsbWqk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683717; c=relaxed/simple;
	bh=vMSTWcmfITR3yfbzNymfrG8pUzUYAb/LQsi1erBdYD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pls2TIehUcRI8a9G6EVRVeluoWO/e3JZ15pIR81M939Rr10PcqswqE2bg5xqdfF1phh0pvEhOAR3V/bCb87EyHMraH1RjsWPMfyyfXcHUqtWlhrLi1IrwT+DsCDurNVim8LT/clcinIbm50jWJKJtT5p7QEjrxfPqKrF822nOMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6LxELvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6LxELvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE5FC2BD10;
	Thu,  6 Jun 2024 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683717;
	bh=vMSTWcmfITR3yfbzNymfrG8pUzUYAb/LQsi1erBdYD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6LxELvp9c/2YnRtOPGkuUf5VVvl+H+fjkhk3kqWPzuENXfXQ8TN/0h8WAURSG666
	 a49S5CEEAQ1hb1EUzmKbZlvNNVVADMDrhHiU6Nf09o3Qii5CdE2YfHZWacrRoiQpob
	 bcqiOL1mN0cvrBjgk8pLtyaDOhfSnHFSjt7CsX4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 613/744] selftests/powerpc/dexcr: Add -no-pie to hashchk tests
Date: Thu,  6 Jun 2024 16:04:45 +0200
Message-ID: <20240606131752.151515054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit d7228a58d9438d6f219dc7f33eab0d1980b3bd2f ]

The hashchk tests want to verify that the hash key is changed over exec.
It does so by calculating hashes at the same address across an exec.
This is made simpler by disabling PIE functionality, so we can
re-execute ourselves and be using the same addresses in the child.

While -fno-pie is already added, -no-pie is also required.

Fixes: bdb07f35a52f ("selftests/powerpc/dexcr: Add hashst/hashchk test")
Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240417112325.728010-2-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/dexcr/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/dexcr/Makefile b/tools/testing/selftests/powerpc/dexcr/Makefile
index 76210f2bcec3c..829ad075b4a44 100644
--- a/tools/testing/selftests/powerpc/dexcr/Makefile
+++ b/tools/testing/selftests/powerpc/dexcr/Makefile
@@ -3,7 +3,7 @@ TEST_GEN_FILES := lsdexcr
 
 include ../../lib.mk
 
-$(OUTPUT)/hashchk_test: CFLAGS += -fno-pie $(call cc-option,-mno-rop-protect)
+$(OUTPUT)/hashchk_test: CFLAGS += -fno-pie -no-pie $(call cc-option,-mno-rop-protect)
 
 $(TEST_GEN_PROGS): ../harness.c ../utils.c ./dexcr.c
 $(TEST_GEN_FILES): ../utils.c ./dexcr.c
-- 
2.43.0



