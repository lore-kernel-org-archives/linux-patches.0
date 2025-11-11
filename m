Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4AC27FD72;
	Tue, 11 Nov 2025 01:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824504; cv=none; b=Fl3mEpxxc+Mzlog4HeAITolm72/6L6ze3h1cf0AgVIrYw/j6nFSaGinR53T2vZCtp4XeHJfe667XzrjTZEb9c1JafX+8vNxzkKV+f96sORZjsVE000u/RoIqIlBZ9cLy4DNCfkZFTazm9tpAqWsrp0vds6/iSgzHpxmLTM21hC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824504; c=relaxed/simple;
	bh=0p0q1bZK2NdKQvcSxE0KsrX5XU7MCufUTJkuZa7i3XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwrH0zGINlE9pF/F5jAbd3UYnW5CQe7Peybm18wvFa/H1hGbHf73/TrgqeaT1V59Xk/ZBN6QY1tIIYCTmtGvarStfjOUlT08x6hBdNZ4DFnt5zuwqbTiqSiWmMcz9oC9+UqyGsMZ7Klw+Hi0DPqk5h3rByIiXmwd2w54+Ngzis8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0KJvnUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0KJvnUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D25C116D0;
	Tue, 11 Nov 2025 01:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824504;
	bh=0p0q1bZK2NdKQvcSxE0KsrX5XU7MCufUTJkuZa7i3XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0KJvnUjFm35GuIbdg9GtLqhordzrMVTeyQPgXT5dA3xz6hJIU8Vfdcx1tEohUVdL
	 OCVeGrntU9n916+WXpgIXvI9izIJtNi+Q0+BIqZpl23YwN6WBIOSYl3gDAOPM1DqJ5
	 1k8bT8AQbuIhKVhoTSt4Nr0e3Of3+5m6FJ3B1AlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 513/849] selftests: traceroute: Use require_command()
Date: Tue, 11 Nov 2025 09:41:23 +0900
Message-ID: <20251111004548.833645102@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 47efbac9b768553331b9459743a29861e0acd797 ]

Use require_command() so that the test will return SKIP (4) when a
required command is not present.

Before:

 # ./traceroute.sh
 SKIP: Could not run IPV6 test without traceroute6
 SKIP: Could not run IPV4 test without traceroute
 $ echo $?
 0

After:

 # ./traceroute.sh
 TEST: traceroute6 not installed                                    [SKIP]
 $ echo $?
 4

Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250908073238.119240-6-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/traceroute.sh | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/traceroute.sh b/tools/testing/selftests/net/traceroute.sh
index 282f14760940d..b50e52afa4f49 100755
--- a/tools/testing/selftests/net/traceroute.sh
+++ b/tools/testing/selftests/net/traceroute.sh
@@ -203,11 +203,6 @@ setup_traceroute6()
 
 run_traceroute6()
 {
-	if [ ! -x "$(command -v traceroute6)" ]; then
-		echo "SKIP: Could not run IPV6 test without traceroute6"
-		return
-	fi
-
 	setup_traceroute6
 
 	# traceroute6 host-2 from host-1 (expects 2000:102::2)
@@ -268,11 +263,6 @@ setup_traceroute()
 
 run_traceroute()
 {
-	if [ ! -x "$(command -v traceroute)" ]; then
-		echo "SKIP: Could not run IPV4 test without traceroute"
-		return
-	fi
-
 	setup_traceroute
 
 	# traceroute host-2 from host-1 (expects 1.0.1.1). Takes a while.
@@ -306,6 +296,9 @@ do
 	esac
 done
 
+require_command traceroute6
+require_command traceroute
+
 run_tests
 
 printf "\nTests passed: %3d\n" ${nsuccess}
-- 
2.51.0



