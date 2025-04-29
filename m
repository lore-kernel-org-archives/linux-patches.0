Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F4522DF91;
	Tue, 29 Apr 2025 17:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948330; cv=none; b=S1fbdZ7XoOGCevD/kcJmq5t6z8dz5c9hjLvDqwpZQBwQJVDWXNRCZOruHlrooVOYmoerbl4zaNvAzI3ocwfT9palEyhGyJkoSzCsDeuUld1yCws14lxCCumfiPHudqeTa5xvH0ceTjo99H5UpjnHk/lFW5a8YnLvLwEfCqRQY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948330; c=relaxed/simple;
	bh=wnEFQU7EI1pc967G9YvhjiLyk67UxBM7u3NLf4AmPWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOqrOGt7KCOTmG2sM2x7lgox8ivmFMbCqMZ9VWNVS+eGn+zuMh7ePu/w0MNq7+aumlTZJxI75X7mZUAaGWz3i3sUU848xkHwdPC229cA7mEcwRFvl1ichHwwkDb8B6O8s2Y1rZAdARXv9n7eO46/ttlUziQ1eqQt3lcj3xjrKws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp++dWzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp++dWzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA221C4CEE3;
	Tue, 29 Apr 2025 17:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948330;
	bh=wnEFQU7EI1pc967G9YvhjiLyk67UxBM7u3NLf4AmPWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp++dWzcIoPctYDgjlPi23vhlUjkMaMj9WiwCsc4QDMWc/dyjW5QHdjlIMBYk2aok
	 3Yk7tuuNHdJ9ud64Wd0K0ApN3FRbJPoOdD5QmNdSviEsU9XiaIVKbWi8ekADRtH6zf
	 LzipngofWJi8aPUw3ITC4maygSfdPZP/b016bfsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 255/280] selftests/bpf: fix bpf_map_redirect call for cpu map test
Date: Tue, 29 Apr 2025 18:43:16 +0200
Message-ID: <20250429161125.567678902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

commit ac8d16b2d3772934f4cba44cb01bad05b4b2864c upstream.

xdp_redir_prog currently redirects packets based on the entry at index 1
in cpu_map, but the corresponding test only manipulates the entry at
index 0. This does not really affect the test in its current form since
the program is detached before having the opportunity to execute, but it
needs to be fixed before being able improve the corresponding test (ie,
not only test attach/detach but also the redirect feature)

Fix this XDP program by making it redirect packets based on entry 0 in
cpu_map instead of entry 1.

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Link: https://lore.kernel.org/r/20241009-convert_xdp_tests-v3-1-51cea913710c@bootlin.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
@@ -15,7 +15,7 @@ struct {
 SEC("xdp")
 int xdp_redir_prog(struct xdp_md *ctx)
 {
-	return bpf_redirect_map(&cpu_map, 1, 0);
+	return bpf_redirect_map(&cpu_map, 0, 0);
 }
 
 SEC("xdp")


