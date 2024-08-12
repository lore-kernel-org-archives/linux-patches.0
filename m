Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C0A134AC;
	Mon, 12 Aug 2024 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479778; cv=none; b=MNodRSC4cDy5vfiOumWTwnopCJvNFV5LPDzvu9c80UbzPFCTOiL1wmyN0MDcmi+IXxpbBpE05e664AY00KdVOMA/p3DPu8IVFFCOUCEE+Q7COxuTYduC/K0K9gjBGUyUz1CSD9wGRRPPtlThnPICqsNMgu5pE17eXTHulch+jKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479778; c=relaxed/simple;
	bh=0yye+fSGPH2VkI48ZEJDTsu1SkHIFbVhkRiCej7l4IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roUascWnFPrJjRZOz6dhFkMRt1yFSvpU2GlZPicjHAY1YmTB19DJQXDvVP4IQwZ6YgWPgfP6+aXBd9xXohktZrycjpTPeSIDlpFHV80iQrBhWja5WbKgBwxx34P6qTcrjgNohMpWPTou5FRZ3S4JL0/eSHgkDATUa4JnaDzcxJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4qiJMez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4qiJMez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68521C32782;
	Mon, 12 Aug 2024 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479777;
	bh=0yye+fSGPH2VkI48ZEJDTsu1SkHIFbVhkRiCej7l4IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4qiJMezqp8qWqIiGcCKN384/Qw5vR/qtUkBoWIphaJ0egYxq4u30sg8dqw0Ie2t3
	 xiK+eZYPwDO6a+mnIkuzGlJaQFw8YY60Xw3c3RawmoW6SHeVnxJaBQiEkCMHwdiBeg
	 BCqbo1l0cOvd7yD0zBGp7nmFfZXCXP0OzvGuG3O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.6 188/189] Revert "selftests: mptcp: simult flows: mark unbalanced tests as flaky"
Date: Mon, 12 Aug 2024 18:04:04 +0200
Message-ID: <20240812160139.389555996@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

This reverts commit 052c9f0c140c78e5d6826688b5d2f33e19db0ae7.

If the test doesn't pass, we can get this error:

  # ./simult_flows.sh: line 275: mptcp_lib_subtest_is_flaky: command not found

This patch is not needed in v6.6: it is there to mark a test as "flaky",
but the MPTCP selftests infrastructure in v6.6 doesn't support them. So
it looks better to revert this patch.

Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -262,7 +262,7 @@ run_test()
 	do_transfer $small $large $time
 	lret=$?
 	mptcp_lib_result_code "${lret}" "${msg}"
-	if [ $lret -ne 0 ] && ! mptcp_lib_subtest_is_flaky; then
+	if [ $lret -ne 0 ]; then
 		ret=$lret
 		[ $bail -eq 0 ] || exit $ret
 	fi
@@ -272,7 +272,7 @@ run_test()
 	do_transfer $large $small $time
 	lret=$?
 	mptcp_lib_result_code "${lret}" "${msg}"
-	if [ $lret -ne 0 ] && ! mptcp_lib_subtest_is_flaky; then
+	if [ $lret -ne 0 ]; then
 		ret=$lret
 		[ $bail -eq 0 ] || exit $ret
 	fi
@@ -305,7 +305,7 @@ run_test 10 10 0 0 "balanced bwidth"
 run_test 10 10 1 25 "balanced bwidth with unbalanced delay"
 
 # we still need some additional infrastructure to pass the following test-cases
-MPTCP_LIB_SUBTEST_FLAKY=1 run_test 10 3 0 0 "unbalanced bwidth"
+run_test 10 3 0 0 "unbalanced bwidth"
 run_test 10 3 1 25 "unbalanced bwidth with unbalanced delay"
 run_test 10 3 25 1 "unbalanced bwidth with opposed, unbalanced delay"
 


