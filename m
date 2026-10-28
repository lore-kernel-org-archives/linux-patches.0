Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211784;
	b=Y4DWgLEuMoCC/DmBerMsmVNEHWYKJHSNO8uQTXcrtFjmXG11K4uR8QdmjKmFzwx4NGoE
	 fceH7k83JQAefLsmbsFnVn94n/2t5xsEwTABG7Dok6AbxVm5nlonXHR9ixboDOMGK8L70
	 EIz+jkKVjG7ozs5l3zbKBcseiPwacLBLZNB0PajZfWeAdazGVqKaVOsHEeYiZf1/sG/aF
	 065qtOuZVo+mjJZz3sL1emdHQ402HpR/xQ64UT8ppFgV31KLWTuVKkg8B5wc77ReSLSXc
	 iRI/vv1Nk5ZBwbQclj61bnfHK3Coh1H8vqT/rOd2NPhMEnwQ/fCcr/N2Jt2KZ0ayK/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sT96pf6A05oGCzshRemr0Eu0rufvco1GRRYYdnNBe0w=;
	b=VUW5npRExVLBVL2shYJvjn6KMpzeUoOtCh/LTuNvq2UN2xWYetRxYFTHF5qeCiFzZ4/f
	 xZDtqtQz8IDxk29hawHnpQ2MPZ+Abuz82FmOs1WvSI+Q+W0pkvuR9OZ+wPRX2N8BXHPkT
	 iugFPBe9fFpQCUDcFbQFmQayI66ljKs7lNLITg0KCBgCLKSpm0s0XdEVjgYeYX+MfKT9B
	 kWMzFwv8Gm/TU7aTrin2ULEYA/oIBysIDQBcMsgKN0LEuEObSGW75B0us+PSh2hvyzxnk
	 39I6ZCW6rZ7yFeMllk51n7isdnvDZsWcd9HKxV7zTRs3lapflym3U640R+YFKwbcwig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F8XePy4N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EA360A3814;
	Wed, 28 Oct 2026 18:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F8XePy4N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1941F01829;
	Wed, 28 Oct 2026 18:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211783;
	bh=sT96pf6A05oGCzshRemr0Eu0rufvco1GRRYYdnNBe0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8XePy4NJ1NtltHMJ8sIjE7HQxZjik0hQJFbypztfcrD/xWWuc/ayYiWJ2q65outH
	 G8TXvHLPdiBotVv76nVMxTvB9kOpAYG/QcVDe9BIXqfk0pOmAmCYOB2DBGc2IEY1NF
	 5dNsfpmMc+yO/+DvsvWGTgHHpl9pw2/0t9Pdd74g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.15 498/571] tools: gpio: fix building from the top level with O=
Date: Wed, 28 Oct 2026 18:00:45 +0100
Message-ID: <20261028170019.845081856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


