Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED6835A94D;
	Wed,  3 Dec 2025 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779407; cv=none; b=IGH9lrEUYlyhtyzbX1bXDVkpTex4XqUfe7bhTHSSdgTQnwoo9jlX1qaW25zeURsXQq8QHXtEjSctbAvkwfh1xQVjaVuEpPfCUcut0PFsQ+jdgftlCPVbN60lWAVLUWPFbbN1jS+QJlFUTsLgEM8JGbuWGyKZko5AR5Ed357ljdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779407; c=relaxed/simple;
	bh=0BC8lmV6gOoOZ7i9g71dCKnzIqIGDhNJzWjEmFh+X3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRcOhqMIkfP+WPGHQpRjJmiVRMVrQAQhcvbW27KA0mRHh+qAYZRZh6t10NZ6zsOiYGlUhBdlTGlgKePzYDuQBdSmn9vYgMoRXBfvGat7wVOlMH0OLgp/3ojRb2cg8xZwg+ciPst9a//BFWM3sGqfugKeC7Vv+zqnpe4QFRvRCHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAHBQpbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAHBQpbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA43DC4CEF5;
	Wed,  3 Dec 2025 16:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779407;
	bh=0BC8lmV6gOoOZ7i9g71dCKnzIqIGDhNJzWjEmFh+X3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAHBQpbEysYxxZ/iu11Y46gImfNY6leo0suaAfUDm5Km+EwZItMYhgqwgwaRb4ruv
	 p0MXTsXnEVoJcwPHqwis/Rl4P52TUM8NKIYq6k/A57fAWSsgxyfIWCYLz7BcwxV7Fb
	 bk6aBRAgE5rLjtH4RkTSPf6kBNvlU9HN5QU7Iir0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/568] selftests: traceroute: Use require_command()
Date: Wed,  3 Dec 2025 16:23:37 +0100
Message-ID: <20251203152448.598142616@linuxfoundation.org>
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
index de9ca97abc306..9cb5e96e64333 100755
--- a/tools/testing/selftests/net/traceroute.sh
+++ b/tools/testing/selftests/net/traceroute.sh
@@ -209,11 +209,6 @@ setup_traceroute6()
 
 run_traceroute6()
 {
-	if [ ! -x "$(command -v traceroute6)" ]; then
-		echo "SKIP: Could not run IPV6 test without traceroute6"
-		return
-	fi
-
 	setup_traceroute6
 
 	# traceroute6 host-2 from host-1 (expects 2000:102::2)
@@ -278,11 +273,6 @@ setup_traceroute()
 
 run_traceroute()
 {
-	if [ ! -x "$(command -v traceroute)" ]; then
-		echo "SKIP: Could not run IPV4 test without traceroute"
-		return
-	fi
-
 	setup_traceroute
 
 	# traceroute host-2 from host-1 (expects 1.0.1.1). Takes a while.
@@ -316,6 +306,9 @@ do
 	esac
 done
 
+require_command traceroute6
+require_command traceroute
+
 run_tests
 
 printf "\nTests passed: %3d\n" ${nsuccess}
-- 
2.51.0



