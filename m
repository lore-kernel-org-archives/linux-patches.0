Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E8446C9;
	Tue, 20 Feb 2024 21:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464727; cv=none; b=dhBLVF0uOpcjx9u6fNwtrQXTdyh1k38ik4KEf+14GKic7UfdZs7vc3I8wbAaTz5vPgq7krW5SZawYKnotsMe/Zz5HrkRlbDfkcC7zmJ85lipfeaFnqAM+2xp5mDYmsDiHq+XicqXVhFzq2TOMPiRPkmwd8d8ia4tLrWYFTLZ1n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464727; c=relaxed/simple;
	bh=LJItLMTcFLY7ldh4PlM87IEcvTrIbHlfhlGtZVN0brw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fr320vBAGgwL2wiIMxJAZZ+owNIKWGq2xSnte4SR9ysULO6/ut4W/zRfDPlvWXeVatES0qqoXPFkakxgJgaDvX969CejVLYOW6IMC2mvjvJB4YBSY7zJZHvbb+bAh2AmL/deeWylASyHni3R15vu14aClnFAmts7vgTIRiRSmLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8EvTxF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8EvTxF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0924C433F1;
	Tue, 20 Feb 2024 21:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464727;
	bh=LJItLMTcFLY7ldh4PlM87IEcvTrIbHlfhlGtZVN0brw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8EvTxF2oTzq8lyw0Z16g6vy/nGFtHqioW5OThnLvzvI8yKocpOUM3IlZ8jhooD4X
	 9urHshlkZXcm2TNDRK/064yC+vTG9kkeZozi0/8N35IHAsS4lMtwguoFkN6J7f15Ad
	 RyT0RUyEF6pLt7OhQIFuDsEqwfUkWRXYGL+dko3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 117/309] selftests: mptcp: add missing kconfig for NF Filter
Date: Tue, 20 Feb 2024 21:54:36 +0100
Message-ID: <20240220205636.841585785@linuxfoundation.org>
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


