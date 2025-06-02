Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A522A7E3;
	Mon,  2 Jun 2025 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876246; cv=none; b=ryKbJ7ALBbw0BYiXJvv0nywmPDFgHiSOZ2w6gsRpaWkOQXvf6Fwsmsym4ODplTSbiAzvRHVIycxsPE475u4WcN6byxmzqmH8aWKw7mVazXapKiiDy9KgSz3vmBSZk7Vx4WAqWE36OF6EMgyw5GnA0vMNXZAy6gQ+0CIZcugZN8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876246; c=relaxed/simple;
	bh=/K7TN5r393MA4OT8eq+ttH1VtCoUvi+ukjGN/30BRZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjHHE2DyWjUoZuWZcyiFheVj9SDUQTzF9zMH5TDkDNo5Ajpx+HUP1+NCJ2B0glVeoJ9OJ1+P1YX05ow1o4QFonHuk+jhLcE2/044UqE5giIKHCmU+C+46clxGbPhJKNrkpR+znDJPietXo4yLRZQbOjcsYRVeL1I66MuNZZ07B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtJJiH+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtJJiH+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A96FC4CEEE;
	Mon,  2 Jun 2025 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876246;
	bh=/K7TN5r393MA4OT8eq+ttH1VtCoUvi+ukjGN/30BRZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtJJiH+lWY+PcNBYnW39oGtW5Bqmv65VvktNenAYDB3nT2InQmWI2wWsXXd0t/2vY
	 yWOQNsAxIeYWEeyaulHCSFtXBK+GjLjRO1B9xGZ9dV+AEC4faqr1gMnc+bynh+fb6M
	 hg+wXCN96bRlkNZgs4afa34pt7HWY4PJyMUuNg0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Krakauer <krakauer@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/207] selftests/net: have `gro.sh -t` return a correct exit code
Date: Mon,  2 Jun 2025 15:47:40 +0200
Message-ID: <20250602134302.185624215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Krakauer <krakauer@google.com>

[ Upstream commit 784e6abd99f24024a8998b5916795f0bec9d2fd9 ]

Modify gro.sh to return a useful exit code when the -t flag is used. It
formerly returned 0 no matter what.

Tested: Ran `gro.sh -t large` and verified that test failures return 1.
Signed-off-by: Kevin Krakauer <krakauer@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250226192725.621969-2-krakauer@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gro.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/gro.sh b/tools/testing/selftests/net/gro.sh
index 342ad27f631b1..e771f5f7faa26 100755
--- a/tools/testing/selftests/net/gro.sh
+++ b/tools/testing/selftests/net/gro.sh
@@ -95,5 +95,6 @@ trap cleanup EXIT
 if [[ "${test}" == "all" ]]; then
   run_all_tests
 else
-  run_test "${proto}" "${test}"
+  exit_code=$(run_test "${proto}" "${test}")
+  exit $exit_code
 fi;
-- 
2.39.5



