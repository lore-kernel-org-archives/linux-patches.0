Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0011151CCC;
	Tue, 20 Feb 2024 21:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463641; cv=none; b=kMlQc/IIfwlDn5liwywCuXLSncKf6UhrKWis5MIBi4h8ckmG8NJ4JXniC/gmHrsGJ+gJ3UkDDZM0DRGjoMyHhe/cQMpnueF4wUx0yfwOLUW1eMp1U7IVDI88GKS3LosxZDc+kBvf+uctdwo1NGGqOkVnu66OVov9/ou2YLPjAXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463641; c=relaxed/simple;
	bh=klzTxLfbgrDa0MvYlmdxMXlGgEfYRbxvZ2IPNhuq1rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0GFXm38pnViAbKBw6vKMPaDi4a/hs+6DN9ygB7wRf7QgQGbQF0gQ/nkVJKl3hTw6qPncPpoAlcxn+8Bmcq1O56qug/JxCJuOi+dzqU3l5dyDHsoLxynlkrXXzz5T3KOtoo15ZVAk93Vhrn/MsZIw4Y4OQ+xrEylUCxCEGPLpMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuiedNhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuiedNhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDEDC433F1;
	Tue, 20 Feb 2024 21:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463640;
	bh=klzTxLfbgrDa0MvYlmdxMXlGgEfYRbxvZ2IPNhuq1rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuiedNhBw2yubCZPl/BFeGRV/V2cdy2KN1tGjjHVWv3TA8cH00hYfRAsewvsLIwnD
	 WPaaUIQWgBOkk+qfZqfGwg48KAcJZVhOcxVOijNEqXw5BbuPvb5DLaRfMaeiG1MsV7
	 5zoSSmHT7R7ve1xju20oLq7WVgfkXoiCOFFUcZOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 106/331] selftests: mptcp: add missing kconfig for NF Filter
Date: Tue, 20 Feb 2024 21:53:42 +0100
Message-ID: <20240220205640.929242667@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 3645c844902bd4e173d6704fc2a37e8746904d67 upstream.

Since the commit mentioned below, 'mptcp_join' selftests is using
IPTables to add rules to the Filter table.

It is then required to have IP_NF_FILTER KConfig.

This KConfig is usually enabled by default in many defconfig, but we
recently noticed that some CI were running our selftests without them
enabled.

Fixes: 8d014eaa9254 ("selftests: mptcp: add ADD_ADDR timeout test case")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -22,6 +22,7 @@ CONFIG_NFT_TPROXY=m
 CONFIG_NFT_SOCKET=m
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_MULTIPLE_TABLES=y
+CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_NET_ACT_CSUM=m


