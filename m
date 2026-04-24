Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960423D5241;
	Fri, 24 Apr 2026 13:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038117; cv=none; b=USnqiuKn6eRlEY4i1aFB1e21cEyqT+e5QLKTGC1Lhd3yStMAtgU9kf8rUMqsyBmCgXeKPmzjxCCTfIXIbtgZSY8ovpZw6+gms5Lci8voDKg1LWHCtfcXcRs1fzh0uMYaKGZeGouEObth3K5CDrpv6B3P2FOLjCyLwibt1QAry/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038117; c=relaxed/simple;
	bh=MJq6hv0tmtF22vgPFTm8IkC88CH28lzRvctsXwTkYVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is+nJg8aCm8vjov3tA7dYu8F3BGcviuh4JlsJFRB+SnlyO0YutV5LvEtUg4DYQcsdSNZKj/5Nfa3yno0aCwtPxmbGbUdxi3V8Bw3/ymyj0htdYO0uDyrmDiK29MHntFKrJOd+07x40Mj0jmjismqqMMme52jy36Nq/yLsRjWFCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZnm/I57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZnm/I57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E664C2BCB6;
	Fri, 24 Apr 2026 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038117;
	bh=MJq6hv0tmtF22vgPFTm8IkC88CH28lzRvctsXwTkYVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZnm/I574K8fqTgzp+fjGaExcACluHRCqC4ttfmyIkWRuhDg14/u4TXQgFmLu4M2L
	 iTQACsLlEoTUMbVE1ULAZutIny9vgy+UXnCZq+e1A85YxnSdVRTqtQs6uA1x3AM1xx
	 5u0DWnDc5PqbGMF0kck9phT9/LBZLVNFfjMfLFiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-crypto@vger.kernel.org, kunit-dev@googlegroups.com, Eric Biggers" <ebiggers@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 23/55] kunit: configs: Enable all crypto library tests in all_tests.config
Date: Fri, 24 Apr 2026 15:31:02 +0200
Message-ID: <20260424132434.857937154@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 8d547482231fef30d0d6440629b73560ad3e937c upstream.

The new option CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT enables all the
crypto library code that has KUnit tests, causing CONFIG_KUNIT_ALL_TESTS
to enable all these tests.  Add this option to all_tests.config so that
kunit.py will run them when passed the --alltests option.

Link: https://lore.kernel.org/r/20260314035927.51351-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/kunit/configs/all_tests.config |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/kunit/configs/all_tests.config
+++ b/tools/testing/kunit/configs/all_tests.config
@@ -44,6 +44,8 @@ CONFIG_REGMAP_BUILD=y
 
 CONFIG_AUDIT=y
 
+CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
+
 CONFIG_PRIME_NUMBERS=y
 
 CONFIG_CRC_ENABLE_ALL_FOR_KUNIT=y


