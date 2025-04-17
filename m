Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB75256C9B;
	Thu, 17 Apr 2025 18:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916207; cv=none; b=AxHoUcqh8woYI4fWboFdJNWy4YJtJqX1LkJUh+Rqu32Kf0bv5egv232sMWaFJhznLgYUZAf39JY/08JEJNRc8uaRCKyvpDmTb7Pz3T4IjJeYq6ltLLInA39vBQlcxSux+s3uDUD3YHMfxb7N9tP/U9EOojgfzcKl+P3gxZH/COg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916207; c=relaxed/simple;
	bh=AwnjlmJ7zULTLVeoPHJg+00t28iEblvQBIGmrMkys+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmtKObhtTFiEehEmE//5LY2036K+S6/EUvUeUKgJI7bTTzYr0PlxezMdo1lNUJvPzOZj7qcNlid8GauhbFwoRrTYGg5FzchMQ8jwCLdesnMzu6CTjQ8EgILe3Fy8O4xIYtgm4O+z62sPrYjryOBI0nWUWfTrjpC1ZgNKJuooSC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EplMnYqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EplMnYqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2E6C4CEE7;
	Thu, 17 Apr 2025 18:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916207;
	bh=AwnjlmJ7zULTLVeoPHJg+00t28iEblvQBIGmrMkys+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EplMnYqcf7zsJ9CNMvu7D8/QlMmXBscIJpF1Y9XRb1SecgRIY823nDkjmQXG942Vw
	 NOXdPI9aPfq3A06+eyLYjrAK7iaJHtFSdzjm/3oA0DPNEG7t16SvmRipo4EkLSvyVG
	 ogwfoV4zTdv8kjRYfx7IlItonKIRDi0+nrkB0V+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Cong Liu <liucong2@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 377/393] selftests: mptcp: fix incorrect fd checks in main_loop
Date: Thu, 17 Apr 2025 19:53:06 +0200
Message-ID: <20250417175122.766417184@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
 


