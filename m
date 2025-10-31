Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E8F32C936;
	Fri, 31 Oct 2025 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919457; cv=none; b=QzupwiJnjLmxcg7iJXOTzhY6AeeumW7sANJxKwJCEIdkpORmwuE3GJLPjwb3Qcbppq9hNxx30Fr6C/CTyGby/PibPyNnnA051rRnv/r96oyhdZ7hcw0QowwM6mjwvMcx8Mg08AmLV9MxdYRCkOmTkJRNkFxFpK1WAOsPK32WH+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919457; c=relaxed/simple;
	bh=d3t1QroaTh8CJ4LRpPgRqdcrcQ9vf4d5r8tjPp9WjV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoAFl/ByppBO24UQmV1ETvRZdyBnycOH9xMl70jwpy3yyid1QaSHdTdlDt8UZ8mt+K0QBboUfl7lLARv34qOkcNuceYOk/PC8gfk9YsvY6AwDGae5m8MJfq9RcEbamulYwPihNZh4GT8Nb081Kd51WWSX2khwmUN5Utpn+XzOHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tv1K6I4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tv1K6I4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7F5C4CEE7;
	Fri, 31 Oct 2025 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919456;
	bh=d3t1QroaTh8CJ4LRpPgRqdcrcQ9vf4d5r8tjPp9WjV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tv1K6I4suyp/+8/8zryiYmiGCKLmDGODrZ9h1yVKvAx0r6Kr0hCgJ4eY4YCJdnpd6
	 ACcNMUyCWBu11MC56n3GEwfFEz1Qi3GXu6FIWL8p7XtwHF9/99faejw5bu1YI8JSIX
	 rV9IJ3w1rQSt9OjPSza5unYpMCSCDpGiuo5KEXnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 25/40] selftests: mptcp: disable add_addr retrans in endpoint_tests
Date: Fri, 31 Oct 2025 15:01:18 +0100
Message-ID: <20251031140044.623816103@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit f92199f551e617fae028c5c5905ddd63e3616e18 ]

To prevent test instability in the "delete re-add signal" test caused by
ADD_ADDR retransmissions, disable retransmissions for this test by setting
net.mptcp.add_addr_timeout to 0.

Suggested-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-6-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c3496c052ac3 ("selftests: mptcp: join: mark 'delete re-add signal' as skipped if not supported")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3824,6 +3824,7 @@ endpoint_tests()
 	# remove and re-add
 	if reset_with_events "delete re-add signal" &&
 	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=0
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 3 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal


