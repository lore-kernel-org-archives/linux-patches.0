Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DEF28B516;
	Wed, 23 Apr 2025 15:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421853; cv=none; b=hysuyYY4fQQeFBUUfrT2GByuSs5m97XsO0uxFCiI62EtSb+2ezBDFgmwqiL93JS4xRXyLG9Pj3JmtiNxi3avHp5C0u/f9MMOjZpx2Ed1dTp+gmk3KdKhgv6CoGR7dJzUI2zFzTvm4rB/f1Ajhfv3YZm24yW37CpLN/XckbuommY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421853; c=relaxed/simple;
	bh=DRFFGN768/Ehb0OqI5nYnZo7xbuv3pmSfHo731DTfak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2pZzEA0FBOCJ90lOwnfdBbdLPCp6/AyQT8cBlLCVbOSyYY0nXJJ0r/sVeDdZ+qL2K0i1kkhd7fBhF2SA850GbJLG0FlF+E6r3p5rMBEuOJ3mxpnJIN9PyJ54JzFg0PkUne7yvA7FHBH54ODeCAHv0BWRG2LkaLVfJoneOAOtVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBXpCCq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBXpCCq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46677C4CEE2;
	Wed, 23 Apr 2025 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421852;
	bh=DRFFGN768/Ehb0OqI5nYnZo7xbuv3pmSfHo731DTfak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBXpCCq0MPY1XQHco4VQj0MfM3JyF+8oIMJIco7SM0oM7TUrnQa6GfP9WpExLVogj
	 jfMJL55DrFLzjV0w0okt16ppKRsEl2h32iiNlZBpgl8HK8nO8r3m6X1GJLeB9z8WIU
	 khfsgEP86sYRNetH/393qNZqiSZTX/hLV/dn8yoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Cong Liu <liucong2@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 231/393] selftests: mptcp: fix incorrect fd checks in main_loop
Date: Wed, 23 Apr 2025 16:42:07 +0200
Message-ID: <20250423142652.933697780@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Liu <liucong2@kylinos.cn>

commit 7335d4ac812917c16e04958775826d12d481c92d upstream.

Fix a bug where the code was checking the wrong file descriptors
when opening the input files. The code was checking 'fd' instead
of 'fd_in', which could lead to incorrect error handling.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Fixes: ca7ae8916043 ("selftests: mptcp: mptfo Initiator/Listener")
Co-developed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Cong Liu <liucong2@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250328-net-mptcp-misc-fixes-6-15-v1-2-34161a482a7f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1270,7 +1270,7 @@ int main_loop(void)
 
 	if (cfg_input && cfg_sockopt_types.mptfo) {
 		fd_in = open(cfg_input, O_RDONLY);
-		if (fd < 0)
+		if (fd_in < 0)
 			xerror("can't open %s:%d", cfg_input, errno);
 	}
 
@@ -1293,7 +1293,7 @@ again:
 
 	if (cfg_input && !cfg_sockopt_types.mptfo) {
 		fd_in = open(cfg_input, O_RDONLY);
-		if (fd < 0)
+		if (fd_in < 0)
 			xerror("can't open %s:%d", cfg_input, errno);
 	}
 


