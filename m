Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7F20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0409AC433C8;
	Fri, 21 Jul 2023 19:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967543;
	bh=3zVdEPmhWZpvh1VWga2YXXEmRLRqY05hm+WocRZXySY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1MnLwaKI+EfnWI4mQDSqfSgNqo8j7aZPWNmtnbyJ7OSzHTO6tlcIqAFqPHVrB+r/
	 thxOFQbT9GnS0vBnqCSFHYCqRpAq6l0SnNbwf4wWtYfG/NLDHKWvfpV+nhqjbDO5Cl
	 0q6dXjmAZwc1DVWw2kNWl7/eSH2z1OBJEBbiO1fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 198/223] selftests: mptcp: userspace_pm: use correct server port
Date: Fri, 21 Jul 2023 18:07:31 +0200
Message-ID: <20230721160529.320212562@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit d8566d0e03922217f70d9be2d401fcb860986374 upstream.

"server4_port" variable is not set but "app4_port" is the server port in
v4 and the correct variable name to use.

The port is optional so there was no visible impact.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: ca188a25d43f ("selftests: mptcp: userspace PM support for MP_PRIO signals")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -847,7 +847,7 @@ test_prio()
 	local count
 
 	# Send MP_PRIO signal from client to server machine
-	ip netns exec "$ns2" ./pm_nl_ctl set 10.0.1.2 port "$client4_port" flags backup token "$client4_token" rip 10.0.1.1 rport "$server4_port"
+	ip netns exec "$ns2" ./pm_nl_ctl set 10.0.1.2 port "$client4_port" flags backup token "$client4_token" rip 10.0.1.1 rport "$app4_port"
 	sleep 0.5
 
 	# Check TX


