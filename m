Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F39196D99;
	Thu,  6 Jun 2024 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683001; cv=none; b=SRtv3HV+QQJz2db/HYWa5GRYtk1oAyUuwbCjxwRUdTQoyvlDni42nOY4KWxPnyI/Nli9CHVyh3R46IciyN26IFkbd+BIVli1HBFtB6Q62EMZ+aVjRT/k1ROwynlYXLRhmMRPC3HFNzg2a6TTWvLzKBMVtaNNwDLrXqtRuABQHUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683001; c=relaxed/simple;
	bh=4a9sXtWlA6bm1PDKdgO75Z9MJJLmO1hdseTp/MIlGrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atg2DIV5lsM7lBcOXlkZW3wG0DHkW3M9R1KkQ8Y4M/rDz0Jc9eO8xBsQKNA63rfZ7UKeqToN4WZhbiAFvu2FGyFP1UhY5b9cgkhyT7OijK2Fit6vnEpPcwm9HmS+wOqWwOi/A84OTJdmggMkz8ErCJN8duBo4mMHMFj0uhdwSOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wfjq9B0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wfjq9B0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C012C2BD10;
	Thu,  6 Jun 2024 14:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683001;
	bh=4a9sXtWlA6bm1PDKdgO75Z9MJJLmO1hdseTp/MIlGrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wfjq9B0KrGOAEVeXbMRXNw/8k6DfWQ6jIJEIzmeKTY5vhOvNGfD8BSp+1sLFZHSCB
	 b+DMpp7XYIaiz7/AL/ZjUWQ3P8VxY+WN9Xy/TGBsveBjBW4wzTjx4CBGp1rp5rcqhs
	 Uakt8s9Sg/n261j1p+WHXKYvz0LMzKelVSFqojUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 205/374] selftests/powerpc/dexcr: Add -no-pie to hashchk tests
Date: Thu,  6 Jun 2024 16:03:04 +0200
Message-ID: <20240606131658.693091996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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



