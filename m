Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C2A14F9DA;
	Tue, 20 Feb 2024 21:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462949; cv=none; b=VblY3W02xt89uUwo7ESpQ8PaQmi+Xm75Iwa0lD2UgHZTx8Tuuv54LbXSGHzqR4XjUUXzgBox1aT7vUshEGOTQscb5fwxIROzUp6FU7wZhHhrAykXZrmu0HXu9hxyRbx2QCAYofzORQLX7/jvz9FypfOZ5dv+rb5JP2yLu2jGVjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462949; c=relaxed/simple;
	bh=Jh0xuAgkkwKcEVjw2KB7wGSSBnuoM/AimcLlNCY5II4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G98Gc2E3Tfg7FIwPVvCg1eED0BnAIVIkjxMSzHceFXVQOuVXQgjywFARUCYGKW9t7wfXETHhOmgJykioAmP9yFDWyDr+BB1pYiO/CXjxfzkMIqXunJ+YT2B1mF8jpw6izzhWTkjycj0HmZDD5AuYdv1ldNupoN9w8xToFdX4mJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtLXPbg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtLXPbg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D662BC433C7;
	Tue, 20 Feb 2024 21:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462949;
	bh=Jh0xuAgkkwKcEVjw2KB7wGSSBnuoM/AimcLlNCY5II4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtLXPbg0Qy9QpRRcPtmCQAI8Eip65ptCYCubghyqowcBud3OAmUi6uNcmnPIHW9ep
	 qyTaWDSM3pCsbXJ4fR4Kh5ma0QTGUpcZqZZX6/rcHTq4WRxQwpzFBxy2PCZ+bz1gLv
	 9d0C26cSsYjvSNBO40eRRdzQFC0iEndLNM2MmRlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 070/197] selftests: mptcp: add missing kconfig for NF Mangle
Date: Tue, 20 Feb 2024 21:50:29 +0100
Message-ID: <20240220204843.175560228@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 2d41f10fa497182df9012d3e95d9cea24eb42e61 upstream.

Since the commit mentioned below, 'mptcp_join' selftests is using
IPTables to add rules to the Mangle table, only in IPv4.

This KConfig is usually enabled by default in many defconfig, but we
recently noticed that some CI were running our selftests without them
enabled.

Fixes: b6e074e171bc ("selftests: mptcp: add infinite map testcase")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-4-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -23,6 +23,7 @@ CONFIG_NFT_SOCKET=m
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_MULTIPLE_TABLES=y
 CONFIG_IP_NF_FILTER=m
+CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_IP6_NF_FILTER=m


