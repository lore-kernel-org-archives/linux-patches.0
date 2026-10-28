Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217009;
	b=SOwBxeGM9N9gQRF4QhxJOfflorHFnBAGAbnPbp8lshF0fE60WMT+OYeHQpaaAiY1JEN4
	 mqElfpDbbyBBalN4kRtVHg2ZXhw4zAjgorvQwR/tyLdVtUJskiWHdTrp55pBQJooKlepH
	 dRVhLaIMsi5YuBJX4Tkh2ASzkNpxAChXilySHGU/JraVaSatxSWBbietUatogsXbDMaFp
	 Jo13sZRBkqPEYRaDOhx7gqsUo1FOO4RsxyLAz9w/2NtoyniVyHrbH16NvohnuC2r/htFw
	 Va454nMNTJHMR9tRwaF7nZEl7hp3s08zUuud1moTselGRLKt4PXqszgfQyN3JqGtOHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m6YFy8FzWASa1f6ILHAVE6ONXLe1n20qP/4h651CduU=;
	b=BwChZc1xKAscZpdu08AxcQJ+PNFO936wW4DQ66AEHzXY5FxhjMztLQe5dgWy83z22bvF
	 +BchrdHFJtdLVwlj3VdHi/9jWEGZN34RGi/HMPBFdzgdvkfLuus/CxVyrM0JBxjxFhX/o
	 +yukrqu08juzMEHI7KWW+19+AcJ/B79G2V9MDbR9Gw8zeeGJ166zjUhA8CwCYIbY/1jR5
	 2RIwMq5kEOVxmfkL2mayoZPmcvYuJ1pDeKbt22ivGXFFS3qaBYUlQXs4LxzanlUy9ra6O
	 /DgNXmbdDTzp/HA81+mBn+0QPeCOs7rngX1I2p6k8PH7sTODXWDTjUgto8EfVknk62A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOPUCZBs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A4660A2602;
	Wed, 28 Oct 2026 19:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOPUCZBs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F4B1F031E4;
	Wed, 28 Oct 2026 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217008;
	bh=m6YFy8FzWASa1f6ILHAVE6ONXLe1n20qP/4h651CduU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOPUCZBs24kBOMDNwq8CM61QMJjzZ4mIgQ8f9qEslHpxe9wC3clluzPXhEDkjnmph
	 j4lZ6LEA0SuxBaRArhiSOeQzSF3ISK4/iDs2qkDFR90ghSscL2iJdMe8JUx7uKDRob
	 vHhnpn0qVdZY0inHPzkkwNxjh5sPlfLB/cuadU6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 1739/1887] tools: gpio: fix building from the top level with O=
Date: Wed, 28 Oct 2026 18:03:55 +0100
Message-ID: <20261028170539.027652933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sashal@kernel.org>

commit 52336337f1a01ad803c7f3ddb23f40222e9ad58d upstream.

"make O=<dir> tools/gpio" fails:

  Makefile:27: /tools/build/Makefile.include: No such file or directory

tools/Makefile clears srctree, and the gpio Makefile only works it out
again when building_out_of_srctree is not set, which the top-level
Makefile sets for O= builds.

Also work out srctree when it is empty, as tools/bpf/Makefile does
since commit a89b2cbf71d64 ("tools, bpf: Fix build for 'make -s
tools/bpf O=<dir>'").

Fixes: 4a6a6f5c4aeed ("tools: gpio: Use !building_out_of_srctree to determine srctree")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261011223358.2327625-5-sashal@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/gpio/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -7,7 +7,13 @@ bindir ?= /usr/bin
 # isn't set and when invoked from selftests build, where srctree
 # is set to ".". building_out_of_srctree is undefined for in srctree
 # builds
+ifeq ($(srctree),)
+update_srctree := 1
+endif
 ifndef building_out_of_srctree
+update_srctree := 1
+endif
+ifeq ($(update_srctree),1)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif


