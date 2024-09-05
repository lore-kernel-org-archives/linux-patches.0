Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C6313D28F;
	Thu,  5 Sep 2024 10:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530414; cv=none; b=jemV/AznMWB0D17dlbhifByfImvOPXy2Rjv0pm8/MRv2ypj7e3AtmFtm3VBGINmVPMIKFWerXZq8mODBrvVAzBBSl94icoz/jXEuhrXQFLshxxFrUG2T2lqCFT0UHsHkNpSdcfYRIScXT6S3DhAUq8ewyyfnM0H5JKB46oIm7UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530414; c=relaxed/simple;
	bh=SwhGjGjtNWxXjzoBWi2lpcgguM773MLJJm+ma2IG+uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxTxmG5etJ1jorMo0WVj246QKPcWtMiYMavwV/WBQUTLKnlB5+AnJskbeIQaRyOgY8l7fdBKusrdLmp9hV/79TvnNYT4Wmwai6cs525Oj55x//Y1nEwUogOp0cIQvYMriOeUbvAS9D1c1AR9ojSBh+mh82nbHwzXRIjQ+NT/4/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kjz3Vw8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kjz3Vw8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D43AC4CEC3;
	Thu,  5 Sep 2024 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530414;
	bh=SwhGjGjtNWxXjzoBWi2lpcgguM773MLJJm+ma2IG+uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kjz3Vw8hkd6HnTaJlEhomi/leU0PC48X8RxAjv14mNJa+TRQFONT82dNijnociEzw
	 ZtF0HkrZHJ830fxX64wCDPgJxJhxobq3+gUWpfn2mop6wQqs34fssq/VknPC6i+tGf
	 OoZluPlRC3iqhQtqKXT+lK8Tqpx5vIjP7jM5nkWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 017/101] selftests: mptcp: join: validate fullmesh endp on 1st sf
Date: Thu,  5 Sep 2024 11:40:49 +0200
Message-ID: <20240905093716.776062646@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
[ Conflicts in mptcp_join.sh, because the 'run_tests' helper has been
  modified in multiple commits that are not in this version, e.g. commit
  e571fb09c893 ("selftests: mptcp: add speed env var"). The conflict was
  in the context, the new line can still be added at the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3023,6 +3023,7 @@ fullmesh_tests()
 		pm_nl_set_limits $ns1 1 3
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,fullmesh
 		run_tests $ns1 $ns2 10.0.1.1 0 0 fullmesh_1 slow
 		chk_join_nr 3 3 3
 		chk_add_nr 1 1


