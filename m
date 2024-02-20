Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4038714AD0F;
	Tue, 20 Feb 2024 21:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464734; cv=none; b=PnRfYrxzL1gAuPu49faUxUYmeX1lT8AOmAn8r9q2zzIt0i+VF4wvYPoIil5HcQWUMDlbnVIquwVC7h4sjLZ7ZdSJyja2aROGmctrWFZLQFWZg6cSLSKCiNOq8it/FFo4+wehDdpFT6MF65tLdDdaBk0wvrO5BL2QhNHd1gKNkuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464734; c=relaxed/simple;
	bh=ZGdQtnNn20ewUfhRA5ekEVU1Sh2CqWGz6gbcvtbsFWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnSX5Dsb3qijoIKQvKP02YNms8YvUD93/wU/z6aPBQ1KAX5M7txl+Qk8aG0G7pWQh8+2dQBL+1T2innzS2CMv8jYq3E47qTZBaaq7IjRVYS9RSD763WPeCtbjoxWHV1eoEDTYbwMe8xFoLmNfOIEXf+OewvieSsmNRkYEcrdpmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugtenlfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugtenlfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D83C433C7;
	Tue, 20 Feb 2024 21:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464733;
	bh=ZGdQtnNn20ewUfhRA5ekEVU1Sh2CqWGz6gbcvtbsFWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugtenlfq2ZQyYAPFMEjRXJ3iVLPSo4aktpD5kV/S59AYNSuXETkrPRGiuerMweJhG
	 DvhudGKAMEXep3COoA1Alt3rlCZ+8hkrER10+YNwqy5vX/87q+ZOErfdKVIDPgGKUz
	 Y9lbdqxG+Tl9B4KoDTW9Rt65Sw6ibOdH86CzPkqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 119/309] selftests: mptcp: add missing kconfig for NF Mangle
Date: Tue, 20 Feb 2024 21:54:38 +0100
Message-ID: <20240220205636.899802493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


