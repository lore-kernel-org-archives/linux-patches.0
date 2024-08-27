Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11B017C96;
	Tue, 27 Aug 2024 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771745; cv=none; b=E0rLV4A6OoBilW8bV4g5gUho3rIndj4b3/9Rny9gSZmsVeNk/CCoDLqTWY8asM9SV9gE2Ro+sRX4J1t49THaXzru+h9leDNHxyOmgDt9HTcX1DA92C4xys+cjA9CJPHaURyX70BPS2ljVAdV8NWRtoKuudDldIeceXLzjgyo9Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771745; c=relaxed/simple;
	bh=jvgPA/DpyW3ospZNhxocN0nolptpNCZUXx4d18jKlVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9VP11q1sdDwK83Et2RhiEa0q0dlBk1uLqvNR84XdXXMkv2CHOAPkbS0VZOE+MYNkx8YmIa3LhPSyeXZ296laKu6m8PMdUxbHtlOY5cZMzLjJHwZVvckdOnCW/egrGQm1A6Lk9yY660tbJdnAfIwFu3550mc6V18zlCtTuqlY2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGvF+w5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGvF+w5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EC5C4AF50;
	Tue, 27 Aug 2024 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771745;
	bh=jvgPA/DpyW3ospZNhxocN0nolptpNCZUXx4d18jKlVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGvF+w5Q3SwqxQZ0NuNVqWL3uugXmRacpbdmZKostznYDPIdrQgPComd3wIgqsfVV
	 oHsTXFcSa6wdkqZmCgqu02XYWcSwCjglgfzzeNnf2jADX7kIBHK1drK7rh5lL8Oe/t
	 CYvw9CIyXrtvDqBEXCCKqf+iwAgQep+l2RucfDxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 265/273] selftests: mptcp: join: validate fullmesh endp on 1st sf
Date: Tue, 27 Aug 2024 16:39:49 +0200
Message-ID: <20240827143843.483948057@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
@@ -3058,6 +3058,7 @@ fullmesh_tests()
 		pm_nl_set_limits $ns1 1 3
 		pm_nl_set_limits $ns2 1 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,fullmesh
 		fullmesh=1 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3


