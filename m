Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E79350D7F;
	Tue, 26 Aug 2025 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216829; cv=none; b=NaRws6djpyGw/jScXbZjFmb3h59uJ/mTFHZX0gsUT0MJfpW6Ji1FUXyRk7QfsHsvenu+ujvScES2/6adovbnpvN+QIKdYJGhJlY0mCWRTXXRUVmlLMj4nU564vfnkQkcOZmGf07UBtXlaJR7LuXKx23LLNy0ZMRTD4gfdyndee0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216829; c=relaxed/simple;
	bh=oCUJhqpEkuTVvSlfYxi+soz9zt3VmWMtcsdIS08mDsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1K1RqywNz1ure1HWO86ypWIiSOhIcPzRuptjRFcRTwjDqEgPOlkbTui8/JPoxG/AQTNNpGngZqy8ciUmJdQAevsCKg39fUzWszM92ZRGjCJTkk/FT+QlISoUGfSdDJ59R64PVctSXCDv8pyVKRPX0nGwtrDYewkM9GSjTxIJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgsVMxyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgsVMxyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36476C4CEF1;
	Tue, 26 Aug 2025 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216829;
	bh=oCUJhqpEkuTVvSlfYxi+soz9zt3VmWMtcsdIS08mDsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgsVMxyfzPLRnrVj/ypFAVZyFeW/9kHFms84FMmRtRYzkn6RN0GYkcfiS2xKGvyzi
	 bMxf8FLyEiqK5z0o4Bt+xoYt+r/ksh6OWqw1P5cYG8vGS3X+4f4+kx5WPiDXZliZ7D
	 rkbgWcTXgRguhP5iQu4fnbYwpSXrnSQby3na3hPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 558/644] selftests: mptcp: Initialize variables to quiet gcc 12 warnings
Date: Tue, 26 Aug 2025 13:10:49 +0200
Message-ID: <20250826111000.357083871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

commit fd37c2ecb21f7aee04ccca5f561469f07d00063c upstream.

In a few MPTCP selftest tools, gcc 12 complains that the 'sock' variable
might be used uninitialized. This is a false positive because the only
code path that could lead to uninitialized access is where getaddrinfo()
fails, but the local xgetaddrinfo() wrapper exits if such a failure
occurs.

Initialize the 'sock' variable anyway to allow the tools to build with
gcc 12.

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ mptcp_inq.c and mptcp_sockopt.c are not in this version. The fix can
  still be applied in mptcp_connect.c without conflicts. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -188,7 +188,7 @@ static void set_mark(int fd, uint32_t ma
 static int sock_listen_mptcp(const char * const listenaddr,
 			     const char * const port)
 {
-	int sock;
+	int sock = -1;
 	struct addrinfo hints = {
 		.ai_protocol = IPPROTO_TCP,
 		.ai_socktype = SOCK_STREAM,


