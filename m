Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40362FDC38;
	Tue, 26 Aug 2025 11:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208612; cv=none; b=udCoUAy+XzGtuFQQWYAdIOpojG3YMyl4IzhT0MxHjPzZWM1qKKFNpU8Vbyho1shsHrfO+HZQ11//EX0ZwglSqhEg+TEVCz17JhAzgi1Edtg6AfhbVnfIQurQtxgBuzc2h1GMCpD2XN6v1sPU9EerHkBCMarV0MutjKL2a3O2dp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208612; c=relaxed/simple;
	bh=ZEpLhtT7lnzyN9yufGnAlFtcO9ZjpZLBUTxDoLb737U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOhzZqgYT9GktMGsoyeLQnzdRXVJhXeoCAlnKAYdgOdExki6nnM1J3qfanprzyElDDlyI1R49ERu6rGvUQMYAcsqnJRPJq71PEhJHuDOC+v8X6MOT2cQkVZ8QKsDe1ss7T/wJUkt+btIn2kTke0NzXPhaeVvIMRjqSHu0yywJb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou/sqpQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou/sqpQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555F4C4CEF1;
	Tue, 26 Aug 2025 11:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208612;
	bh=ZEpLhtT7lnzyN9yufGnAlFtcO9ZjpZLBUTxDoLb737U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou/sqpQoYRpNUYjlgdmauz6nz7hVNmS2FGjFZ4oE/Rag78RPgl9KwnJUe0pfzyfDm
	 ULseNZkY+nigZot3TZiXAuDGeEOKoHfJ1MBePqI4+0bz8KHqHV7L3hkNEmAWq38uuS
	 EIPd3D9iUD1P42+KhI+XJ7g/786j1xUKN5Bwl7kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 137/322] selftests: mptcp: pm: check flush doesnt reset limits
Date: Tue, 26 Aug 2025 13:09:12 +0200
Message-ID: <20250826110919.186622467@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 452690be7de2f91cc0de68cb9e95252875b33503 upstream.

This modification is linked to the parent commit where the received
ADD_ADDR limit was accidentally reset when the endpoints were flushed.

To validate that, the test is now flushing endpoints after having set
new limits, and before checking them.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-3-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -198,6 +198,7 @@ set_limits 1 9 2>/dev/null
 check "get_limits" "${default_limits}" "subflows above hard limit"
 
 set_limits 8 8
+flush_endpoint  ## to make sure it doesn't affect the limits
 check "get_limits" "$(format_limits 8 8)" "set limits"
 
 flush_endpoint


