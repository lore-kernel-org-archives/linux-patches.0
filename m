Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D3A134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7AEC433C8;
	Mon, 26 Jun 2023 18:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803433;
	bh=qK7TlT94elqx1MVlR8o1gjntJshecXnUQuO2zEh6bMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3nHwHjqHkeCiOPeZlLOGJGD0etZPi3CT+JOgOHN5iZmeH0n+XqL1E33gKXeu3Suw
	 nBsPb0KSNmy71E7ySx5iwjAbKWQJqJRx3EGPu1iej/nz6yfrbgjqcvGgcpc72/sjR+
	 +HFZWolSkBQXQk6ElH15WoMe4meCXwPjuYlHhjak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 031/199] selftests: mptcp: userspace pm: skip if ip tool is unavailable
Date: Mon, 26 Jun 2023 20:08:57 +0200
Message-ID: <20230626180806.985910348@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

commit 723d6b9b12338c1caf06bf6fe269962ef04e2c71 upstream.

When a required tool is missing, the return code 4 (SKIP) should be
returned instead of 1 (FAIL).

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 259a834fadda ("selftests: mptcp: functional tests for the userspace PM type")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -8,7 +8,7 @@ mptcp_lib_check_mptcp
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Cannot not run test without ip tool"
-	exit 1
+	exit ${KSFT_SKIP}
 fi
 
 ANNOUNCED=6        # MPTCP_EVENT_ANNOUNCED


