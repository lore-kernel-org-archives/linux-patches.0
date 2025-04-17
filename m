Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33061A3178;
	Thu, 17 Apr 2025 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913740; cv=none; b=adpcpzcP6BJEfxHpTZD5j3x2tbuxgTc/MJCcW0QX9x3NZ07hZLLjwozqHkl6gNRawldzfueSE+jm4V3qe10N8DB57RBiXYpiV+cvKIwUJr0O4H2qo1MZb/ZtQf92vQjF7orER0y8uqtT8VX2Ftirk8fNG2H+E4MC72lFS5GQ2Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913740; c=relaxed/simple;
	bh=rElL2C5R+mfkULOaYtuC6YqmX7nNRvfQ3Fj9GBMNgQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/hxuz4aBZX5OFJ1Q/47s58p1zdgs7MYJA7074MPeFf/bf3YfQxHhCvHEDM5CH73Sb/iGOgn5RwupJjMTpTlWnZG9iR7/e/Du3ZHjs2Cr2ztq7wmJxzIv/NBf09ggaEeqaDgNp3PyYYUijUCw/si5ty2vjhOEFZoPjrAV8NlQ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWDKdG2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWDKdG2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762CBC4CEE4;
	Thu, 17 Apr 2025 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913739;
	bh=rElL2C5R+mfkULOaYtuC6YqmX7nNRvfQ3Fj9GBMNgQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWDKdG2BnL3D/AhKRcndWak6wmzeWZrqwyjkpyohFbh9GHVU8ahFko3B7NVMasPOd
	 MZibxoDd4onkQIgIPxJVJG2nES13471IkkPVhxksOBJkGJYFrouD7ZwAjaUw2ZDPB+
	 Q0i8meq/GlDP+LNQVdNuFoqj/KSFibr040Zygs+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Liu <liucong2@kylinos.cn>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 438/449] selftests: mptcp: close fd_in before returning in main_loop
Date: Thu, 17 Apr 2025 19:52:06 +0200
Message-ID: <20250417175135.945766006@linuxfoundation.org>
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


