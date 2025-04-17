Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1679918C034;
	Thu, 17 Apr 2025 18:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914993; cv=none; b=uhheko6x3tsJCF7WARGuDlvnvIiCi33c67N+O7xPKeJBE1rCOKImLT/5intSAIKXZ4TQgDR1/4UAY1xJzsIn1Rbkr7f0NqGvvxpnDLmhA2Fqo+9JQsJ0treapazrUZMW5Ku5jtuk25RiCrEX0qKbO108ZGUxqgYBCelHBeScfV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914993; c=relaxed/simple;
	bh=cw4vDsimlgD/PE7JYwUZjk1WIJm0PtCdP5HOQgyaalc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlvbUHIsMvDSR7nAI7zUGZ3RtaerjhCK/eD/weiFKiDfGdvnrr3jVAU575n1wIclU6Q9rICtM89QIXepQrGLZyA3RUDzemO3q7WovusSlXD0NPbYW85sWfxhNMl9mVRuoub46DlQ5Ira3RT8fZbl2yBD8X3FEx+6GJFIsk2R4j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snX7ze2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snX7ze2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD36C4CEE4;
	Thu, 17 Apr 2025 18:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914993;
	bh=cw4vDsimlgD/PE7JYwUZjk1WIJm0PtCdP5HOQgyaalc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snX7ze2Bvn7mNYlM6jAACF0S4du64V96P87/uNNRn9FrJ5eJByPlIDt6RkEQDV30u
	 VkJ7kstxQuIUNhsOTPSGB/xHZsN/PBDtKpRROhQ7Qw5vlDUVxa4z2dpYGYhtIfUYoX
	 qSe+XnXrQpqxmtZnJcWJUt+kydq3/JMQ4KDEm9m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Liu <liucong2@kylinos.cn>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 398/414] selftests: mptcp: close fd_in before returning in main_loop
Date: Thu, 17 Apr 2025 19:52:36 +0200
Message-ID: <20250417175127.492606975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit c183165f87a486d5879f782c05a23c179c3794ab upstream.

The file descriptor 'fd_in' is opened when cfg_input is configured, but
not closed in main_loop(), this patch fixes it.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Co-developed-by: Cong Liu <liucong2@kylinos.cn>
Signed-off-by: Cong Liu <liucong2@kylinos.cn>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250328-net-mptcp-misc-fixes-6-15-v1-3-34161a482a7f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1299,7 +1299,7 @@ again:
 
 	ret = copyfd_io(fd_in, fd, 1, 0, &winfo);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (cfg_truncate > 0) {
 		shutdown(fd, SHUT_WR);
@@ -1320,7 +1320,10 @@ again:
 		close(fd);
 	}
 
-	return 0;
+out:
+	if (cfg_input)
+		close(fd_in);
+	return ret;
 }
 
 int parse_proto(const char *proto)


