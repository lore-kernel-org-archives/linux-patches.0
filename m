Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D158462;
	Thu, 17 Apr 2025 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913743; cv=none; b=ro8pHnNusl8S9sZ/f+6kFQOqF7AAcVpYPLj41o8r+WAagb7nb5qitm9sBA6wYD4Wav7n7s4A1pzq6+6cfgCz9PNVTuSUyV6QTvMxqy6qx6lqxWwad+SYe6DniI+nocpf644qFTUHuZ7UJ7I8mts9Ae+DBlnd9/Iu6b+fXViS/ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913743; c=relaxed/simple;
	bh=rp2XpYGNtLN7v/61RR7Qwr0m120ePQJzLxQM1ZUv+Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctzpMozsPJxInrycC7cHHPGAJQnPu8qeOi5H57JfevUJUlbZVVOMvmXtmfxwopXZ7OWgyyoWQYXOEgC0of41HSmAa5TIqW6sobkuuU8Pb5iJvcBbBTmFIH9abyK/Va9oeEDA1l72zPQKyDbpSLktrPrR2HZp6i/o7GmH+GT9ts8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdCDzMbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdCDzMbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392DBC4CEE4;
	Thu, 17 Apr 2025 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913743;
	bh=rp2XpYGNtLN7v/61RR7Qwr0m120ePQJzLxQM1ZUv+Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdCDzMbAQKv4PWeDLP0AVMuOpqAJgJZy6iMrECgYS0YK+RCraT9xb7CqkTBKKGe4L
	 3MWi6vpz0kdCKquUpBGnkOIp3LVavJzJxxlRJ0hZbq4AKxquG0pgbknF/3YR2eoLGy
	 lF6gzuEB++qlASIAu+riVio1UKCKgdAvFd44bVmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Cong Liu <liucong2@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 439/449] selftests: mptcp: fix incorrect fd checks in main_loop
Date: Thu, 17 Apr 2025 19:52:07 +0200
Message-ID: <20250417175135.986647366@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


