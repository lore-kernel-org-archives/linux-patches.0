Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0995D267386;
	Tue, 26 Aug 2025 11:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207508; cv=none; b=SSFWIYnraruvTEsNuWKMTUe2ne7V2hXVDKr5ZE8FJ80alMOAd0wz2I7CSrIG5C9JEJ3aa3X9z9b30WfsbRoKwtlRv+nxtcxGqaoEP3JoZ2XYhbU235JRVkidYfeBjeuJ6i9DFfApj8gA5q82zg4pV16UsSe2Y7h+bAM7K0s1UqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207508; c=relaxed/simple;
	bh=XyqpZzIoCQiIr2rW1cKCq5/cZjka5kvzJjnAQXtZ61o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkszq0GNlRH5wVXYu7tLV+JRMZfrlYjdT/DCkdAFAfIHQW35E/1oIS/tuh+C0JufPY3zb2lFq4Fjl/vqqQ5LqW3XAuT2dLHRTPBMPw99CvzOfGMBlLDPXi3b/+JycmpXlIpyR4akPbEwaK0D95XTK4QXiPOxcCfkMDL5EhNtzKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ok2RrMoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ok2RrMoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3901EC4CEF1;
	Tue, 26 Aug 2025 11:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207507;
	bh=XyqpZzIoCQiIr2rW1cKCq5/cZjka5kvzJjnAQXtZ61o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ok2RrMoKx7IrnpP2YZ0LpEeP+c6e7m4CE/jCYOyv82nayXz2T9nstn2/X5MvGVFW2
	 wwazX6Y13jrnsKbmldYwSk9kqyKvVA3XKJSctVYxMBUpWfJ1waIvDrZUZl7eGIFPCG
	 GBvxvNAmBgPjz8DibDXCFj+c9B9l5g3C8LUDAQYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 208/457] selftests: mptcp: pm: check flush doesnt reset limits
Date: Tue, 26 Aug 2025 13:08:12 +0200
Message-ID: <20250826110942.506600733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 452690be7de2f91cc0de68cb9e95252875b33503 upstream.

This modification is linked to the parent commit where the received
ADD_ADDR limit was accidentally reset when the endpoints were flushed.

To validate that, the test is now flushing endpoints after having set
new limits, and before checking them.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-3-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -198,6 +198,7 @@ set_limits 1 9 2>/dev/null
 check "get_limits" "${default_limits}" "subflows above hard limit"
 
 set_limits 8 8
+flush_endpoint  ## to make sure it doesn't affect the limits
 check "get_limits" "$(format_limits 8 8)" "set limits"
 
 flush_endpoint


