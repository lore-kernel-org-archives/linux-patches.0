Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375C134AC;
	Mon, 12 Aug 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479804; cv=none; b=qwNn+6Zt0FvcFn6aac6QPSZMl3S2nILxGmTdVhX2IISlrDQKQQnCp9mNmpNJlJETdFkxj06OVpfiaq7LviiPvp7QYlk3NHgXrouaCRAyWDZsnzksS3liTyOyKTpMYJfPq2eBWhw2njnPbNW0X3SYi475KjT2KwjsBRUMuB80vzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479804; c=relaxed/simple;
	bh=cUXqJPHHcIHtsUzDkPmUMhvMSoxh5oHxp9HLCgYPYW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsVrE1oXCZQGM9RS7Tstt5hh5Aef341PQDLSovwESouRuJdNMsFB+/SmVbKpHxwgHYdOrV1/Gxq1WoW2gjCw4X/WBFBnv1mT9PcYPEAlAXla0r9FvDid5oAL4NEloqBgTjaIbmHRl5DzAj82z8mzd+3/Mm9AchjsUSrdnhJWLpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvbgEgzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvbgEgzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4E3C32782;
	Mon, 12 Aug 2024 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479804;
	bh=cUXqJPHHcIHtsUzDkPmUMhvMSoxh5oHxp9HLCgYPYW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvbgEgzrWgTBt8H+Ndcag14oJcR/avtmOd5z/Kvi6R/lV3UskuIWD7s+BDTJoin1j
	 3YqhhzEBr6nVD/ZzW+i2WITMBC/DVh6Zd+XV6BB8CMrxBj+qZXsXk9reumwx6NHwlo
	 RfNqUOt8mTNgapgTPY01RWnVqvh8KqkHpwLc1PPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 169/189] selftests: mptcp: fix error path
Date: Mon, 12 Aug 2024 18:03:45 +0200
Message-ID: <20240812160138.651889955@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paolo Abeni <pabeni@redhat.com>

commit 4a2f48992ddf4b8c2fba846c6754089edae6db5a upstream.

pm_nl_check_endpoint() currently calls an not existing helper
to mark the test as failed. Fix the wrong call.

Fixes: 03668c65d153 ("selftests: mptcp: join: rework detailed report")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Conflicts in mptcp_join.sh because the context has changed in commit
  571d79664a4a ("selftests: mptcp: join: update endpoint ops") which is
  not in this version. This commit is unrelated to this modification. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -812,7 +812,7 @@ pm_nl_check_endpoint()
 	done
 
 	if [ -z "$id" ]; then
-		test_fail "bad test - missing endpoint id"
+		fail_test "bad test - missing endpoint id"
 		return
 	fi
 


