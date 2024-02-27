Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2264E13B293;
	Tue, 27 Feb 2024 13:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041102; cv=none; b=OBWpjQW3yzOCu0IkJhGjWjLB5o9nRMqSFLzQwaFNpWn4BAU+pFW10yfqcoSDfSXANWaMtgTqOjRzDZt+z1nGghZNKBUpKG5n+O3tkHIGPsxXBIGWWKu0gNhq3nhrwO6leFD9OKxHbByWz3iyO3hmyOxwbdjcvFZWBiWU0tbeFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041102; c=relaxed/simple;
	bh=r/8Rfk+wx2pvpQ4oAKPjXvu/5mDQKUYS/wuUNbW0hUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usqZdI9/JTQpm7K5loqfWisKo31gxVA8D43rUVq0uwpzAxL7gvXevBZ3xrx+EwZ9kvcYPELznw8+89tcZIplIXey1g/gcYB62dIiJ9K25IRA6fEiCHqzLaoBHE3K8gMQb75XmX2MNw6QuQ9yvY/oyNahVW6JYzzW6ltZDMcyBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpYKPHUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpYKPHUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66CFC43394;
	Tue, 27 Feb 2024 13:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041102;
	bh=r/8Rfk+wx2pvpQ4oAKPjXvu/5mDQKUYS/wuUNbW0hUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpYKPHUq8wMyT5cHLOaOdo8dn9orAzE7ZIPz9QaFrfYTYGHZ9ZbeQVvJvPBiif2bi
	 9+HkY7oYuUsjygR4DHN36ny7kBC0mntieHAeuwy2MsIpzqz6xUfC2dT/tMQs2BjGGz
	 m1iNTMwJiIdX0aZg2qX/+4N6kN7EHe7LdlP7SGZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 221/334] selftests: mptcp: pm nl: also list skipped tests
Date: Tue, 27 Feb 2024 14:21:19 +0100
Message-ID: <20240227131637.903583489@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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
 tools/testing/selftests/net/mptcp/pm_netlink.sh |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -194,6 +194,12 @@ subflow 10.0.1.1" "          (nofullmesh
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


