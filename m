Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9CE13B7BE;
	Tue, 27 Feb 2024 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041179; cv=none; b=D9pbqS1OVKjpBN8KI3jN/bLP76Tlp+HEdqK0JfmMspCAQ379GKHqTzgdvnLieldIpGKZouyPjG/Jm6o6AGhWofa2O+qeTyCkmbIyED0K13mjBWFDVe8WKbcBajC1Mg8pqg0U4rvhdKtkwmztLQMjwe28p7NM7ksNHfb+K3Oexzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041179; c=relaxed/simple;
	bh=QriDc2hQKllhtX91h6rfo9+vFg9afQl0T3/Ww245gpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDvMcXVHjNeb/pEVzXgaGgITN4DVvThN/a7i3HXafPAtgT+U+V+bkXPgR8+XsXwhR2S+oie/sbyeJqQ0xRLUiApWokIrGTBokCPwWIBXLc2X1/t+9yCaRvxGJaGkGv+YDVaf0hFHnPt2H28c3MMs6hygCHcCW/0bHKXzXebobkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+Dal1V/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+Dal1V/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3DDC433C7;
	Tue, 27 Feb 2024 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041178;
	bh=QriDc2hQKllhtX91h6rfo9+vFg9afQl0T3/Ww245gpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+Dal1V/4LAfIvp7BRaxTj6E2+uX9eQ7Wg9ob2Xzo4cFiliM6s4UijftY34akBSa5
	 mRmNzhh38nESctw+MGeEAlsmVXBJ3ESM8FpdKRbs8O70xNOrcwp8RYV4SbfDUrX0e9
	 3IIn+r0kRcp/tHPV8YCR/t99ZgbPw7joyBENKO+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 219/334] selftests: mptcp: userspace_pm: unique subtest names
Date: Tue, 27 Feb 2024 14:21:17 +0100
Message-ID: <20240227131637.839013727@linuxfoundation.org>
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

commit 2ef0d804c090658960c008446523863fd7e3541e upstream.

It is important to have a unique (sub)test name in TAP, because some CI
environments drop tests with duplicated names.

Some subtests from the userspace_pm selftest had the same names. That's
because different subflows are created (and deleted) between the same
pair of IP addresses.

Simply adding the destination port in the name is then enough to have
different names, because the destination port is always different.

Note that adding such info takes a bit more space, so we need to
increase a bit the width to print the name, simply to keep all the
'[ OK ]' aligned as before.

Fixes: f589234e1af0 ("selftests: mptcp: userspace_pm: format subtests results in TAP")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -75,7 +75,7 @@ print_test()
 {
 	test_name="${1}"
 
-	_printf "%-63s" "${test_name}"
+	_printf "%-68s" "${test_name}"
 }
 
 print_results()
@@ -555,7 +555,7 @@ verify_subflow_events()
 	local remid
 	local info
 
-	info="${e_saddr} (${e_from}) => ${e_daddr} (${e_to})"
+	info="${e_saddr} (${e_from}) => ${e_daddr}:${e_dport} (${e_to})"
 
 	if [ "$e_type" = "$SUB_ESTABLISHED" ]
 	then


