Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590E839FD6;
	Mon, 21 Oct 2024 10:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507219; cv=none; b=SvGT/eJ1YYMyLn4/1zFUyXfAvKWmGt3bLw4oPF/yK4VhKp6s9ZeqH5X4s/Gju/NUhgEQH7nkytirYb14JoEUGgFoXfq3pDcpJfl4h3VF2FqV53BfSpXUH2mWaMUO4cca6XCYBlqTl0GNDc6sD3bIY0HbKN4zEc/u+ZokZWgrdU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507219; c=relaxed/simple;
	bh=Rv2khK1K/mJeaSgJ1O3aNxYOVmI0MwOcqAgHrHoSync=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAkzYkzYzRvewtQR7A0K7pqR4Vd9XJBu0GcPllMidUKAgxj28nGqJTfvdy0SzfM3xwnfUqUaC+oVKHwoxXiJ3xn1mI6Wqli7G2I0/UiYZ1bRyo8tJ707cfcC14zQndJ/M0LTctFuGQTdxPTe5+IOomIfvRvcdKjkNsRdUithDno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnGg/M1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnGg/M1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7D4C4CEC3;
	Mon, 21 Oct 2024 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507219;
	bh=Rv2khK1K/mJeaSgJ1O3aNxYOVmI0MwOcqAgHrHoSync=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnGg/M1yYd1qrLgmg8PliBWauB7Dh67EhqoDAbBwsJJTY7aQq7ZN8YEMP0S5uPAXe
	 VsxZcjoeG9tunyQQPgdb0EfTi+XGcBtn0FCU2HzOKZx6t8J2KkNa9N18k4oVT/fVId
	 GS3Dpczyn/8eWmAL7zE4DZRTCPasFjrnbwOpNCLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.6 122/124] selftests: mptcp: remove duplicated variables
Date: Mon, 21 Oct 2024 12:25:26 +0200
Message-ID: <20241021102301.443215723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

A few week ago, there were some backport issues in MPTCP selftests,
because some patches have been applied twice, but with versions handling
conflicts differently [1].

Patches fixing these issues have been sent [2] and applied, but it looks
like quilt was still confused with the removal of some patches, and
commit a417ef47a665 ("selftests: mptcp: join: validate event numbers")
duplicated some variables, not present in the original patch [3].

Anyway, Bash was complaining, but that was not causing any tests to
fail. Also, that's easy to fix by simply removing the duplicated ones.

Link: https://lore.kernel.org/fc21db4a-508d-41db-aa45-e3bc06d18ce7@kernel.org [1]
Link: https://lore.kernel.org/20240905144306.1192409-5-matttbe@kernel.org [2]
Link: https://lore.kernel.org/20240905144306.1192409-7-matttbe@kernel.org [3]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_lib.sh |   11 -----------
 1 file changed, 11 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -9,17 +9,6 @@ readonly KSFT_SKIP=4
 readonly KSFT_TEST="${MPTCP_LIB_KSFT_TEST:-$(basename "${0}" .sh)}"
 
 # These variables are used in some selftests, read-only
-declare -rx MPTCP_LIB_EVENT_ANNOUNCED=6         # MPTCP_EVENT_ANNOUNCED
-declare -rx MPTCP_LIB_EVENT_REMOVED=7           # MPTCP_EVENT_REMOVED
-declare -rx MPTCP_LIB_EVENT_SUB_ESTABLISHED=10  # MPTCP_EVENT_SUB_ESTABLISHED
-declare -rx MPTCP_LIB_EVENT_SUB_CLOSED=11       # MPTCP_EVENT_SUB_CLOSED
-declare -rx MPTCP_LIB_EVENT_LISTENER_CREATED=15 # MPTCP_EVENT_LISTENER_CREATED
-declare -rx MPTCP_LIB_EVENT_LISTENER_CLOSED=16  # MPTCP_EVENT_LISTENER_CLOSED
-
-declare -rx MPTCP_LIB_AF_INET=2
-declare -rx MPTCP_LIB_AF_INET6=10
-
-# These variables are used in some selftests, read-only
 declare -rx MPTCP_LIB_EVENT_CREATED=1           # MPTCP_EVENT_CREATED
 declare -rx MPTCP_LIB_EVENT_ESTABLISHED=2       # MPTCP_EVENT_ESTABLISHED
 declare -rx MPTCP_LIB_EVENT_CLOSED=3            # MPTCP_EVENT_CLOSED


