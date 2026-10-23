Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774823;
	b=RJSCen2VBuDaqADZn1j/nJU/voC15pxL6awQbxzag99G7JoTpWnCWyBFjsCXW2L6Tk6g
	 CX2hyvOipstyU/uRBzipxphr3TVe8gc7n66NYfPfCmyCskwPpY0far0cOnpjMwVXPvn8X
	 cBszQ8bEzFYs9jvQRNz0+QRJ5MTiLf6lgkhftQdhxEdypRWm9h+6dbz2czZWhSNTC/bUf
	 XbVYw0SsXSnvv/xrOvXSOeYmL20EiVoDKPX4i6LdcalS8+zndw4U0mcWqbVg/tYxdcX18
	 x50auI5qdbwuY1RIG/XEpP/dza7fJkBFJtZHYkdrr93i4YcIUb2RRpTKRZuX3BeKEpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cev86NUIhHQQIUgpvKoTYGCRJp+FSBuICTKfE4ZduAY=;
	b=KgSBNOikLLzHsXX237pBU7Vl2aiwhWjooDEjiDhiPp+kJR766SFB9QrqHzFhZvGz8xms
	 WV7ov5kO32hageqQOPmNmsceBoChdTdZiozEWeEDMvNg7L7isSXYGBBOYll15etkw5LZy
	 l+SPBgNRUAp7YWxg1W05xCp7xaJw1aeqR0o4S1ME6++9Z7nQl6Ud1buw32K6DivgXW3v0
	 vcfI9yhO+WO5/BXJ2BnjVA/HUgrWginq59XKv6JiGZ9Udrwi9uhfGSNpCfRUaXWXd2cMV
	 O3PgZgYT5aAqsq9HgZvFXWnoMZCbzqcSLEklQVW5tDbr+JCszy542INwG7sYmYv6Pvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nk/e62HV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480AD606A31E;
	Fri, 23 Oct 2026 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nk/e62HV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416BF1F01825;
	Fri, 23 Oct 2026 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774822;
	bh=cev86NUIhHQQIUgpvKoTYGCRJp+FSBuICTKfE4ZduAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk/e62HV6iY3uGn6u47/Xsy4jgev9fTy2DljhdvA1HKCpiH4YuxZny/PiGLrQF6hJ
	 pyGRF+gRggK3fmiPg8yv3VsQ+l+ZRdF4cKE1AGD3cF7en1WQlWS7b5x94A3bpINnZU
	 iTiR6q4NvyKaUp+8XppaVCxXYGV+vg2yWiVD5Iuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 132/242] tools: gpio: fix building from the top level with O=
Date: Fri, 23 Oct 2026 18:39:34 +0200
Message-ID: <20261023163716.902535364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


