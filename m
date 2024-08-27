Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E4F1E487;
	Tue, 27 Aug 2024 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770837; cv=none; b=th2KA5Y1w33ojijl1XSgbZWkTgySnsc8NOOGJwrSRJGUFGLjoVoR/vQMfImgV3RNYqo1FBXn+bNSTBCWOqTh9DZDa6WFofLw8MeZc/2sJJunICz0qcryLLUp5KPd5Ty2+2b5VTYTomZ+D3abXtIU4TsW/ZeXMJOMV4R1na3EDXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770837; c=relaxed/simple;
	bh=uV8v/bUYZCcKrSYnINsz4sB99F9PbAhyWOa493ymxBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZYLWWHRniCKd4FBeAt1UvMR4WLZr1M5kPsHjDEw/vsY7OTt6m72AAtdPzUVllStLCHuSYGPicIWZbizYoVQ1w7l8e5IUS8s3akAUrVcHRlPBELJi9wCXiuLuxptlwvaI/a0hE8JddCvZiC2NM/qAdDdbCCnEN7plfssveIIwTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSDVHrXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSDVHrXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAFAC4AF1C;
	Tue, 27 Aug 2024 15:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770837;
	bh=uV8v/bUYZCcKrSYnINsz4sB99F9PbAhyWOa493ymxBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSDVHrXmFnof3iSLjKkrHfR98qzRDrat4aw1QCjzLvatH6pO+k2zhGEmu8y0MTUS5
	 ptAns4vC+9kenhOHdNzldM+R9nnbr9B99bdYYP0JoU9H/FGaMF80BTCQPhKtO4nmt9
	 MYz3pD9oDxS/E6olFVPeFXfB1IR7jpgL9Q3+yaC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 320/341] selftests: mptcp: join: validate fullmesh endp on 1st sf
Date: Tue, 27 Aug 2024 16:39:11 +0200
Message-ID: <20240827143855.571598140@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 4878f9f8421f4587bee7b232c1c8a9d3a7d4d782 upstream.

This case was not covered, and the wrong ID was set before the previous
commit.

The rest is not modified, it is just that it will increase the code
coverage.

The right address ID can be verified by looking at the packet traces. We
could automate that using Netfilter with some cBPF code for example, but
that's always a bit cryptic. Packetdrill seems better fitted for that.

Fixes: 4f49d63352da ("selftests: mptcp: add fullmesh testcases")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-13-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3220,6 +3220,7 @@ fullmesh_tests()
 		pm_nl_set_limits $ns1 1 3
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,fullmesh
 		fullmesh=1 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3


