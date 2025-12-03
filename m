Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C155D352F8C;
	Wed,  3 Dec 2025 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778630; cv=none; b=N9cU3wRBQ+P1pdgB4SOTDZzTNvtgqAaNiTa24qvaYDGay5pnthACbS2qkASWzP7OYhH2rqMdP9PFARrNDeyg6Y9gxicIEVNT7zNMT5epTekqweU/lvan68xIWoSHnB3QDJU3X5e7O+i2/vBk4ZMerFCdNFOZsIS7ehV18mUrKIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778630; c=relaxed/simple;
	bh=S5J7PgYGT/BllPth42AHYMtRC0d6JFUeJsqu+hvV1O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzpBknq5SXnL7bz1oG9VgshYYVIbT7ILwADr1SQehQZsW2AK/SW4f3+bASKUm2YyGE92WEdIH514DsFIry2XZDi1tFEbwJxUh0R4n5dgNQG8HlSnNsOVEcyTwVvH8irPBVuKwDJz9hRWI8OM+HJztG/QWZ+rNS6upr6INw5K2HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjD23QNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjD23QNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB9FC4CEF5;
	Wed,  3 Dec 2025 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778630;
	bh=S5J7PgYGT/BllPth42AHYMtRC0d6JFUeJsqu+hvV1O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjD23QNuSu52FmusR4q5FskCs1VTsfbDEfFy3RvnN0+gYCjivllJCBQA7JLlqXWQ+
	 FAd+9wqUBfRzJnrkrgM9O9AJrcfZdNClGmql31xPUqWdd89SEpoU7uU0LDCaMmGdi7
	 w70haQu6FKPS3Ti95AnscDuGyEuapXBvBypN61kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/568] selftests: mptcp: disable add_addr retrans in endpoint_tests
Date: Wed,  3 Dec 2025 16:20:14 +0100
Message-ID: <20251203152441.109131244@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3394,6 +3394,7 @@ endpoint_tests()
 	# remove and re-add
 	if reset_with_events "delete re-add signal" &&
 	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=0
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 3 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal


