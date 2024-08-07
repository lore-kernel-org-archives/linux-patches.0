Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20613EA9A;
	Wed,  7 Aug 2024 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043178; cv=none; b=YbNm3OsXXaKZsngpo95oCIFCSDZjr0OFjl7OWP54H4xpl45Kg0Yf1Z5n6VMS3fIRMomH5oU+IsXbBu1oSzM/r3ieWCHlNQZzi8xC3iBR+mxg9RagGzLuEWOz9k1l3SYfTTh4AxzFh+xObeMrLLVcFwNJ0S+Bst4pA6EEtHotNuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043178; c=relaxed/simple;
	bh=1NcZmsl52LR4C5hbT/g7UuiSMQSvS/DKComZXT9hEHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHbyPM3DVP39Bj2Jfwr8lagaPeWdZUslM5yt8W6OAytJzEPik170Oz1WIQn2Dl1ZjJs6wKEkjHBukRybzzrG7pA8+JtyiBoSvXLgHqaG30iwa0Hwk6HS81W/zcKRniPHETGIML6ICbuDjsJTSRizI2GZEXg4h2wGkoihDfXhYNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIoo1smv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIoo1smv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1200FC32781;
	Wed,  7 Aug 2024 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043178;
	bh=1NcZmsl52LR4C5hbT/g7UuiSMQSvS/DKComZXT9hEHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIoo1smvlLvRFO1uzx7kv0fKI8L36JI/NPelSOS0QiTEWKGm8BLAPwss1Keq2CFkF
	 nQIddU/+TrMug9C/+NDgDOL/wtYh4tUtct+RfLYYMFdj1F9HqoUVSAMBNCZDyOwj5r
	 u0dLlmSlVlT1xHQnTqr+f94vDuMBOdW5dqsSO+Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.10 120/123] selftests: mptcp: fix error path
Date: Wed,  7 Aug 2024 17:00:39 +0200
Message-ID: <20240807150024.817326637@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 4a2f48992ddf4b8c2fba846c6754089edae6db5a upstream.

pm_nl_check_endpoint() currently calls an not existing helper
to mark the test as failed. Fix the wrong call.

Fixes: 03668c65d153 ("selftests: mptcp: join: rework detailed report")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -661,7 +661,7 @@ pm_nl_check_endpoint()
 	done
 
 	if [ -z "${id}" ]; then
-		test_fail "bad test - missing endpoint id"
+		fail_test "bad test - missing endpoint id"
 		return
 	fi
 


