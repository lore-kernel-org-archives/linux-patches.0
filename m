Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5457020F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0DBC433C8;
	Fri, 21 Jul 2023 19:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967546;
	bh=w2rkzb4Guf2O8Lwab5b7FrP6HKqGDDF5uA1mgG/Cbxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcO9YuZ90C9SIK9l2JEuj9Ufdw0V1pWe1/b2fFvNR397ubl0EGjYekhw/5vUd83Ld
	 DScYWJL4yDJpRo0ceOqEOmMpp1/W2qtVWWW8uzHmmOtpUwONDcOTcHUdayBLo/w5cM
	 CHt9YBly/mUF1lKvPHztNr7xmZ/sgHqcO78VEidQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 199/223] selftests: mptcp: userspace_pm: report errors with remove tests
Date: Fri, 21 Jul 2023 18:07:32 +0200
Message-ID: <20230721160529.361423250@linuxfoundation.org>
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

commit 966c6c3adfb1257ea8a839cdfad2b74092cc5532 upstream.

A message was mentioning an issue with the "remove" tests but the
selftest was not marked as failed.

Directly exit with an error like it is done everywhere else in this
selftest.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 259a834fadda ("selftests: mptcp: functional tests for the userspace PM type")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -387,6 +387,7 @@ test_remove()
 		stdbuf -o0 -e0 printf "[OK]\n"
 	else
 		stdbuf -o0 -e0 printf "[FAIL]\n"
+		exit 1
 	fi
 
 	# RM_ADDR using an invalid addr id should result in no action
@@ -401,6 +402,7 @@ test_remove()
 		stdbuf -o0 -e0 printf "[OK]\n"
 	else
 		stdbuf -o0 -e0 printf "[FAIL]\n"
+		exit 1
 	fi
 
 	# RM_ADDR from the client to server machine


