Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621C2F28;
	Mon, 10 Mar 2025 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627052; cv=none; b=pPv5lpPRACvhI2wGrHJulxa80HzcqD04VgU1qHdT2ukaVg5ggefUtGwkKvQJArDnf2SL3xM/qbZieyq1H3xvHdl0efebbWye3yuxFZ1fClHECCiJJJukeuWXVbwa1kJU9TuD+3cPWsuLOWORxfcp9bYj8wBCEegVen+nBtb2uAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627052; c=relaxed/simple;
	bh=3EafQxO6IiafQ3fB8S6LrNMWrG+/uucFPUtmaBMNAko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVy+tTq2DjNy1G2h+7//sRmVRQ79ww3+jSteEgQ4kmbSUfiOjpwSbHLbMLyYKqmHj9t923F3dp4skoezKgDvxCuPobDMeHNAQuMdKz8ULJ3Aj3RBriyIkg/fMb0WKnZAE7b7pNw1HpVJBdspXGtj/pNYrJc6AP/VfM7V2asW6lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQLd3K/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQLd3K/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F107FC4CEE5;
	Mon, 10 Mar 2025 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627052;
	bh=3EafQxO6IiafQ3fB8S6LrNMWrG+/uucFPUtmaBMNAko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQLd3K/W1+43v+/hdh4BnhKLbxpVT2byyuXwdsavM2LoHx+QTyPOrZPRG2Q3aZ8jT
	 ZCMaVyB1/6sJKHmweRqb/12vncUnfpr1nAD2ueUjX5H8LT27dvNwdl9MqXLWERmUZo
	 fhprW3OkGExWOs4FHmubzaFnzOD5mTDtSLhDVtFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.13 203/207] arm64: Kconfig: Remove selecting replaced HAVE_FUNCTION_GRAPH_RETVAL
Date: Mon, 10 Mar 2025 18:06:36 +0100
Message-ID: <20250310170455.848801067@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

commit f458b2165d7ac0f2401fff48f19c8f864e7e1e38 upstream.

Commit a3ed4157b7d8 ("fgraph: Replace fgraph_ret_regs with ftrace_regs")
replaces the config HAVE_FUNCTION_GRAPH_RETVAL with the config
HAVE_FUNCTION_GRAPH_FREGS, and it replaces all the select commands in the
various architecture Kconfig files. In the arm64 architecture, the commit
adds the 'select HAVE_FUNCTION_GRAPH_FREGS', but misses to remove the
'select HAVE_FUNCTION_GRAPH_RETVAL', i.e., the select on the replaced
config.

Remove selecting the replaced config. No functional change, just cleanup.

Fixes: a3ed4157b7d8 ("fgraph: Replace fgraph_ret_regs with ftrace_regs")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Link: https://lore.kernel.org/r/20250117125522.99071-1-lukas.bulwahn@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -221,7 +221,6 @@ config ARM64
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_FUNCTION_GRAPH_FREGS
 	select HAVE_FUNCTION_GRAPH_TRACER
-	select HAVE_FUNCTION_GRAPH_RETVAL
 	select HAVE_GCC_PLUGINS
 	select HAVE_HARDLOCKUP_DETECTOR_PERF if PERF_EVENTS && \
 		HW_PERF_EVENTS && HAVE_PERF_EVENTS_NMI


