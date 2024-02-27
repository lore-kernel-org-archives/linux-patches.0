Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E609C13B7AB;
	Tue, 27 Feb 2024 13:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042155; cv=none; b=p2uYrsECAQtNG6jpJlc7g9UEYh4h8zwo8cdpf5g4OTkbgvrJP8auuiywgR+8JeA49NKVZJ3JExnACLIiMWLBSTEGD0Lijns75hsvq14o4b6ZkTeK8VMmxgeNOA+rXalwijdC/kdX6drUtefpcdGOE9FGadwJYjRG9RWpj3olScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042155; c=relaxed/simple;
	bh=9EUnLz8NR7T3gjXwd/OSnpNrD8sCSxE87kRhv6lo4wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GptUaojGDF8v2ECKBmcUVqe6xYT1p3vaF+I/KjNwaocRLJtJTeW4GtzCEmqvkuGDdpdNe5clFHEvP6SFtl3T8f1qIgBI8iiqSnYhJDAfQoo/SOxBedpAgT4bcx9fr/FHo+MPR48eTdGDYtjFMJPhontswThqfhWDaxk4yiiNDQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1whhA8YY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1whhA8YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC0AC433F1;
	Tue, 27 Feb 2024 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042154;
	bh=9EUnLz8NR7T3gjXwd/OSnpNrD8sCSxE87kRhv6lo4wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1whhA8YYtCEHO44SzyqkImC+gCPEKhqjkmkVDeLFwDFN6CGWRBWkeF8iM0gn3YAGb
	 uIUukdhhaSVD1eHcB6nksyxi2jIACwzNpL4OfXZoYe2Gas50NHbP8y36sTHIq/msH4
	 iJgTCh9ky4chp5K+7lr7eIPRC5e4e8JnzMOm0Z7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 199/299] selftests: mptcp: pm nl: also list skipped tests
Date: Tue, 27 Feb 2024 14:25:10 +0100
Message-ID: <20240227131632.217904897@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

commit d2a2547565a9f1ad7989f7e21f97cbf065a9390d upstream.

If the feature is not supported by older kernels, and instead of just
ignoring some tests, we should mark them as skipped, so we can still
track them.

Fixes: d85555ac11f9 ("selftests: mptcp: pm_netlink: format subtests results in TAP")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 8f4ff123a7eb..79e83a2c95de 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -194,6 +194,12 @@ subflow 10.0.1.1" "          (nofullmesh)"
 	ip netns exec $ns1 ./pm_nl_ctl set id 1 flags backup,fullmesh
 	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow,backup,fullmesh 10.0.1.1" "          (backup,fullmesh)"
+else
+	for st in fullmesh nofullmesh backup,fullmesh; do
+		st="          (${st})"
+		printf "%-50s%s\n" "${st}" "[SKIP]"
+		mptcp_lib_result_skip "${st}"
+	done
 fi
 
 mptcp_lib_result_print_all_tap
-- 
2.44.0



