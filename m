Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1163AB277;
	Mon, 23 Mar 2026 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282387; cv=none; b=RCj4E109/nrDVR8qnX3tGURQpOv7km/MTxcX2vBxPfnnyoORkQMnFOsSQWpiuUq8kkzu4sqQzrDbGyQGAR5dt0qrjshis2QGT7gaejG/UumECR+/qP8CiZEb1qTn/UclBvrbquZac7l7z1lrUrlIC/WlxUz9HA594u7V4MSH9U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282387; c=relaxed/simple;
	bh=BzZl9UXnLdMV+IlRjl6zIYuV0xc87b49TWOi+jWJhYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDf3+VKMXL4oEdcfZkg3YDCqegV6rvrXMBrsVEGcaM8jYgefZvsm2BsUG0DvSxOnKRxnWQccYMngPmbjFcWt6c/c5eY/zXDLwUP4a0L5nu9mKoe3niKntt28VnvH71Y+IXuY0BbozCV89wuyvWZwA7Zvf/EjZAr0K5SAu+0Mo6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2W+XgWEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2W+XgWEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83136C4CEF7;
	Mon, 23 Mar 2026 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282386;
	bh=BzZl9UXnLdMV+IlRjl6zIYuV0xc87b49TWOi+jWJhYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2W+XgWEqHtNjNYXOr6hxEUthpFA5hvDILg/JQe/8pPjeyVdGL5RshvSJ346ZrmsOp
	 4KPEMGIPSS9LBhrBeyEUmBH5GCIu0dhFfbA+wu77IJ5tGZmf7CzBr9HWbpVxg4iUCB
	 BpirnJOXY6rAVCGOP3jFq6VYU3gSz4CyW4cRnLIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 095/481] selftests: mptcp: join: check removing signal+subflow endp
Date: Mon, 23 Mar 2026 14:41:17 +0100
Message-ID: <20260323134527.595315873@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 1777f349ff41b62dfe27454b69c27b0bc99ffca5 upstream.

This validates the previous commit: endpoints with both the signal and
subflow flags should always be marked as used even if it was not
possible to create new subflows due to the MPTCP PM limits.

For this test, an extra endpoint is created with both the signal and the
subflow flags, and limits are set not to create extra subflows. In this
case, an ADD_ADDR is sent, but no subflows are created. Still, the local
endpoint is marked as used, and no warning is fired when removing the
endpoint, after having sent a RM_ADDR.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 85df533a787b ("mptcp: pm: do not ignore 'subflow' if 'signal' flag is also set")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-5-4b5462b6f016@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2389,6 +2389,19 @@ remove_tests()
 		chk_rst_nr 0 0
 	fi
 
+	# signal+subflow with limits, remove
+	if reset "remove signal+subflow with limits"; then
+		pm_nl_set_limits $ns1 0 0
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,subflow
+		pm_nl_set_limits $ns2 0 0
+		addr_nr_ns1=-1 speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr 0 0 0
+		chk_add_nr 1 1
+		chk_rm_nr 1 0 invert
+		chk_rst_nr 0 0
+	fi
+
 	# addresses remove
 	if reset "remove addresses"; then
 		pm_nl_set_limits $ns1 3 3


